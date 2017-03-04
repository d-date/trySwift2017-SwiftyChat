//
//  LinkAccountViewController.swift
//  TrySwift2017ChatApp
//
//  Created by 田中賢治 on 2017/03/04.
//  Copyright © 2017年 田中賢治. All rights reserved.
//

import UIKit
import SwiftyJSON

class LinkAccountViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "LinkAccount"
        
        tableView.register(UINib(nibName: "LinkAccountTableViewCell", bundle: nil), forCellReuseIdentifier: "LinkAccountTableViewCell")
        FHSTwitterEngine.shared().permanentlySetConsumerKey(twitterConsumerKey, andSecret: twitterSecretKey)
        FHSTwitterEngine.shared().loadAccessToken()
    }
    
    func presentAlert(_ isError: Bool) {
        let message: String
        switch isError {
        case true:
            message = "Authorize failure!"
        case false:
            message = "Authorize successfully!"
        }
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let action1 = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            print("アクション１をタップした時の処理")
        })
        
        alert.addAction(action1)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func didSelectTwitter() {
        let loginController = FHSTwitterEngine.shared().loginController { (success) -> Void in
            self.presentAlert(success)
            guard let results = FHSTwitterEngine.shared().getDirectMessages(50) else {
                self.presentAlert(true)
                return
            }
            self.presentAlert(false)
//            self.ownList.list.append(contentsOf: recipientList)
//            self.senderList.list.append(contentsOf: senderList)
            } as UIViewController
        self .present(loginController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ToName") {
            guard let next = segue.destination as? NameController else {
                return
            }
            
            next.modalPresentationStyle = .custom
        }
    }
}

extension LinkAccountViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 112
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let _ = UserDefaults.standard.object(forKey: UDKey.UserId) as? String {
            performSegue(withIdentifier: "ToUsers", sender: nil)
        } else {
            performSegue(withIdentifier: "ToName", sender: nil)
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension LinkAccountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LinkAccountTableViewCell") as! LinkAccountTableViewCell
        cell.setup(withIndex: indexPath.row)
        return cell
    }
}
