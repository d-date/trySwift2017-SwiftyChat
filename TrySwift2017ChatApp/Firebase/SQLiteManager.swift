//
//  SQLiteManager.swift
//  MyReader
//
//  Created by RN-079 on 2017/02/21.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import Foundation
import SQLite

class SQLiteManager {
    var db : Connection!
    var table_chats: Table!
    
    class var sharedInstance : SQLiteManager {
        struct Static {
            static let instance : SQLiteManager = SQLiteManager()
        }
        
        return Static.instance
    }

    func createDB() {
        if db != nil {
            return
        }
        
        guard let sqlitePath = AppUtility.getSQLitePath() else {
            return
        }
        
        do {
            db = try Connection(sqlitePath)
            
            table_chats = Table("Chats")
            let targetUserId = Expression<String>("targetUserId")
            let lastMessageTime = Expression<String>("lastMessageTime")
            let lastMessage = Expression<String>("lastMessage")
            
            try db?.run(table_chats!.create{ table in
                table.column(targetUserId, primaryKey: true)
                table.column(lastMessageTime)
                table.column(lastMessage)
            })
        } catch {
            print("11111")
        }
    }
    
    func insertChat(usersInfo: UsersDTO) {
        if (table_chats == nil) {
            return
        }

        do {
            let statement = try db.prepare("insert into Chats (targetUserId, lastMessageTime, lastMessage) values (?, ?, ?)")
            try statement.run([usersInfo.userId, usersInfo.lastMessageTime.value, usersInfo.lastMessage.value])
            
            let totalChanges = db.totalChanges
            let changes = db.changes
            let lastInsertRowId = db.lastInsertRowid
            
            print("total changes = \(totalChanges), changes = \(changes), last insert row id = \(lastInsertRowId)")
        } catch {
            print("fail to insert.")
        }
    }
    
    func getLastMessageTime(targetUserId: String) -> String? {
        do {
            for row in try db.prepare("select  from Chats where targetUserId = \(targetUserId)") {
//                guard let targetUserId = row[0] as? String else {continue}
                guard let lastMessageTime = row[1] as? String else {continue}
//                guard let lastMessage = row[2] as? String else {continue}
                
                return lastMessageTime
            }
        } catch {
            print("fail to get data.")
        }
        
        return nil
    }
}
