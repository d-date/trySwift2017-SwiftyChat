//
//  UsersModel.swift
//  TestSlack
//
//  Created by 李慶燦 on 2017/03/04.
//  Copyright © 2017年 李慶燦. All rights reserved.
//

import Foundation
import Firebase

class UsersModel {
    var users = [UsersDTO]()
    let ref = FIRDatabase.database().reference()
    
    func getUsers(completion : @escaping (String?) -> Void) {
        ref.child("users").observe(.value, with: { [weak self] snapshot in
            guard let dict = snapshot.value as? [String: Any] else {
                return completion("can not find data.")
            }
            
            let sortedDic = dict.sorted(by: { (o1, o2) -> Bool in
                return o1.key < o2.key
            })
            
            self?.users.removeAll()
            
            for info in sortedDic {
                let userId = info.key
                
                if let currentUserId = AppUtility.getUserId() {
                    if (userId == currentUserId) {
                        continue
                    }
                }
                
                guard let userDic = info.value as? NSDictionary else {continue}
                guard let userName = userDic["username"] as? String else {continue}
                guard let avatarUrl = userDic["avatarurl"] as? String else {continue}
                
                let user = UsersDTO(userId: userId, userName: userName, avatarUrl: avatarUrl)
                self?.users.append(user)
            }
            
            return completion(nil)
        })
    }
    
    func setListener() {
        ref.observe(.value, with: { [weak self] snapshot in
            guard let dict = snapshot.value as? [String: Any] else {
                return
            }
            
            let sortedDic = dict.sorted(by: { (o1, o2) -> Bool in
                return o1.key < o2.key
            })
            
            for info in sortedDic {
                let conversationId = info.key
                if (!conversationId.contains(",")) {
                    continue
                }
                
                guard let messages = info.value as? [String: Any] else {
                    print("have no message.")
                    continue
                }
                
                let sortedDic = messages.sorted(by: { (o1, o2) -> Bool in
                    return o1.key < o2.key
                })
                
                guard let info = sortedDic.last else {
                    print("have no last message.")
                    continue
                }
                
                guard let msgDic = info.value as? NSDictionary else {
                    print("have no message dic.")
                    continue
                }
                
                guard let msg = msgDic["content"] as? String else {
                    print("no message string.")
                    continue
                }
                
                guard let dateTime = msgDic["time"] as? String else {
                    print("no time string.")
                    continue
                }
                var time = (dateTime as NSString).substring(from: 11)
                time = (time as NSString).substring(to: 5)
                
                guard let targetUsers = self?.users else {
                    print("no target users")
                    continue
                }
                for targetUser in targetUsers {
                    if (conversationId.contains(targetUser.userId)) {
                        targetUser.lastMessage.value = msg
                        if let lastMsg = SQLiteManager.sharedInstance.getLastMessageTime(targetUserId: targetUser.userId) {
                            targetUser.isReaded.value = lastMsg == time
                        }
                        targetUser.lastMessageTime.value = time
                        
                        break
                    }
                }
            }
        })
    }
}
