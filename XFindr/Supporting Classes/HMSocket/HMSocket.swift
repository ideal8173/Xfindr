//
//  HMSocket.swift
//  XFindr
//
//  Created by Honey Maheshwari on 4/20/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

protocol HMSocketDelegate: class {
    func hmDidReceiveNewMessage(message: HMMessage)
    func hmUserIsTyping(dictData: NSDictionary)
    func hmUserStopedTyping(dictData: NSDictionary)
    //func hmChangeUserOnlineStatus(dictData: NSDictionary)
}

class HMSocket: NSObject {

    class var sharedInstance: HMSocket {
        struct HMSocketSingleton {
            static let instance = HMSocket()
        }
        return HMSocketSingleton.instance
    }
    
    var hmSocket: SocketIOClient!
    var hmDelegate: HMSocketDelegate?
    
    class var hmSocketState: HMSocketState! {
        get {
            if let socket = sharedInstance.hmSocket {
                let state = socket.status
                if state == SocketIOClientStatus.notConnected {
                    return HMSocketState.notConnected
                } else if state == SocketIOClientStatus.disconnected {
                    return HMSocketState.disconnected
                } else if state == SocketIOClientStatus.connecting {
                    return HMSocketState.connecting
                } else if state == SocketIOClientStatus.connected {
                    return HMSocketState.connecting
                } else {
                    return HMSocketState.notConnected
                }
            } else {
                return HMSocketState.notConnected
            }
        }
    }
    
    class func setupDelegate(inViewController vc: UIViewController?) {
        sharedInstance.hmDelegate = vc as? HMSocketDelegate
    }
    
    class func removeDelegate() {
        sharedInstance.hmDelegate = nil
    }
    
    class func hmDisconnectSocketIo() {
        if let socket = sharedInstance.hmSocket {
            socket.disconnect()
            socket.removeAllHandlers()
        }
    }
    
    class func hmConnectSocketIo(withId id: String, name: String, image: String, whithCopletion completion: @escaping HMVariable.hmConnected) {
        hmDisconnectSocketIo()
        HMUtilities.hmDefaultMainQueue {
            if let url: URL = URL(string: HMSocketConstants.baseUrl) {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
                let config: SocketIOClientConfiguration = [SocketIOClientOption.log(true), SocketIOClientOption.forcePolling(true), SocketIOClientOption.reconnects(true)];
                sharedInstance.hmSocket = SocketIOClient(socketURL: url, config: config)
                sharedInstance.hmSocket.on(HMSocketConstants.connect, callback: { (data: [Any], ack: SocketAckEmitter) in
                    print("Honey socket connected")
                    HMSocketUserDefaults.setSocketUserIdNameAndType(id: id, name: name, image: image)
                    hmLoginUserOnSocket(id: id, name: name, whithCopletion: completion)
                })
                sharedInstance.hmSocket.connect()
            } else {
                completion(false)
            }
        }
    }
    
    class func hmLoginUserOnSocket(id: String, name: String, whithCopletion completion: @escaping HMVariable.hmConnected) {
        HMUtilities.hmDelay(delay: 0.2) {
            if let socket = sharedInstance.hmSocket {

                let dict = NSMutableDictionary()
                dict.hmSet(object: id, forKey: HMSocketConstants.user_id)
                dict.hmSet(object: name, forKey: HMSocketConstants.user_name)
                dict.hmSet(object: "fgfdggfdhjgjfhgjkhdfjkghjkdfh", forKey: HMSocketConstants.notification_id)
                
                let convertedDict = dict.hmDictionaryToString()
                socket.emitWithAck(HMSocketConstants.login, [convertedDict]).timingOut(after: 0) { data in
                    print("Honey user successfully logined")
                    print("date >>>>>> \(data)")
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    socket.off(HMSocketConstants.privateMessage)

                    hmReceivePrivateChatMessage()
                    hmOnStartPrivateTyping()
                    hmOnStopPrivateTyping()

                    completion(true)
                }
            } else {
                completion(false)
            }
        }
        
    }
    
    //MARK: On Methods
    
    class func hmReceivePrivateChatMessage() {
        if let socket = sharedInstance.hmSocket {
            socket.off(HMSocketConstants.privateMessage)
            socket.on(HMSocketConstants.privateMessage, callback: { (data, ack) in
                if data.count > 0 {
                    
                    var dictData = NSDictionary()
                    
                    if let dict: NSDictionary = data[0] as? NSDictionary {
                        dictData = dict
                    } else if let strData: String = data[0] as? String {
                        dictData = strData.hm_StringToDictionary()
                    }
                    /*
                     recieved message dictData >>>>>> {
                     "_id" = 58fe00deb11e855e0f43c186;
                     "date_time" = "2017-04-24T13:42:54+00:00";
                     "file_name" = "IMG_2017424_191215.png";
                     "from_id" = 58fb04387ac6f6e1168b4567;
                     "from_name" = "Aster Athana";
                     latitude = "";
                     longitude = "";
                     message = "";
                     "msg_type" = 2;
                     status = 1;
                     "to_id" = 58e77cfd7ac6f657338b4567;
                     "to_name" = Honey;
                     }
                     "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
                     */
                    print("recieved message dictData >>>>>> \(dictData)")
                    
                    //let current_time_ms = dictData.hmGetDouble(forKey: HMSocketConstants.current_time)
                    //let file_name = dictData.hmGetString(forKey: HMSocketConstants.file_name)
                    
                    let current_time = HMDateTime.getMessageTimeWhenReceived(dict: dictData)
                    
                    let from_id = HelperClass.checkObjectInDictionary(dictH: dictData, strObject: HMSocketConstants.from_id, pointValue: 0)
                    let from_name = dictData.hmGetString(forKey: HMSocketConstants.from_name)
                    let message = dictData.hmGetString(forKey: HMSocketConstants.message)
                    let msg_type = dictData.hmGetInt(forKey: HMSocketConstants.msg_type)
                    let to_id = HelperClass.checkObjectInDictionary(dictH: dictData, strObject: HMSocketConstants.to_id, pointValue: 0)
                    let to_name = dictData.hmGetString(forKey: HMSocketConstants.to_name)
                    let file_name = dictData.hmGetString(forKey: HMSocketConstants.file_name)
                    //let duration = dictData.hmGetDouble(forKey: kSocket_message)
                    
                    
                    
                    var newMessage: HMMessage? = nil
                    if msg_type == HMChatMessageType.text {
                        let insertData = HMDatabase.insertTextMessage("\(to_id)", userName: to_name, userImage: "", otherUserId: "\(from_id)", otherUserName: from_name, otherUserImage: "", isUserSelf: false, messageStatus: HMChatMessageStatus.received, readUnreadStatus: HMReadUnreadState.readed, message: message, timeInSec: current_time)
                        if insertData.messageAdded {
                            newMessage = insertData.textMessage!
                        }
                    } else if msg_type == HMChatMessageType.image {
                        let insertData = HMDatabase.insertImageMessage("\(to_id)", userName: to_name, userImage: "", otherUserId: "\(from_id)", otherUserName: from_name, otherUserImage: "", isUserSelf: false, messageStatus: HMChatMessageStatus.waitingToDownload, readUnreadStatus: HMReadUnreadState.readed, message: message, imageLocalName: nil, imageServerName: file_name, timeInSec: current_time)
                        if insertData.messageAdded {
                            newMessage = insertData.imageMessage
                        }
                    }
                    
                    if newMessage != nil {
                        sharedInstance.hmDelegate?.hmDidReceiveNewMessage(message: newMessage!)
                    }
                    
                }
            })
            
        }
    }
    
    class func hmOnStartPrivateTyping() {
        
        if let socket = sharedInstance.hmSocket {
            socket.off(HMSocketConstants.startPrivateTyping)
            socket.on(HMSocketConstants.startPrivateTyping, callback: { (data, ack) in
                
                if data.count > 0 {
                    
                    var dictData = NSDictionary()
                    
                    if let dict: NSDictionary = data[0] as? NSDictionary {
                        dictData = dict
                    } else if let strData: String = data[0] as? String {
                        dictData = strData.hm_StringToDictionary()
                    }
                    
                    print("typing dictData >>>>>> \(dictData)")
                    /*typing dictData >>>>>> {
                     "from_id" = 70;
                     message = "typing...";
                     "to_id" = 184;
                     }*/
                    if dictData.count > 0 {
                        //sharedInstance.hmDelegate?.userIsTyping(dictData: dictData)
                    }
                }
                
            })
        }
    }
    
    class func hmOnStopPrivateTyping() {
        if let socket = sharedInstance.hmSocket {
            socket.off(HMSocketConstants.stopPrivateTyping)
            socket.on(HMSocketConstants.stopPrivateTyping, callback: { (data, ack) in
                
                if data.count > 0 {
                    
                    var dictData = NSDictionary()
                    
                    if let dict: NSDictionary = data[0] as? NSDictionary {
                        dictData = dict
                    } else if let strData: String = data[0] as? String {
                        dictData = strData.hm_StringToDictionary()
                    }
                    
                    print("typing dictData >>>>>> \(dictData)")
                    /*typing dictData >>>>>> {
                     "from_id" = 70;
                     message = "typing...";
                     "to_id" = 184;
                     }*/
                    if dictData.count > 0 {
                        //sharedInstance.hmDelegate?.userStopedTyping(dictData: dictData)
                    }
                }
                
            })
        }
    }
    
    //MARK: Emit With Ack
    
    class func hmSendPrivateChatMessage(to_id: String, to_name: String, message: String, msg_type: Int, file_name: String?, lat: Double?, lng: Double?, completion: @escaping HMVariable.hmDictionary) {
        
        let userDetail = HMSocketUserDefaults.getSocketUserIdNameAndImage()
        
        var fileName = ""
        if let file = file_name {
            fileName = file
        }
        
        var latitude = ""
        var longitude = ""
        
        if let la = lat {
            latitude = "\(la)"
        }
        if let ln = lng {
            longitude = "\(ln)"
        }
        
        let dictSend = NSMutableDictionary()
        dictSend.hmSet(object: to_id, forKey: HMSocketConstants.to_id)
        dictSend.hmSet(object: to_name, forKey: HMSocketConstants.to_name)
        dictSend.hmSet(object: userDetail.id, forKey: HMSocketConstants.from_id)
        dictSend.hmSet(object: userDetail.name, forKey: HMSocketConstants.from_name)
        dictSend.hmSet(object: message, forKey: HMSocketConstants.message)
        dictSend.hmSet(object: "\(msg_type)", forKey: HMSocketConstants.msg_type)
        dictSend.hmSet(object: fileName, forKey: HMSocketConstants.file_name)
        dictSend.hmSet(object: latitude, forKey: HMSocketConstants.latitude)
        dictSend.hmSet(object: longitude, forKey: HMSocketConstants.longitude)
        dictSend.hmSet(object: HMDateTime.getCurrentTimeInMS_String(), forKey: HMSocketConstants.current_time)
        
        hmEmitWithAck(event: HMSocketConstants.privateMessage, dataToSend: dictSend, completion: completion)
        
    }
    
    
    class func hmEmitWithAck(event: String, dataToSend parameters: NSDictionary, completion: @escaping HMVariable.hmDictionary) {
        if let socket = sharedInstance.hmSocket {
            let convertedDict = parameters.hmDictionaryToString()
            socket.emitWithAck(event, [convertedDict]).timingOut(after: 0) {data in
                var dictData = NSDictionary()
                if let dict: NSDictionary = data[0] as? NSDictionary {
                    dictData = dict
                } else if let strData: String = data[0] as? String {
                    dictData = strData.hm_StringToDictionary()
                } else if let dict: NSMutableDictionary = data[0] as? NSMutableDictionary {
                    dictData = dict
                }
                
                completion(dictData)
            }
        } else {
            completion(nil)
        }
    }
    
    //MARK: Emit
    
    class func hmEmit(event: String, dataToSend parameters: NSDictionary) {
        if let socket = sharedInstance.hmSocket {
            let convertedDict = parameters.hmDictionaryToString()
            socket.emit(event, [convertedDict])
        }
    }
    
    class func hmSendStartPrivateTyping(to_id: String, to_name: String) -> Bool {
        var success = false
        if sharedInstance.hmSocket != nil {
            success = true
            let userDetail = HMSocketUserDefaults.getSocketUserIdNameAndImage()
            let dictSend = NSMutableDictionary()
            dictSend.hmSet(object: to_id, forKey: HMSocketConstants.to_id)
            dictSend.hmSet(object: to_name, forKey: HMSocketConstants.to_name)
            dictSend.hmSet(object: userDetail.id, forKey: HMSocketConstants.from_id)
            dictSend.hmSet(object: userDetail.name, forKey: HMSocketConstants.from_name)
            hmEmit(event: HMSocketConstants.startPrivateTyping, dataToSend: dictSend)
        }
        return success
    }
    
    class func hmSendStopPrivateTyping(to_id: String, to_name: String) {
        let userDetail = HMSocketUserDefaults.getSocketUserIdNameAndImage()
        let dictSend = NSMutableDictionary()
        dictSend.hmSet(object: to_id, forKey: HMSocketConstants.to_id)
        dictSend.hmSet(object: to_name, forKey: HMSocketConstants.to_name)
        dictSend.hmSet(object: userDetail.id, forKey: HMSocketConstants.from_id)
        dictSend.hmSet(object: userDetail.name, forKey: HMSocketConstants.from_name)
        hmEmit(event: HMSocketConstants.stopPrivateTyping, dataToSend: dictSend)
    }
    
    
}

enum HMSocketState {
    case notConnected
    case disconnected
    case connecting
    case connected
}

struct HMSocketConstants {
    static let baseUrl = "http://192.168.1.101:8000/"
    static let imageUploadUrl = "http://192.168.1.101:8000/upload"
    static let imageDownloadUrl = "http://192.168.1.101:8000/uploads/images/thumbnails/"
    static let imageThumbnailUrl = "http://192.168.1.101:8000/uploads/images/thumbnails/"
    
    //methods
    static let connect = "connect"
    static let login = "login"
    static let privateMessage = "privateMessage"
    static let startPrivateTyping = "startPrivateTyping"
    static let stopPrivateTyping = "stopPrivateTyping"
    static let getUserList = "getUserList"
    static let getUserInfo = "getUserInfo"
    
    //Params
    static let user_id = "user_id"
    static let user_name = "user_name"
    static let notification_id = "notification_id"
        
    static let to_id = "to_id"
    static let to_name = "to_name"
    static let message = "message"
    static let from_id = "from_id"
    static let from_name = "from_name"
    static let current_time = "current_time"
    static let file_name = "file_name"
    static let msg_type = "msg_type"
    static let date_time = "date_time"
    
    static let latitude = "latitude"
    static let longitude = "longitude"
    
    /* note: msg_type => 1=text,2=image,3=text,4=zip,5=audio,6=pdf*/
    
    //response params
    static let success = "success"
    
    static let file = "file"
    
}

class HMSocketUserDefaults {
    static let hmSocketUserId = "hmSocketUserId"
    static let hmSocketUserName = "hmSocketUserName"
    static let hmSocketUserImage = "hmSocketUserImage"
    
    class func setSocketUserIdNameAndType(id: String, name: String, image: String) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(id, forKey: hmSocketUserId)
        userDefaults.set(name, forKey: hmSocketUserName)
        userDefaults.set(image, forKey: hmSocketUserImage)
    }
    
    class func getSocketUserIdNameAndImage() -> (id: String, name: String, image: String) {
        let id = getSocketUserId()
        let name = getSocketUserName()
        let image = getSocketUserImage()
        return (id: id, name: name, image: image)
    }
    
    class func getSocketUserId() -> String {
        let userDefaults = UserDefaults.standard
        var id = ""
        if let str: String = userDefaults.string(forKey: hmSocketUserId) {
            id = str
        } else if let int: Int = userDefaults.object(forKey: hmSocketUserId) as? Int {
            id = "\(int)"
        } else if let numb: NSNumber = userDefaults.object(forKey: hmSocketUserId) as? NSNumber {
            id = "\(Int(numb))"
        }
        
        if id == "" {
            id = "\(userDefaults.integer(forKey: hmSocketUserId))"
        }
        
        return id
    }
    
    class func getSocketUserName() -> String {
        var name = ""
        if let str: String = UserDefaults.standard.string(forKey: hmSocketUserName) {
            name = str
        }
        return name
    }
    
    class func getSocketUserImage() -> String {
        var name = ""
        if let str: String = UserDefaults.standard.string(forKey: hmSocketUserImage) {
            name = str
        }
        return name
    }
    
}
