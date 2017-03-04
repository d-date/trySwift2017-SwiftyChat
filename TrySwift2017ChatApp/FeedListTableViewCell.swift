//
//  FeedTableViewCell.swift
//  TrySwift2017ChatApp
//
//  Created by 田中賢治 on 2017/03/04.
//  Copyright © 2017年 田中賢治. All rights reserved.
//

import UIKit
import Kingfisher

class FeedListTableViewCell: UITableViewCell {
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var feedNameLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        feedImageView.backgroundColor = UIColor.red
        serviceImageView.backgroundColor = UIColor.red
    }
    
    func setup(with serviceType: ServiceType, iconUrl: String, lastMessage: String) {
        if let url = URL(string: iconUrl) {
            feedImageView.kf.setImage(with: url)
        }
        serviceImageView.image = serviceType.image
        
        feedNameLabel.text = serviceType.name
        lastMessageLabel.text = lastMessage
    }
}
