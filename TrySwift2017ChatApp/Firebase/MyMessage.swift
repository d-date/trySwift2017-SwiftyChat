//
//  MyMessage.swift
//  Demo
//
//  Created by RN-079 on 2017/01/13.
//  Copyright © 2017年 RN-079. All rights reserved.
//

import JSQMessagesViewController

class MyMessage : JSQMessage {
    var messageId: String
    
    init!(messageId: String, senderId: String!, senderDisplayName: String!, date: Date!, media: JSQMessageMediaData!) {
        self.messageId = messageId
        super.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, media: media)
    }
    
    init!(messageId: String, senderId: String!, senderDisplayName: String!, date: Date!, text: String!) {
        self.messageId = messageId
        super.init(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.messageId = AppUtility.getMessageId()
        super.init(coder: aDecoder)
    }
}
