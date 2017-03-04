import UIKit
import JSQMessagesViewController
import FirebaseDatabase

class ChatController: JSQMessagesViewController {
    // param.
    var conversationId : String!
    var conversationTitle : String!

    let ref = FIRDatabase.database().reference()

    var isFirstLoad = true
    
    var messages = [MyMessage]()
    let defaults = UserDefaults.standard
    var conversation: Conversation?
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    fileprivate var displayName: String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(conversationId: String, targetUserName: String) {
        self.init(nibName: nil, bundle: nil)
        
        self.conversationId = conversationId
        self.conversationTitle = "talking with \(targetUserName)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation titleの設定
        self.navigationItem.title = conversationTitle
        
        var userId = ""
        var userName = ""
        if let id = UserDefaults.standard.object(forKey: UDKey.UserId) as? String {
            userId = id
        }
        if let name = UserDefaults.standard.object(forKey: UDKey.UserName) as? String {
            userName = name
        }
        
        self.senderId = userId
        self.senderDisplayName = userName
        
        // chat bubble format.
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        
        // avatar format.
        collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height: kJSQMessagesCollectionViewAvatarSizeDefault)
        collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        
        // This is a beta feature that mostly works but to make things more stable it is diabled.
        collectionView?.collectionViewLayout.springinessEnabled = false
        
        automaticallyScrollsToMostRecentMessage = true
        
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
        
        // 初期表示用データを取得.
        receiveFirstMessage()
        
        // リアルタイムデータ取得.
        receiveMessage()
    }
    
    // MARK: JSQMessagesViewController method overrides
    override func didPressSend(_ button: UIButton, withMessageText text: String, senderId: String, senderDisplayName: String, date: Date) {
        /**
         *  Sending a message. Your implementation of this method should do *at least* the following:
         *
         *  1. Play sound (optional)
         *  2. Add new id<JSQMessageData> object to your data source
         *  3. Call `finishSendingMessage`
         */
        
        let messageId = String(UInt64(Date().timeIntervalSince1970))
        
        guard let message = MyMessage(messageId: messageId, senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text) else {return}

        self.messages.append(message)
        self.finishSendingMessage(animated: true)
        
        // firebaseにデータを送る.
        sendMessageToFirebase(message: message)
    }
    
    private func sendMessageToFirebase(message: MyMessage) {
        let timeStr = AppUtility.getDateFormatter().string(from: message.date)
        
        var messageDic = [String: Any]()
        messageDic["id"] = message.messageId
        messageDic["userId"] = self.senderId
        messageDic["userName"] = self.senderDisplayName
        messageDic["time"] = timeStr
        messageDic["content"] = message.text
        
        let key = "message\(message.messageId)"
        var resultDic = [String: Any]()
        resultDic[key] = messageDic
        
        ref.child(conversationId).updateChildValues(resultDic)
    }
    
    private func receiveFirstMessage() {
        ref.child(self.conversationId).observeSingleEvent(of: .value, with: { [weak self] snapshot in
            
            guard let dict = snapshot.value as? [String: Any] else {
                return
            }
            
            let sortedDic = dict.sorted(by: { (o1, o2) -> Bool in
                return o1.key < o2.key
            })
            
            self?.showMessages(resultDic: sortedDic)
        })
    }
    
    private func receiveMessage() {
        ref.child(self.conversationId).observe(.value, with: { [weak self] snapshot in
            guard let dict = snapshot.value as? [String: Any] else {
                return
            }
            
            let sortedDic = dict.sorted(by: { (o1, o2) -> Bool in
                return o1.key < o2.key
            })
            
            self?.addNewMessage(resultDic: sortedDic)
        })
    }
    
    private func showMessages(resultDic: [(key: String, value: Any)]) {
        for resultInfo in resultDic {
            guard let messageDic = resultInfo.value as? [String: Any] else {continue}
            
            guard let messageId = messageDic["id"] else {continue}
            guard let timeStr = messageDic["time"] as? String else {continue}
            guard let content = messageDic["content"] as? String else {continue}
            guard let userId = messageDic["userId"] as? String else {continue}
            guard let userName = messageDic["userName"] as? String else {continue}
            
            let dateTime = AppUtility.getDateFormatter().date(from: timeStr)
            let messageIdStr = "\(messageId)"
            
            guard let message = MyMessage(messageId: messageIdStr, senderId: userId, senderDisplayName: userName, date: dateTime, text: content) else {continue}
            messages.append(message)
        }
        self.finishReceivingMessage(animated: true)
    }
    
    private func addNewMessage(resultDic : [(key: String, value : Any)]) {
        for resultInfo in resultDic {
            guard let messageDic = resultInfo.value as? [String : Any] else {continue}
            guard let messageId = messageDic["id"] else {continue}
            guard let timeStr = messageDic["time"] as? String else {continue}
            guard let content = messageDic["content"] as? String else {continue}
            guard let userId = messageDic["userId"] as? String else {continue}
            guard let userName = messageDic["userName"] as? String else {continue}
            
            let dateTime = AppUtility.getDateFormatter().date(from: timeStr)
            let messageIdStr = "\(messageId)"
            
            var hasMsg = false
            for subMsg in messages {
                if (subMsg.messageId == messageIdStr) {
                    hasMsg = true
                    break
                }
            }
            
            if (!hasMsg) {
                guard let message = MyMessage(messageId: messageIdStr
                    , senderId: userId
                    , senderDisplayName: userName
                    , date: dateTime
                    , text: content) else {return}
                
                messages.append(message)
            }
        }
        
        finishReceivingMessage(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    override func didPressAccessoryButton(_ sender: UIButton) {
        self.inputToolbar.contentView!.textView!.resignFirstResponder()
        
        let sheet = UIAlertController(title: "Media messages", message: nil, preferredStyle: .actionSheet)
        
        let photoAction = UIAlertAction(title: "Send photo", style: .default) { (action) in
            /**
             *  Create fake photo
             */
            guard let photoItem = JSQPhotoMediaItem(image: UIImage(named: "goldengate")) else {return}
            self.addMedia(photoItem)
        }
        
        let locationAction = UIAlertAction(title: "Send location", style: .default) { (action) in
            /**
             *  Add fake location
             */
            let locationItem = self.buildLocationItem()
            
            self.addMedia(locationItem)
        }
        
        let videoAction = UIAlertAction(title: "Send video", style: .default) { (action) in
            /**
             *  Add fake video
             */
            guard let videoItem = self.buildVideoItem() else {return}
            
            self.addMedia(videoItem)
        }
        
        let audioAction = UIAlertAction(title: "Send audio", style: .default) { (action) in
            /**
             *  Add fake audio
             */
            let audioItem = self.buildAudioItem()
            
            self.addMedia(audioItem)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        sheet.addAction(photoAction)
        sheet.addAction(locationAction)
        sheet.addAction(videoAction)
        sheet.addAction(audioAction)
        sheet.addAction(cancelAction)
        
        self.present(sheet, animated: true, completion: nil)
    }
    
    func buildVideoItem() -> JSQVideoMediaItem? {
        let videoURL = URL(fileURLWithPath: "file://")
        
        let videoItem = JSQVideoMediaItem(fileURL: videoURL, isReadyToPlay: true)
        return videoItem
    }
    
    func buildAudioItem() -> JSQAudioMediaItem {
        let sample = Bundle.main.path(forResource: "jsq_messages_sample", ofType: "m4a")
        let audioData = try? Data(contentsOf: URL(fileURLWithPath: sample!))
        
        let audioItem = JSQAudioMediaItem(data: audioData)
        
        return audioItem
    }
    
    func buildLocationItem() -> JSQLocationMediaItem {
        let ferryBuildingInSF = CLLocation(latitude: 37.795313, longitude: -122.393757)
        
        let locationItem = JSQLocationMediaItem()
        locationItem.setLocation(ferryBuildingInSF) {
            self.collectionView!.reloadData()
        }
        
        return locationItem
    }
    
    func addMedia(_ media:JSQMediaItem) {
        let messageId = AppUtility.getMessageId()
        
        guard let message = MyMessage(messageId: messageId, senderId: senderId, senderDisplayName: self.senderDisplayName, date: Date(), media: media) else {return}
        self.messages.append(message)
        self.finishSendingMessage(animated: true)
    }
    
    func doEnd(_ sender : UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
        
        return messages[indexPath.item].senderId == self.senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = messages[indexPath.item]
        return AppUtility.getAvatar(message.senderId)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  Show a timestamp for every 3rd message
         */
        if (indexPath.item % 3 == 0) {
            let message = self.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = messages[indexPath.item]
        if message.senderId == self.senderId {
            return nil
        }
        
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  iOS7-style sender name labels
         */
        let currentMessage = self.messages[indexPath.item]
        
        if currentMessage.senderId == self.senderId {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
}
