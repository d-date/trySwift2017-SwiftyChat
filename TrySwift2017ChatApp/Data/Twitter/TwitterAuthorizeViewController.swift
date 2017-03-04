//
//  ViewController.swift
//  TwitterDemo
//
//  Created by Ravi Shankar on 04/03/17.
//  Copyright © 2017 Ravi Shankar. All rights reserved.
//

import UIKit
import SwiftyJSON

class TwitterAuthorizeViewController: UIViewController {
    var ownList = TwitterMessageListEntity(list: [])
    var senderList = TwitterMessageListEntity(list: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

//    @IBAction func login(_ sender: Any) {
//        let loginController = FHSTwitterEngine.shared().loginController { (success) -> Void in
//            guard let results = FHSTwitterEngine.shared().getDirectMessages(50) else {
//                return
//            }
//            let jsons = JSON(results).arrayValue
//            var recipientList: [TwitterMessageEntity] = []
//            var senderList: [TwitterMessageEntity] = []
//            for json in jsons {
//                let recipient = TwitterTranslator().translate(from: json["recipient"], isOwned: true)
//                let sender = TwitterTranslator().translate(from: json["sender"], isOwned: false)
//                recipientList.append(recipient)
//                senderList.append(sender)
//            }
//            
//            self.ownList.list.append(contentsOf: recipientList)
//            self.senderList.list.append(contentsOf: senderList)
//            } as UIViewController
//        self .present(loginController, animated: true, completion: nil)
//    }
    
}

