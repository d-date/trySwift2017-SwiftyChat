//
//  AppCommon.swift
//  TestSlack
//
//  Created by 李慶燦 on 2017/03/04.
//  Copyright © 2017年 李慶燦. All rights reserved.
//

import Foundation

struct UDKey {
    static var UserId = "userid"
    static var UserName = "username"
    static var AvatarUrl = "avatarurl"
}

struct Conversation {
    let firstName: String?
    let lastName: String?
    let preferredName: String?
    let smsNumber: String
    let id: String?
    let latestMessage: String?
    let isRead: Bool
}
