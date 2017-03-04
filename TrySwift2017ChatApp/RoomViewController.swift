//
//  RoomViewController.swift
//  TrySwift2017ChatApp
//
//  Created by 田中賢治 on 2017/03/04.
//  Copyright © 2017年 田中賢治. All rights reserved.
//

import JSQMessagesViewController
import UIKit
import Kingfisher
import SwiftyJSON
import Alamofire

class RoomViewController: JSQMessagesViewController {
    var messages: [JSQMessage] = []
    
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    var incomingAvatar: JSQMessagesAvatarImage!
    let userIcon = JSQMessagesBubbleImage(messageBubble: #imageLiteral(resourceName: "UserIcon"), highlightedImage: #imageLiteral(resourceName: "UserIcon"))
    
    var senderIcon: UIImage?
    override func viewDidLoad() {
        Alamofire.request("https://pbs.twimg.com/profile_images/830074140644106240/3OWdm9mb_normal.jpg").responseData { response in
            guard let image = UIImage(data: response.data!) else {
                return
            }
            
            if let image = response.result.value {
                print("image downloaded: \(image)")
            }
            
            self.collectionView?.reloadData()
            self.senderIcon = image
            self.setupInitialSettings()
        }
        super.viewDidLoad()
        
        title = "Room Name"
        
        setupInitialSettings()
        
        // Show Button to simulate incoming messages
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage.jsq_defaultTypingIndicator(), style: .plain, target: self, action: #selector(receiveMessagePressed))
        
        // This is a beta feature that mostly works but to make things more stable it is diabled.
        collectionView?.collectionViewLayout.springinessEnabled = false
        
        automaticallyScrollsToMostRecentMessage = true
        
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTwitterList()
    }
    
    var ownList = TwitterMessageListEntity(list: [])
    var senderList = TwitterMessageListEntity(list: [])
    
    func fetchTwitterList() {
        guard let results = FHSTwitterEngine.shared().getDirectMessages(20) else {
            collectionView.reloadData()
            return
        }
        let jsons = JSON(results).arrayValue
        var recipientList: [TwitterMessageEntity] = []
        var senderList: [TwitterMessageEntity] = []
        for json in jsons {
            let text = json["text"].stringValue
            let recipient = TwitterTranslator().translate(from: json["recipient"], isOwned: true, text: text)
            let sender = TwitterTranslator().translate(from: json["sender"], isOwned: false, text: text)
            recipientList.append(recipient)
            senderList.append(sender)
        }
        
        self.ownList = TwitterMessageListEntity(list: recipientList)
        self.senderList = TwitterMessageListEntity(list: senderList)
        
        collectionView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupInitialSettings() {
        self.senderId = "self"
        self.senderDisplayName = "ダンボー田中"
        
        // 吹き出しの色設定
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
        self.outgoingBubble = bubbleFactory!
            .outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleGreen())
        
        // 相手の画像設定
        if let sendreIcon = senderIcon {
            self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImage(with: sendreIcon, diameter: 64)
        }
    }
    
    // For DEMO only
    func receiveMessagePressed(_ sender: UIBarButtonItem) {
        self.showTypingIndicator = !self.showTypingIndicator
        self.scrollToBottom(animated: true)

        let message = JSQMessage(senderId: "Jobs", displayName: "Jobs", text: "First received!")!
        messages.append(message)
        finishReceivingMessage(animated: true)
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)!
        messages.append(message)
        finishSendingMessage(animated: true)
    }
    
    // MARK: - JSQMessagesCollectionViewDataSource
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        if message.senderId == senderId {
            return outgoingBubble
        }
        
        return incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
//        let message = messages[indexPath.item]
//        if message.senderId == senderId {
//            return outgoingAvatar
//        }
        
        return incomingAvatar
    }
    
    
    // MARK: - UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // MARK: -
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = messages[indexPath.item]
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}
