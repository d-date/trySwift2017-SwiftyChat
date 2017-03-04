//
//  Message.swift
//  trySwift2017-SwiftyChat
//
//  Created by 廣瀬雄大 on 2017/03/04.
//  Copyright © 2017年 廣瀬雄大. All rights reserved.
//

import Foundation

protocol MessageEntity {
    associatedtype UserType = UserEntity
    
    var isOwnMessage: Bool { get set }
    var messageType: MessageType { get set }
    var message: String? { get set }
    var imageUrls: [String] { get set }
    
    var user: UserType { get set }
}

struct TwitterMessageEntity: MessageEntity {
    var isOwnMessage: Bool
    var messageType: MessageType
    var message: String?
    var imageUrls: [String]
    var user: TwitterUserEntity
    
    init(
        isOwnMessage: Bool,
        messageType: MessageType = .unknown,
        message: String?,
        imageUrls: [String],
        user: TwitterUserEntity
        ) {
        self.isOwnMessage = isOwnMessage
        self.messageType = messageType
        self.message = message
        self.imageUrls = imageUrls
        self.user = user
    }
}

struct SlackMessageEntity: MessageEntity {
    var isOwnMessage: Bool
    var messageType: MessageType
    var message: String?
    var imageUrls: [String]
    var user: SlackUserEntity
    
    init(
        isOwnMessage: Bool,
        messageType: MessageType = .unknown,
        message: String?,
        imageUrls: [String],
        user: SlackUserEntity
        ) {
        self.isOwnMessage = isOwnMessage
        self.messageType = messageType
        self.message = message
        self.imageUrls = imageUrls
        self.user = user
    }

}

struct GoogleMessageEntity: MessageEntity {
    var isOwnMessage: Bool
    var messageType: MessageType
    var message: String?
    var imageUrls: [String]
    var user: UserEntity
    
    init(
        isOwnMessage: Bool,
        messageType: MessageType = .unknown,
        message: String?,
        imageUrls: [String],
        user: GoogleUserEntity
        ) {
        self.isOwnMessage = isOwnMessage
        self.messageType = messageType
        self.message = message
        self.imageUrls = imageUrls
        self.user = user
    }
}



