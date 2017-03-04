//
//  MessageListEntity.swift
//  trySwift2017-SwiftyChat
//
//  Created by 廣瀬雄大 on 2017/03/04.
//  Copyright © 2017年 廣瀬雄大. All rights reserved.
//

import Foundation

protocol MessageListEntity {
    associatedtype EntityType
    var list: [EntityType] { get }
}

struct TwitterMessageListEntity: MessageListEntity {
    var list: [TwitterMessageEntity]
}

struct SlackMessageListEntity: MessageListEntity {
    var list: [SlackMessageEntity]
}

struct GoogleMessageListEntity: MessageListEntity {
    var list: [GoogleMessageEntity]
}



