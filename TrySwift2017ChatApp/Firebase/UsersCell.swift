//
//  UsersCell.swift
//  TestSlack
//
//  Created by 李慶燦 on 2017/03/04.
//  Copyright © 2017年 李慶燦. All rights reserved.
//

import UIKit
import RxSwift

class UsersCell: UITableViewCell {
    @IBOutlet weak var avatarView : UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var chatLbl : UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var unreadView: UIView!
    
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarView.image = nil
        userNameLbl.text = nil
        chatLbl.text = nil
        
        disposeBag = DisposeBag()
    }
}
