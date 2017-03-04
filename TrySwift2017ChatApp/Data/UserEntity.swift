//
//  UserEntity.swift
//  trySwift2017-SwiftyChat
//
//  Created by 廣瀬雄大 on 2017/03/04.
//  Copyright © 2017年 廣瀬雄大. All rights reserved.
//

import Foundation

protocol UserEntity {
    var id: String? { get }
    var name: String? { get }
    var subName: String? { get }
    var iconUrl: String? { get }
}

struct TwitterUserEntity: UserEntity {
    let id: String?
    let name: String?
    let subName: String?
    let iconUrl: String? 
}

struct SlackUserEntity: UserEntity {
    let id: String?
    let name: String?
    let subName: String?
    let iconUrl: String? 
}

struct GoogleUserEntity: UserEntity {
    let id: String?
    let name: String?
    let subName: String?
    let iconUrl: String? 
}
