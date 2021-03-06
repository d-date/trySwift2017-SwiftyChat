//
//  LinkAccountTableViewCell.swift
//  TrySwift2017ChatApp
//
//  Created by 田中賢治 on 2017/03/04.
//  Copyright © 2017年 田中賢治. All rights reserved.
//

import UIKit

class LinkAccountTableViewCell: UITableViewCell {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    
    func setup(withIndex index: Int) {
        if index == 0 {
            backgroundImageView.image = #imageLiteral(resourceName: "slack-background")
            serviceImageView.image = #imageLiteral(resourceName: "slack-icon")
            serviceLabel.text = "Slack"
        }  else if index == 1 {
            backgroundImageView.image = #imageLiteral(resourceName: "twitter-background")
            serviceImageView.image = #imageLiteral(resourceName: "twitter-icon")
            serviceLabel.text = "Twitter"
        } else {
            backgroundImageView.image = #imageLiteral(resourceName: "bk_firebase")
            serviceImageView.image = #imageLiteral(resourceName: "google_firebase")
            serviceLabel.text = "Firebase"
        }
        
        serviceLabel.textColor = .white
    }
}
