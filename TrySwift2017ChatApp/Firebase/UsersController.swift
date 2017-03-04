//
//  UsersController.swift
//  TestSlack
//
//  Created by 李慶燦 on 2017/03/04.
//  Copyright © 2017年 李慶燦. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class UsersController: UIViewController {
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var indicator : UIActivityIndicatorView!

    let model = UsersModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        getData()
        model.setListener()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    private func getData() {
        indicator.startAnimating()
        model.getUsers {[weak self] msg in
            self?.indicator.stopAnimating()
            if let errorMsg = msg {
                print("error = \(errorMsg)")
            }
            
            self?.tableView.reloadData()
        }
    }
}

extension UsersController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let info = model.users[indexPath.row]
        SQLiteManager.sharedInstance.insertChat(usersInfo: info)
        info.isReaded.value = true
        
        guard let selfUserId = AppUtility.getUserId() else {return}
        let conversationId = AppUtility.getConversationId(userId1: selfUserId, userId2: info.userId)
        let chatController = ChatController(conversationId: conversationId, targetUserName: info.userName)
        self.navigationController?.pushViewController(chatController, animated: true)
    }
}

extension UsersController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath)
        if let usersCell = cell as? UsersCell {
            let info = model.users[indexPath.row]
            usersCell.userNameLbl.text = info.userName
            if let url = URL(string: info.avatarUrl) {
                usersCell.avatarView.kf.setImage(with: url)
            } else {
                usersCell.avatarView.image = UIImage(named: "rico_green")
            }
            info.lastMessage.asObservable().bindTo(usersCell.chatLbl.rx.text).addDisposableTo(usersCell.disposeBag)
            info.lastMessageTime.asObservable().bindTo(usersCell.timeLbl.rx.text).addDisposableTo(usersCell.disposeBag)
            info.isReaded.asObservable().bindTo(usersCell.unreadView.rx.isHidden).addDisposableTo(usersCell.disposeBag)
        }
        return cell
    }
}
