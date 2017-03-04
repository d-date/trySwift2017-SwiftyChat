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
    
    var ownList = TwitterMessageListEntity(list: [])
    var senderList = TwitterMessageListEntity(list: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "FeedListTableViewCell", bundle: nil), forCellReuseIdentifier: "FeedListTableViewCell")
    }
    
    func fetchTwitterList() {
        guard let results = FHSTwitterEngine.shared().getDirectMessages(50) else {
            return
        }
        let jsons = JSON(results).arrayValue
        var recipientList: [TwitterMessageEntity] = []
        var senderList: [TwitterMessageEntity] = []
        for json in jsons {
            let recipient = TwitterTranslator().translate(from: json["recipient"], isOwned: true)
            let sender = TwitterTranslator().translate(from: json["sender"], isOwned: false)
            recipientList.append(recipient)
            senderList.append(sender)
        }
        
        self.ownList.list.append(contentsOf: recipientList)
        self.senderList.list.append(contentsOf: senderList)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedListTableViewCell") as! FeedListTableViewCell
//        cell.setup(with: .twitter, iconUrl: , lastMessage: <#T##String#>)
        return cell
    }
}
