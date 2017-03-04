//
//  MessageListListTranslator.swift
//  trySwift2017-SwiftyChat
//
//  Created by 廣瀬雄大 on 2017/03/04.
//  Copyright © 2017年 廣瀬雄大. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ListTranslator {
    associatedtype Output
    func asArray(from json: JSON) -> [JSON]
    func translate(from json: JSON, isOwned: Bool) -> Output 
}


struct TwitterListTranslator: ListTranslator {
    func asArray(from json: JSON) -> [JSON] {
        return json[""].arrayValue
    }
    func translate(from json: JSON, isOwned: Bool) -> TwitterMessageListEntity {
        return TwitterMessageListEntity (
            list: asArray(from: json).map { TwitterTranslator().translate(from: $0, isOwned: isOwned) }
        )
    }
}

struct SlackListTranslator: ListTranslator {
    func asArray(from json: JSON) -> [JSON] {
        return json[""].arrayValue
    }
    func translate(from json: JSON, isOwned: Bool) -> SlackMessageListEntity {
        return SlackMessageListEntity (
            list: asArray(from: json).map { SlackTranslator().translate(from: $0, isOwned: isOwned) }
        )
    }
}

struct GoogleListTranslator: ListTranslator {
    func asArray(from json: JSON) -> [JSON] {
        return json[""].arrayValue
    }
    func translate(from json: JSON, isOwned: Bool) -> GoogleMessageListEntity {
        return GoogleMessageListEntity (
            list: asArray(from: json).map { GoogleTranslator().translate(from: $0, isOwned: isOwned) }
        )
    }
}

