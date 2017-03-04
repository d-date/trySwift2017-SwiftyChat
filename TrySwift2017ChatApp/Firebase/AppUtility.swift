//
//  AppUtility.swift
//  TestSlack
//
//  Created by 李慶燦 on 2017/03/04.
//  Copyright © 2017年 李慶燦. All rights reserved.
//

import Foundation
import JSQMessagesViewController

class AppUtility {
    static func getUserId() -> String? {
        if let userId = UserDefaults.standard.object(forKey: UDKey.UserId) as? String {
            return userId
        }
        
        return nil
    }
    
    static func getMessageId() -> String {
        return String(UInt64(Date().timeIntervalSince1970))
    }
    
    static func getDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        return formatter
    }
    
    static func getAvatar(_ id: String) -> JSQMessagesAvatarImage{
        return JSQMessagesAvatarImageFactory.avatarImage(withPlaceholder: UIImage(named:"rico_green")!, diameter : 20)!
    }
    
    static func getConversationId(userId1: String, userId2:String) -> String {
        var array = [userId1, userId2]
        array.sort()
        let result = array.joined(separator: ",")
        print("conv id = \(result)")
        return result
    }
    
    static func getSQLitePath() -> String? {
        // path document
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        guard let documentPath = paths.first else {
            return nil
        }
        
        let path = documentPath + "/swiftychat.sqlite3"
        return path
    }
}
