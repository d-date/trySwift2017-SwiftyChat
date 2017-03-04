//
//  UsersDTO.swift
//  TestSlack
//
//  Created by 李慶燦 on 2017/03/04.
//  Copyright © 2017年 李慶燦. All rights reserved.
//

import Foundation
import RxSwift

class UsersDTO : AnyObject {
    var userId: String
    var userName: String
    var avatarUrl: String
    var lastMessage = Variable("")
    var lastMessageTime = Variable("now")
    var isReaded = Variable(false)
    
    init(userId: String, userName: String, avatarUrl: String) {
        self.userId = userId
        self.userName = userName
        self.avatarUrl = avatarUrl
    }
}
