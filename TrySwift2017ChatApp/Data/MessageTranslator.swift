//
//  MessageConverter.swift
//  trySwift2017-SwiftyChat
//
//  Created by 廣瀬雄大 on 2017/03/04.
//  Copyright © 2017年 廣瀬雄大. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol EntityTranslator {
    associatedtype Output
    func translate(from json: JSON, isOwned: Bool) -> Output
}

struct TwitterTranslator: EntityTranslator {
    func translate(from json: JSON, isOwned: Bool) -> TwitterMessageEntity {
        return TwitterMessageEntity (
            isOwnMessage: isOwned,
            messageType: .unknown,
            message: json["text"].rawString(),
            imageUrls: [],
            user: TwitterUserEntity(
                id: json["id"].rawString(),
                name: json["screen_name"].rawString(),
                subName: json["name"].rawString(),
                iconUrl: json["profile_image_url"].rawString()
            )
        )
    }
}

struct SlackTranslator: EntityTranslator {
    func translate(from json: JSON, isOwned: Bool) -> SlackMessageEntity {
        return SlackMessageEntity (
            isOwnMessage: json[""].boolValue,
            messageType: .unknown,
            message: json[""].rawString(),
            imageUrls: json[""].arrayValue.flatMap { $0.rawString() },
            user: SlackUserEntity(
                id: json[""].rawString(),
                name: json[""].rawString(),
                subName: json[""].rawString(),
                iconUrl: json[""].rawString()
            )
        )
    }
}

struct GoogleTranslator: EntityTranslator {
    func translate(from json: JSON, isOwned: Bool) -> GoogleMessageEntity {
        return GoogleMessageEntity (
            isOwnMessage: json[""].boolValue,
            messageType: .unknown,
            message: json[""].rawString(),
            imageUrls: json[""].arrayValue.flatMap { $0.rawString() },
            user: GoogleUserEntity(
                id: json[""].rawString(),
                name: json[""].rawString(),
                subName: json[""].rawString(),
                iconUrl: json[""].rawString()
            )
        )
    }
}
