//
//  HMDatabase.swift
//  XFindr
//
//  Created by Honey Maheshwari on 4/20/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class HMDatabase: NSObject {
    
    class var sharedInstance: HMDatabase {
        struct HMDatabaseSingleton {
            static let instance = HMDatabase()
        }
        return HMDatabaseSingleton.instance
    }
    
    class func getDatabasePath() -> String {
        do {
            let documents = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let fileURL: URL? = documents.appendingPathComponent(hmDB.dbName)
            
            if fileURL != nil {
                let databasePath = fileURL!.path
                print("hm databasePath >>>>\(databasePath)")
                return databasePath
            }
        } catch let error as NSError {
            print(error)
        }
        
        return ""
    }
    
    class func createPrivateChatTable() {
        
        let databasePath = getDatabasePath()
        if databasePath == "" {
            return
        }
        
        let array = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        var filePath = array[0]
        filePath = filePath.hm_StringByAppendingPathComponent(hmDB.dbName)
        let manager = FileManager.default
        
        if manager.fileExists(atPath: filePath) {
            return
        }
        
        
        var db: OpaquePointer? = nil
        if sqlite3_open(databasePath, &db) != SQLITE_OK {
            print("error opening database")
            return
        }else{
        }
        
        let database = FMDatabase(path: databasePath)
        if database == nil {
            print("Error: \(String(describing: database?.lastErrorMessage()))")
        }
        
        if (database?.open())! {
            
            let create_sql1 = "CREATE TABLE IF NOT EXISTS \(hmDB.privateChatTableName) (\(hmDB.columnId) INTEGER PRIMARY KEY AUTOINCREMENT, \(hmDB.userId) INTEGER NOT NULL DEFAULT '0', \(hmDB.userName) TEXT NOT NULL DEFAULT '', \(hmDB.userImage) TEXT NOT NULL DEFAULT '', \(hmDB.otherUserId) INTEGER NOT NULL DEFAULT '0', \(hmDB.otherUserName) TEXT NOT NULL DEFAULT '', \(hmDB.otherUserImage) TEXT NOT NULL DEFAULT '',"
            
            let create_sql2 = " \(hmDB.userType) INTEGER NOT NULL DEFAULT '0', \(hmDB.messageType) INTEGER NOT NULL DEFAULT '0', \(hmDB.messageStatus) INTEGER NOT NULL DEFAULT '0', \(hmDB.readUnreadStatus) INTEGER NOT NULL DEFAULT '0', \(hmDB.message) TEXT NOT NULL DEFAULT '', \(hmDB.filePath) TEXT NOT NULL DEFAULT '', \(hmDB.serverFileName) TEXT NOT NULL DEFAULT '',"
            
            let create_sql3 = " \(hmDB.timeInSec) LONG NOT NULL DEFAULT '0.0', \(hmDB.dateInUTC) DATETIME, \(hmDB.contactName) TEXT NOT NULL DEFAULT '', \(hmDB.contactNumber) TEXT NOT NULL DEFAULT '', \(hmDB.latitude) LONG NOT NULL DEFAULT '0.0', \(hmDB.longitude) LONG NOT NULL DEFAULT '0.0', \(hmDB.address) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn1) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn2) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn3) TEXT NOT NULL DEFAULT '',"
            
            let create_sql4 = " \(hmDB.extraColumn4) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn5) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn6) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn7) LONG NOT NULL DEFAULT '0.0', \(hmDB.extraColumn8) LONG NOT NULL DEFAULT '0.0', \(hmDB.extraColumn9) INTEGER NOT NULL DEFAULT '0', \(hmDB.extraColumn10) INTEGER NOT NULL DEFAULT '0')"
            
            let create_sql = create_sql1 + create_sql2 + create_sql3 + create_sql4
            
            //            let create_sql = "CREATE TABLE IF NOT EXISTS \(hmDB.privateChatTableName) (\(hmDB.columnId) INTEGER PRIMARY KEY AUTOINCREMENT, \(hmDB.userId) INTEGER NOT NULL DEFAULT '0', \(hmDB.userName) TEXT NOT NULL DEFAULT '', \(hmDB.userImage) TEXT NOT NULL DEFAULT '', \(hmDB.selfUserType) TEXT NOT NULL DEFAULT \(kSocket_typeSuperMarket), \(hmDB.otherUserId) INTEGER NOT NULL DEFAULT '0', \(hmDB.otherUserName) TEXT NOT NULL DEFAULT '', \(hmDB.otherUserImage) TEXT NOT NULL DEFAULT '', \(hmDB.otherUserType) TEXT NOT NULL DEFAULT \(kSocket_typeCustomer), \(hmDB.userType) INTEGER NOT NULL DEFAULT '0', \(hmDB.messageType) INTEGER NOT NULL DEFAULT '0', \(hmDB.messageStatus) INTEGER NOT NULL DEFAULT '0', \(hmDB.readUnreadStatus) INTEGER NOT NULL DEFAULT '0', \(hmDB.message) TEXT NOT NULL DEFAULT '', \(hmDB.filePath) TEXT NOT NULL DEFAULT '', \(hmDB.serverFileName) TEXT NOT NULL DEFAULT '', \(hmDB.timeInSec) LONG NOT NULL DEFAULT '0.0', \(hmDB.dateInUTC) DATETIME, \(hmDB.contactName) TEXT NOT NULL DEFAULT '', \(hmDB.contactNumber) TEXT NOT NULL DEFAULT '', \(hmDB.latitude) LONG NOT NULL DEFAULT '0.0', \(hmDB.longitude) LONG NOT NULL DEFAULT '0.0', \(hmDB.address) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn1) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn2) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn3) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn4) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn5) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn6) TEXT NOT NULL DEFAULT '', \(hmDB.extraColumn7) LONG NOT NULL DEFAULT '0.0', \(hmDB.extraColumn8) LONG NOT NULL DEFAULT '0.0', \(hmDB.extraColumn9) INTEGER NOT NULL DEFAULT '0', \(hmDB.extraColumn10) INTEGER NOT NULL DEFAULT '0')"
            
            print("create_sql >>>>\(create_sql)")
            if !(database?.executeStatements(create_sql))! {
                print("Error: \(String(describing: database?.lastErrorMessage()))")
            } else {
                print("table \(hmDB.privateChatTableName) created")
            }
            
        }
        
        database?.close()
    }
    
    
    class func insertTextMessage(_ userId: String, userName: String, userImage: String, otherUserId: String, otherUserName: String, otherUserImage: String, isUserSelf: Bool, messageStatus: Int, readUnreadStatus: Int, message: String, timeInSec: Double?) -> (messageAdded: Bool, textMessage: HMMessage?) {
        
        var userType = HMChatUserType.other
        if isUserSelf == true {
            userType = HMChatUserType.me
        }
        
        var sec = Date().timeIntervalSince1970
        var dateInUTC = ""
        if timeInSec != nil {
            dateInUTC = HMDateTime.getDateFromSecForDatabase(timeInSec!)
            sec = timeInSec!
        } else {
            let hhh = HMDateTime.getCurrentDateAndTimeForDatabase()
            dateInUTC = hhh.dateInUTC
        }
        
        let databasePath = HMDatabase.getDatabasePath()
        if databasePath == "" {
            return (false, nil)
        }
        
        var db: OpaquePointer? = nil
        if sqlite3_open(databasePath, &db) != SQLITE_OK {
            print("error opening database")
            return (false, nil)
        }else{
        }
        
        let database = FMDatabase(path: databasePath)
        if database == nil {
            print("Error: \(String(describing: database?.lastErrorMessage()))")
        }
        
        var uniqueId: Int = 0
        
        if (database?.open())! {
            
            let insert_key = "INSERT INTO \(hmDB.privateChatTableName) (\(hmDB.userId), \(hmDB.userName), \(hmDB.userImage), \(hmDB.otherUserId), \(hmDB.otherUserName), \(hmDB.otherUserImage), \(hmDB.userType), \(hmDB.messageType), \(hmDB.messageStatus), \(hmDB.readUnreadStatus), \(hmDB.message), \(hmDB.timeInSec), \(hmDB.dateInUTC))"
            
            let insert_value = String(format: " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", userId, userName, userImage, otherUserId, otherUserName, otherUserImage, "\(userType)", "\(HMChatMessageType.text)", "\(messageStatus)", "\(readUnreadStatus)", message, "\(sec)", dateInUTC)
            
            let insert_sql = insert_key + insert_value
            
            print("insert_sql >>>>\(insert_sql)")
            
            if !(database?.executeStatements(insert_sql))! {
                print("Error: \(String(describing: database?.lastErrorMessage()))")
            } else {
                print("data inserted in \(hmDB.privateChatTableName)")
            }
            
            let id = database?.lastInsertRowId()
            uniqueId = Int(id!)
        }
        
        database?.close()
        
        if uniqueId != 0 {
            var senderId = otherUserId
            var senderName = otherUserName
            if isUserSelf == true {
                senderId = userId
                senderName = userName
            }
            
            let textMessage = HMMessage.createTextMessage(uniqueId, senderId: senderId, senderName: senderName, userType: userType, message: message, timeInSeconds: sec, messageStatus: messageStatus, readUnreadStatus: readUnreadStatus)
            
            return (true, textMessage)
        } else {
            return (false, nil)
        }
    }
    
    class func insertImageMessage(_ userId: String, userName: String, userImage: String, otherUserId: String, otherUserName: String, otherUserImage: String, isUserSelf: Bool, messageStatus: Int, readUnreadStatus: Int, message: String?, imageLocalName: String?, imageServerName: String?, timeInSec: Double?) -> (messageAdded: Bool, imageMessage: HMMessage?) {
        
        
        var userType = HMChatUserType.other
        if isUserSelf == true {
            userType = HMChatUserType.me
        }
        
        var sec = Date().timeIntervalSince1970
        var dateInUTC = ""
        if timeInSec != nil {
            dateInUTC = HMDateTime.getDateFromSecForDatabase(timeInSec!)
            sec = timeInSec!
        } else {
            let hhh = HMDateTime.getCurrentDateAndTimeForDatabase()
            dateInUTC = hhh.dateInUTC
        }
        
        let databasePath = HMDatabase.getDatabasePath()
        if databasePath == "" {
            return (false, nil)
        }
        
        var db: OpaquePointer? = nil
        if sqlite3_open(databasePath, &db) != SQLITE_OK {
            print("error opening database")
            return (false, nil)
        }else{
        }
        
        let database = FMDatabase(path: databasePath)
        if database == nil {
            print("Error: \(String(describing: database?.lastErrorMessage()))")
        }
        
        var uniqueId: Int = 0
        
        
        var text = ""
        if message != nil {
            text = message!
        }
        
        var local = ""
        if imageLocalName != nil {
            local = imageLocalName!
        }
        
        var server = ""
        if imageServerName != nil {
            server = imageServerName!
        }
        
        if (database?.open())! {
            
            //let insert_key = "INSERT INTO \(hmDB.privateChatTableName) (\(hmDB.userId), \(hmDB.userName), \(hmDB.userImage), \(hmDB.otherUserId), \(hmDB.otherUserName), \(hmDB.otherUserImage), \(hmDB.userType), \(hmDB.messageType), \(hmDB.messageStatus), \(hmDB.readUnreadStatus), \(hmDB.message), \(hmDB.timeInSec), \(hmDB.dateInUTC))"
            
            //let insert_value = String(format: " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", userId, userName, userImage, otherUserId, otherUserName, otherUserImage, "\(userType)", "\(HMChatMessageType.text)", "\(messageStatus)", "\(readUnreadStatus)", message, "\(sec)", dateInUTC)
            
            
            let insert_key = "INSERT INTO \(hmDB.privateChatTableName) (\(hmDB.userId), \(hmDB.userName), \(hmDB.userImage), \(hmDB.otherUserId), \(hmDB.otherUserName), \(hmDB.otherUserImage), \(hmDB.userType), \(hmDB.messageType), \(hmDB.messageStatus), \(hmDB.readUnreadStatus), \(hmDB.message), \(hmDB.filePath), \(hmDB.serverFileName), \(hmDB.timeInSec), \(hmDB.dateInUTC))"
            
            let insert_value = String(format: " VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", userId, userName, userImage, otherUserId, otherUserName, otherUserImage, "\(userType)", "\(HMChatMessageType.image)", "\(messageStatus)", "\(readUnreadStatus)", text, local, server, "\(sec)", dateInUTC)
            
            let insert_sql = insert_key + insert_value
            
            print("insert_sql >>>>\(insert_sql)")
            
            if !(database?.executeStatements(insert_sql))! {
                print("Error: \(String(describing: database?.lastErrorMessage()))")
            } else {
                print("data inserted in \(hmDB.privateChatTableName)")
            }
            
            let id = database?.lastInsertRowId()
            uniqueId = Int(id!)
        }
        
        database?.close()
        
        if uniqueId != 0 {
            var senderId = otherUserId
            var senderName = otherUserName
            if isUserSelf == true {
                senderId = userId
                senderName = userName
            }
            
            //let textMessage = HMMessage.createTextMessage(uniqueId, senderId: senderId, senderName: senderName, userType: userType, message: message, timeInSeconds: sec, messageStatus: messageStatus, readUnreadStatus: readUnreadStatus)
            
            let imageMessage = HMMessage.createImageMessage(uniqueId, senderId: senderId, senderName: senderName, userType: userType, message: message, localName: imageLocalName, serverName: imageServerName, timeInSeconds: sec, messageStatus: messageStatus, readUnreadStatus: readUnreadStatus)
            
            return (true, imageMessage)
        } else {
            return (false, nil)
        }
        
        
    }
    
    /***********************************************/
    
    class func clearUserChat(userId: String, otherUserId: String) -> Bool {
        var status = false
        
        let databasePath = HMDatabase.getDatabasePath()
        if databasePath == "" {
            return status
        }
        
        var db: OpaquePointer? = nil
        if sqlite3_open(databasePath, &db) != SQLITE_OK {
            print("error opening database")
            return status
        }else{
        }
        
        let database = FMDatabase(path: databasePath)
        if database == nil {
            print("Error: \(String(describing: database?.lastErrorMessage()))")
        }
        
        if (database?.open())! {
            let delete_statement = "DELETE FROM \(hmDB.privateChatTableName) WHERE \(hmDB.userId) = \(userId) AND \(hmDB.otherUserId) = \(otherUserId)"
            
            print("delete_statement >>>>\(delete_statement)")
            
            if !(database?.executeStatements(delete_statement))! {
                print("Error: \(String(describing: database?.lastErrorMessage()))")
                status = false
            } else {
                status = true
                print("data deleted from \(hmDB.privateChatTableName)")
            }
            
        }
        
        database?.close()
        
        return status
    }
    
    class func updateStatusForMessage(_ messageUniqueId: Int, messageStatus: Int) -> Bool {
        var updateStatus: Bool = false
        let databasePath = HMDatabase.getDatabasePath()
        if databasePath == "" {
            return updateStatus
        }
        
        var db: OpaquePointer? = nil
        if sqlite3_open(databasePath, &db) != SQLITE_OK {
            print("error opening database")
            return updateStatus
        }else{
        }
        
        let database = FMDatabase(path: databasePath)
        if database == nil {
            print("Error: \(String(describing: database?.lastErrorMessage()))")
        }
        
        if (database?.open())! {
            
            let update_sql = String(format: "UPDATE \(hmDB.privateChatTableName) SET \(hmDB.messageStatus) = \"%@\" WHERE \(hmDB.columnId) = \"%@\"", "\(messageStatus)", "\(messageUniqueId)")
            
            print("update_sql >>>>\(update_sql)")
            
            if !(database?.executeStatements(update_sql))! {
                print("Error: \(String(describing: database?.lastErrorMessage()))")
                updateStatus = false
            } else {
                print("messageStatus updated in \(hmDB.privateChatTableName)")
                updateStatus = true
            }
        }
        database?.close()
        return updateStatus
    }
    
    class func updateStatusForMediaMessage(_ messageUniqueId: Int, messageStatus: Int, localName: String?, serverName: String?) -> Bool {
        var updateStatus: Bool = false
        let databasePath = HMDatabase.getDatabasePath()
        if databasePath == "" {
            return updateStatus
        }
        
        var db: OpaquePointer? = nil
        if sqlite3_open(databasePath, &db) != SQLITE_OK {
            print("error opening database")
            return updateStatus
        }else{
        }
        
        let database = FMDatabase(path: databasePath)
        if database == nil {
            print("Error: \(String(describing: database?.lastErrorMessage()))")
        }
        
        var local = ""
        if localName != nil {
            local = localName!
        }
        
        var server = ""
        if serverName != nil {
            server = serverName!
        }
        
        if (database?.open())! {
            var update_sql = ""
            if local != "" && server != "" {
                update_sql = String(format: "UPDATE \(hmDB.privateChatTableName) SET \(hmDB.messageStatus) = \"%@\", \(hmDB.filePath) = \"%@\", \(hmDB.serverFileName) = \"%@\" WHERE \(hmDB.columnId) = \"%@\"", "\(messageStatus)", local, server, "\(messageUniqueId)")
            } else if local != "" {
                update_sql = String(format: "UPDATE \(hmDB.privateChatTableName) SET \(hmDB.messageStatus) = \"%@\", \(hmDB.filePath) = \"%@\" WHERE \(hmDB.columnId) = \"%@\"", "\(messageStatus)", local, "\(messageUniqueId)")
            } else if server != "" {
                update_sql = String(format: "UPDATE \(hmDB.privateChatTableName) SET \(hmDB.messageStatus) = \"%@\", \(hmDB.serverFileName) = \"%@\" WHERE \(hmDB.columnId) = \"%@\"", "\(messageStatus)", server, "\(messageUniqueId)")
            } else {
                database?.close()
                return updateStatus
            }
            
            print("update_sql >>>>\(update_sql)")
            
            if !(database?.executeStatements(update_sql))! {
                print("Error: \(String(describing: database?.lastErrorMessage()))")
                updateStatus = false
            } else {
                print("messageStatus updated in \(hmDB.privateChatTableName)")
                updateStatus = true
            }
            
        }
        
        database?.close()
        return updateStatus
    }
    
    
    class func getChatDataFromPrivateChatTableWithPagination(_ myId: String, otherUserId: String, time: Double) -> NSMutableArray {
        
        let databasePath = getDatabasePath()
        if databasePath == "" {
            return NSMutableArray()
        }
        
        var db: OpaquePointer? = nil
        if sqlite3_open(databasePath, &db) != SQLITE_OK {
            print("error opening database")
            return NSMutableArray()
        }else{
        }
        
        let database = FMDatabase(path: databasePath)
        if database == nil {
            print("Error: \(String(describing: database?.lastErrorMessage()))")
        }
        
        let messages = NSMutableArray()
        
        if (database?.open())! {

            let firstValue = 0
            
            let fetch_sql = "SELECT * FROM \(hmDB.privateChatTableName) WHERE (\(hmDB.userId) = \"\(myId)\" AND \(hmDB.otherUserId) = \"\(otherUserId)\" AND \(hmDB.timeInSec) < \(time)) ORDER BY \(hmDB.columnId) DESC LIMIT \(firstValue), \(hmDB.pageCount)"
            
            print("fetch_sql >>>>>>>>> \(fetch_sql)")
            
            let results: FMResultSet? = database?.executeQuery(fetch_sql, withArgumentsIn: nil)
            if results != nil {
                while results!.next() {
                    var senderId: Int = 0
                    var senderName = ""
                    var userType = HMChatUserType.unknown
                    var messageType = HMChatMessageType.unknown
                    var readStatus = HMReadUnreadState.readed
                    var messageStatus: Int = HMChatMessageStatus.unknown
                    
                    let uniqueId = Int(results!.int(forColumn: hmDB.columnId))
                    
                    if results?.int(forColumn: hmDB.userType) != nil {
                        userType = Int(results!.int(forColumn: hmDB.userType))
                    }
                    
                    if results?.int(forColumn: hmDB.messageType) != nil {
                        messageType = Int(results!.int(forColumn: hmDB.messageType))
                    }
                    
                    if results?.int(forColumn: hmDB.readUnreadStatus) != nil {
                        readStatus = Int(results!.int(forColumn: hmDB.readUnreadStatus))
                    }
                    
                    if results?.int(forColumn: hmDB.messageStatus) != nil {
                        messageStatus = Int(results!.int(forColumn: hmDB.messageStatus))
                    }
                    
                    if userType == HMChatUserType.me {
                        if results?.int(forColumn: hmDB.userId) != nil {
                            senderId = Int(results!.int(forColumn: hmDB.userId))
                        }
                        
                        if results?.string(forColumn: hmDB.userName) != nil {
                            senderName = results!.string(forColumn: hmDB.userName)
                        }
                        
                    } else if userType == HMChatUserType.other {
                        if results?.int(forColumn: hmDB.otherUserId) != nil {
                            senderId = Int(results!.int(forColumn: hmDB.otherUserId))
                        }
                        
                        if results?.string(forColumn: hmDB.otherUserName) != nil {
                            senderName = results!.string(forColumn: hmDB.otherUserName)
                        }
                        
                    }
                    
                    var timeInSeconds = HMDateTime.getCurrentTimeInSeconds()
                    if results?.long(forColumn: hmDB.timeInSec) != nil {
                        timeInSeconds = Double(results!.long(forColumn: hmDB.timeInSec))
                    }
                    
                    if messageType == HMChatMessageType.text {
                        var message = ""
                        if results?.string(forColumn: hmDB.message) != nil {
                            message = results!.string(forColumn: hmDB.message).replacingOccurrences(of: hmDB.hmUniqueString, with: hmDB.hmReplacementString)
                        }
                        
                        if message != "" && senderId != 0 {
                            let textMessage = HMMessage.createTextMessage(uniqueId, senderId: "\(senderId)", senderName: senderName, userType: userType, message: message, timeInSeconds: timeInSeconds, messageStatus: messageStatus, readUnreadStatus: readStatus)
                            messages.add(textMessage)
                        }
                    } else if messageType == HMChatMessageType.image {
                        var message: String? = nil
                        if results?.string(forColumn: hmDB.message) != nil {
                            message = results!.string(forColumn: hmDB.message).replacingOccurrences(of: hmDB.hmUniqueString, with: hmDB.hmReplacementString)
                        }
                        
                        var local: String? = nil
                        if results?.string(forColumn: hmDB.filePath) != nil {
                            local = results!.string(forColumn: hmDB.filePath)
                        }
                        
                        var server: String? = nil
                        if results?.string(forColumn: hmDB.serverFileName) != nil {
                            server = results!.string(forColumn: hmDB.serverFileName)
                        }
                        
                        if local != nil || server != nil {
                            let imageMessage = HMMessage.createImageMessage(uniqueId, senderId: "\(senderId)", senderName: senderName, userType: userType, message: message, localName: local, serverName: server, timeInSeconds: timeInSeconds, messageStatus: messageStatus, readUnreadStatus: readStatus)
                            messages.add(imageMessage)
                        }
                    }
                }
            }
        }
        
        database?.close()
        
        let newMessages = NSMutableArray(array: messages.reversed())
        return newMessages
    }
    
    class func getLastMessageFromDatabasePrivateChatTableWith(_ myId: String, otherUserId: String) -> NSMutableDictionary {
        
        let databasePath = getDatabasePath()
        if databasePath == "" {
            return NSMutableDictionary()
        }
        
        var db: OpaquePointer? = nil
        if sqlite3_open(databasePath, &db) != SQLITE_OK {
            print("error opening database")
            return NSMutableDictionary()
        }else {
            
        }
        
        let database = FMDatabase(path: databasePath)
        if database == nil {
            print("Error: \(String(describing: database?.lastErrorMessage()))")
        }
        
        let dictReturn = NSMutableDictionary()
        
        if (database?.open())! {
            
            /*
             
             [NSString stringWithFormat:@"SELECT %@, %@, %@, %@, %@ FROM %@ WHERE %@ = %d ORDER BY %@ DESC LIMIT 1", columnId, columnMessage, columnMessageType, columnUTCTime, columnTimeInMS, strTableName, strColumnName, [strId intValue], columnId]
             
             */
            //            let fetch_sql = "SELECT * FROM \(hmDB.privateChatTableName) WHERE (\(hmDB.userId) = \(myId) AND \(hmDB.otherUserId) = \(otherUserId) AND \(hmDB.timeInSec) < \(time)) ORDER BY \(hmDB.columnId) DESC LIMIT \(firstValue), \(hmDB.pageCount)"
            
            _ = "select count(readed) from table where read = 1 AND userId = "
            _ = "update \(hmDB.privateChatTableName) SET read = 1 where read = 1 AND userId = "
            
            
            //Last message with unread count
            _ = "SELECT count(CASE WHEN readUnreadStatus = 1 THEN 1 END) as unreadCount, id,  message, messageType FROM HMPrivateChatTable WHERE (userId = '58e77cfd7ac6f657338b4567' AND otherUserId = '58eb4f7e7ac6f63226631b12') ORDER BY id DESC "
            
            let fetch_sql = "SELECT \(hmDB.columnId), \(hmDB.userType), \(hmDB.messageType), \(hmDB.userId), \(hmDB.userName), \(hmDB.otherUserId), \(hmDB.otherUserName), \(hmDB.timeInSec), \(hmDB.message) FROM \(hmDB.privateChatTableName) WHERE (\(hmDB.userId) = \"\(myId)\" AND \(hmDB.otherUserId) = \"\(otherUserId)\") ORDER BY \(hmDB.columnId) DESC LIMIT 1"
            
            
            print("fetch_sql >>>>>>>>> \(fetch_sql)")
            
            let results: FMResultSet? = database?.executeQuery(fetch_sql, withArgumentsIn: nil)
            if results != nil {
                while results!.next() {
                    var senderId: Int = 0
                    var senderName = ""
                    var userType = HMChatUserType.unknown
                    var messageType = HMChatMessageType.unknown
                    let uniqueId = Int(results!.int(forColumn: hmDB.columnId))
                    
                    if results?.int(forColumn: hmDB.userType) != nil {
                        userType = Int(results!.int(forColumn: hmDB.userType))
                    }
                    
                    if results?.int(forColumn: hmDB.messageType) != nil {
                        messageType = Int(results!.int(forColumn: hmDB.messageType))
                    }
                    
                    if userType == HMChatUserType.me {
                        if results?.int(forColumn: hmDB.userId) != nil {
                            senderId = Int(results!.int(forColumn: hmDB.userId))
                        }
                        
                        if results?.string(forColumn: hmDB.userName) != nil {
                            senderName = results!.string(forColumn: hmDB.userName)
                        }
                        
                    } else if userType == HMChatUserType.other {
                        if results?.int(forColumn: hmDB.otherUserId) != nil {
                            senderId = Int(results!.int(forColumn: hmDB.otherUserId))
                        }
                        
                        if results?.string(forColumn: hmDB.otherUserName) != nil {
                            senderName = results!.string(forColumn: hmDB.otherUserName)
                        }
                        
                    }
                    
                    
                    var timeInSeconds = HMDateTime.getCurrentTimeInSeconds()
                    if results?.long(forColumn: hmDB.timeInSec) != nil {
                        timeInSeconds = Double(results!.long(forColumn: hmDB.timeInSec))
                    }
                    
                    dictReturn.hmSet(object: uniqueId, forKey: hmDB.columnId)
                    dictReturn.hmSet(object: userType, forKey: hmDB.userType)
                    dictReturn.hmSet(object: messageType, forKey: hmDB.messageType)
                    dictReturn.hmSet(object: senderId, forKey: hmDB.senderId)
                    dictReturn.hmSet(object: senderName, forKey: hmDB.senderName)
                    dictReturn.hmSet(object: timeInSeconds, forKey: hmDB.timeInSec)
                    
                    if messageType == HMChatMessageType.text {
                        var message = ""
                        if results?.string(forColumn: hmDB.message) != nil {
                            message = results!.string(forColumn: hmDB.message).replacingOccurrences(of: hmDB.hmUniqueString, with: hmDB.hmReplacementString)
                        }
                        dictReturn.hmSet(object: message, forKey: hmDB.showMessage)
                    } else if messageType == HMChatMessageType.audio {
                        dictReturn.hmSet(object: "Audio", forKey: hmDB.showMessage)
                    } else if messageType == HMChatMessageType.image {
                        dictReturn.hmSet(object: "Image", forKey: hmDB.showMessage)
                    }
                }
            }
        }
        
        database?.close()
        
        return dictReturn
    }
    
}


struct hmDB {
    static let dbName = "HMChatDatabase.sqlite"
    static let privateChatTableName = "HMPrivateChatTable"
    
    static let columnId = "id"
    static let userId = "userId"
    static let userName = "userName"
    static let userImage = "userImage"
    static let otherUserId = "otherUserId"
    static let otherUserName = "otherUserName"
    static let otherUserImage = "otherUserImage"
    static let userType = "userType"
    static let messageType = "messageType"
    static let messageStatus = "messageStatus"
    static let readUnreadStatus = "readUnreadStatus"
    static let message = "message"
    static let filePath = "filePath"
    static let serverFileName = "serverFileName"
    static let timeInSec = "timeInSec"
    static let dateInUTC = "dateInUTC"
    static let contactName = "contactName"
    static let contactNumber = "contactNumber"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let address = "address"
    static let extraColumn1 = "extraColumn_1"
    static let extraColumn2 = "extraColumn_2"
    static let extraColumn3 = "extraColumn_3"
    static let extraColumn4 = "extraColumn_4"
    static let extraColumn5 = "extraColumn_5"
    static let extraColumn6 = "extraColumn_6"
    static let extraColumn7 = "extraColumn_7"
    static let extraColumn8 = "extraColumn_8"
    static let extraColumn9 = "extraColumn_9"
    static let extraColumn10 = "extraColumn_10"
    
    static let hmUniqueString = "_2_3_0_7_1_9_9_3_h_o_n_e_y_m_a_h_e_s_h_w_a_r_i_2_3_0_7_1_9_9_3_"
    static let hmReplacementString = "\""
    static let pageCount: Int = 20
    
    
    static let senderId = "senderId"
    static let senderName = "senderName"
    static let showMessage = "showMessage"
    static let unreadCount = "unreadCount"
}
