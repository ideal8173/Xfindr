//
//  HMMessage.swift
//  XFindr
//
//  Created by Honey Maheshwari on 4/20/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class HMMessage: NSObject {
    
    var messageUniqueId: Int!
    var senderId: String!
    var senderName: String!
    var userType: Int!
    var messageType: Int!
    var message: String?
    var timeInSeconds: Double!
    var messageStatus: Int!
    var readUnreadStatus: Int!
    var mediaLocalName: String?
    var mediaServerName: String?
    
    convenience init(messageUniqueId: Int ,senderId: String, senderName: String, userType: Int, messageType: Int, message: String?, mediaLocalName: String?, mediaServerName: String?, timeInSeconds: Double, messageStatus: Int, readUnreadStatus: Int) {
        
        self.init()
        self.messageUniqueId = messageUniqueId
        self.senderId = senderId
        self.senderName = senderName
        self.userType = userType
        self.messageType = messageType
        self.message = message
        self.mediaLocalName = mediaLocalName
        self.mediaServerName = mediaServerName
        
        self.timeInSeconds = timeInSeconds
        
        self.messageStatus = messageStatus
        self.readUnreadStatus = readUnreadStatus
    }
    
    class func createTextMessage(_ messageUniqueId: Int ,senderId: String, senderName: String, userType: Int, message: String?, timeInSeconds: Double, messageStatus: Int, readUnreadStatus: Int) -> HMMessage {
        
        let textMessage = HMMessage(messageUniqueId: messageUniqueId, senderId: senderId, senderName: senderName, userType: userType, messageType: HMChatMessageType.text, message: message, mediaLocalName: nil, mediaServerName: nil, timeInSeconds: timeInSeconds, messageStatus: messageStatus, readUnreadStatus: readUnreadStatus)
        
        return textMessage
    }
    
    class func createImageMessage(_ messageUniqueId: Int ,senderId: String, senderName: String, userType: Int, message: String?, localName: String?, serverName: String?, timeInSeconds: Double, messageStatus: Int, readUnreadStatus: Int) -> HMMessage {
        
        let imageMessage = HMMessage(messageUniqueId: messageUniqueId, senderId: senderId, senderName: senderName, userType: userType, messageType: HMChatMessageType.image, message: message, mediaLocalName: localName, mediaServerName: serverName, timeInSeconds: timeInSeconds, messageStatus: messageStatus, readUnreadStatus: readUnreadStatus)
        
        return imageMessage
    }
    
}

/*
class HMMessage: NSObject {
    var messageUniqueId: Int!
    var senderId: String!
    var senderName: String!
    var userType: Int!
    var messageType: Int!
    var message: String!
    var timeInSeconds: Double!
    var messageExtraData: NSDictionary?
    var messageStatus: Int!
    var readUnreadStatus: Int!
    
    convenience init(messageUniqueId: Int ,senderId: String, senderName: String, userType: Int, messageType: Int, message: String?, timeInSeconds: Double, messageExtraData: NSDictionary?, messageStatus: Int, readUnreadStatus: Int) {
        
        self.init()
        self.messageUniqueId = messageUniqueId
        self.senderId = senderId
        self.senderName = senderName
        self.userType = userType
        self.messageType = messageType
        if message != nil {
            self.message = message
        } else {
            self.message = ""
        }
        
        self.timeInSeconds = timeInSeconds

        self.messageExtraData = messageExtraData
        self.messageStatus = messageStatus
        self.readUnreadStatus = readUnreadStatus
    }
    
    class func createTextMessage(_ messageUniqueId: Int ,senderId: String, senderName: String, userType: Int, message: String?, timeInSeconds: Double, messageStatus: Int, readUnreadStatus: Int) -> HMMessage {
        
        let textMessage = HMMessage(messageUniqueId: messageUniqueId, senderId: senderId, senderName: senderName, userType: userType, messageType: HMChatMessageType.text, message: message, timeInSeconds: timeInSeconds, messageExtraData: nil, messageStatus: messageStatus, readUnreadStatus: readUnreadStatus)
        
        return textMessage
    }
    
    class func createImageMessage(_ messageUniqueId: Int ,senderId: String, senderName: String, userType: Int, message: String?, timeInSeconds: Double, messageStatus: Int, readUnreadStatus: Int, localName: String?, serverName: String?, isImageAvailable: Bool) -> HMMessage {
        
        let dictExtraData = NSMutableDictionary()
        var asset = ""
        var server = ""
        if localName != nil {
            asset = localName!
        }
        
        if serverName != nil {
            if serverName! != "" {
                server = serverName!
            }
        }
        dictExtraData.hmSet(object: asset, forKey: HMMessageDict.localName)
        dictExtraData.hmSet(object: server, forKey: HMMessageDict.serverName)

        if isImageAvailable {
            dictExtraData.hmSet(object: HMMessageDict.imageAvailable, forKey: HMMessageDict.isImageAvailable)
        } else {
            dictExtraData.hmSet(object: HMMessageDict.imageUnAvailable, forKey: HMMessageDict.isImageAvailable)
        }
        
        let imageMessage = HMMessage(messageUniqueId: messageUniqueId, senderId: senderId, senderName: senderName, userType: userType, messageType: HMChatMessageType.image, message: message, timeInSeconds: timeInSeconds, messageExtraData: dictExtraData, messageStatus: messageStatus, readUnreadStatus: readUnreadStatus)
        
        return imageMessage
    }
    
}
*/

struct HMMessageDict {
    static let localName = "localName"
    static let serverName = "serverName"
    
    static let isImageAvailable = "isImageAvailable"
    
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let address = "address"

    static let imageCantBeFetched: Int = 2
    static let imageAvailable: Int = 1
    static let imageUnAvailable: Int = 0
}
