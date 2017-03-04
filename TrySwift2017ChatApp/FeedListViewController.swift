//
//  FeedListViewController.swift
//  TrySwift2017ChatApp
//
//  Created by 田中賢治 on 2017/03/04.
//  Copyright © 2017年 田中賢治. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeedListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var tapCellAction: (() -> ())!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FeedListTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedListTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchTwitterList()
    }
    
    var ownList = TwitterMessageListEntity(list: [])
    var senderList = TwitterMessageListEntity(list: [])
    
    func fetchTwitterList() {
        guard let results = FHSTwitterEngine.shared().getDirectMessages(20) else {
            tableView.reloadData()
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
        
        tableView.reloadData()
    }
}


extension FeedListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tapCellAction()
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension FeedListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return senderList.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedListTableViewCell") as! FeedListTableViewCell
        let element = senderList.list[indexPath.row]
        if 
            let imageUrl = element.user.iconUrl,
            let message  = element.message {
            cell.setup(with: .twitter, iconUrl: imageUrl, lastMessage: message)
        }
        return cell
    }
}
