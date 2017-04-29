//
//  AppVariables.swift
//  XFindr
//
//  Created by Rajat on 4/3/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class AppVariables: NSObject {
    
    var dictUserDetails: NSMutableDictionary? = nil
    var dictChat: NSMutableDictionary? = nil
    var arrDownloadUpload: [HMDownloadUpload]? = nil
    
    class var sharedInstance: AppVariables {
        struct Singleton {
            static let instance = AppVariables()
        }
        return Singleton.instance
    }
    
    //MARK: User Detail
    
    class func setDictUserDetail(_ dictDetails: NSDictionary?) {
        if let dict = dictDetails {
            sharedInstance.dictUserDetails = dict.mutableCopy() as? NSMutableDictionary
        } else {
            sharedInstance.dictUserDetails = nil
        }
    }
    
    class func getDictUserDetail() -> NSMutableDictionary {
        if let dict = sharedInstance.dictUserDetails {
            return dict
        }
        return NSMutableDictionary()
    }
    
    class func updateDictUserDetail(forKey key: String, value: Any) {
        if let dict = sharedInstance.dictUserDetails {
            let mutableDict = dict.mutableCopy() as! NSMutableDictionary
            mutableDict.hmSet(object: value, forKey: key)
            sharedInstance.dictUserDetails = mutableDict.mutableCopy() as? NSMutableDictionary
        }
    }
    
    class func batchUpdateDictUserDetail(dict: [String: Any]) {
        if let dict = sharedInstance.dictUserDetails {
            let mutableDict = dict.mutableCopy() as! NSMutableDictionary
            for (str, value) in dict {
                if let key = str as? String {
                    mutableDict.hmSet(object: value, forKey: key)
                }
            }
            sharedInstance.dictUserDetails = mutableDict.mutableCopy() as? NSMutableDictionary
        }
    }
    
    class func getUserIdNameImage() -> (userId: String, userName: String, userImage: String) {
        var userId = ""
        var userName = ""
        var userImage = ""
        
        if let dict = sharedInstance.dictUserDetails {
            userId = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants._id)
            userName = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name)
            
            userImage = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.images)
            if userImage == "" {
                let arr = dict.hmGetNSArray(forKey: WebServiceConstants.images)
                if arr.count > 0 {
                    userImage = arr.hmString(atIndex: 0)
                }
            }
            
            if userImage == "" {
                userImage = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.image1)
            }
            
            if userImage == "" {
                userImage = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.image2)
            }
            
            if userImage == "" {
                userImage = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.image3)
            }
        }
        return (userId: userId, userName: userName, userImage: userImage)
    }
    
    class func getUserId() -> String {
        if let dict = sharedInstance.dictUserDetails {
            let _id = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants._id)
            return _id
        }
        return ""
    }
    
    class func getEmail() -> String {
        if let dict = sharedInstance.dictUserDetails {
            let email = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.email)
            return email
        }
        return ""
    }
    
    class func getMobileNumber() -> String {
        if let dict = sharedInstance.dictUserDetails {
            let cc = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.countryCode)
            let phoneNo = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.phoneNo)
            
            var full = cc + phoneNo
            full = full.replacingOccurrences(of: "+", with: "")
            full = "+" + full
            return full
        }
        return ""
    }
    
    class func getString(forKey key: String) -> String {
        if let dict = sharedInstance.dictUserDetails {
            let str = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: key)
            return str
        }
        return ""
    }
    
    class func getBool(forKey key: String) -> Bool {
        
        if let dict = sharedInstance.dictUserDetails {
            print("dict >>>>> \(dict)")
            print("key >>>>> \(key)")
            
            if let status = dict.hmGetObject(forKey: key) as? Bool {
                return status
            }
            
            if let status = dict.hmGetObject(forKey: key) as? String {
                if status.lowercased() == "true" || status.lowercased() == "yes" {
                    return true
                } else {
                    return false
                }
            }
            
            if let status = dict.hmGetObject(forKey: key) as? Int {
                if status == 1 {
                    return true
                } else {
                    return false
                }
            }
            
            if let status = dict.hmGetObject(forKey: key) as? NSNumber {
                if Int(status) == 1 {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    
    class func getUserDateOfBirth() -> String {
        var dateOfBirth = ""
        if let dict = sharedInstance.dictUserDetails {
            dateOfBirth = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.dateOfBirth)
            if dateOfBirth == "" {
                let dictDOB = dict.hmGetNSDictionary(forKey: WebServiceConstants.dateOfBirth)
                let sec = dictDOB.hmGetDouble(forKey: WebServiceConstants.sec)
                if sec > 0 {
                    let date = Date(timeIntervalSince1970: sec)
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let str: String? = dateFormatter.string(from: date)
                    if str != nil {
                        dateOfBirth = str!
                    }
                }
            }
        }
        return dateOfBirth
    }
    
    class func showCompleteProfilePopup() -> Bool {
        if let dict = sharedInstance.dictUserDetails {
            var dateOfBirthStatus = false
            var nameStatus = false
            var servicesStatus = false
            
            let dateOfBirth = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.dateOfBirth)
            if dateOfBirth == "" {
                let dictDOB = dict.hmGetNSDictionary(forKey: WebServiceConstants.dateOfBirth)
                let sec = dictDOB.hmGetDouble(forKey: WebServiceConstants.sec)
                if sec > 0 {
                    dateOfBirthStatus = true
                }
            }
            
            let name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name)
            if name != "" {
                nameStatus = true
            }
            
            let services = AppVariables.services(arr: nil, dict: dict).str
            if services != MessageStringFile.notAvailable() {
                servicesStatus = true
            }
            
            if !dateOfBirthStatus || !nameStatus || !servicesStatus {
                return true
            }
            
        }
        return false
    }
    /*
    class func getUserDateOfBirth(fromDict dict: NSDictionary, forObject object: String) -> String {
        var dateOfBirth = ""
        dateOfBirth = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: object)
        if dateOfBirth == "" {
            let dictDOB = dict.hmGetNSDictionary(forKey: object)
            let sec = dictDOB.hmGetDouble(forKey: WebServiceConstants.sec)
            if sec > 0 {
                let date = Date(timeIntervalSince1970: sec)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                let str: String? = dateFormatter.string(from: date)
                if str != nil {
                    print("str >>>> \(str)")
                    dateOfBirth = str!
                }
            }
        }
        return dateOfBirth
    }
    */
    class func getHeaderDictionary() -> [String: Any] {
        if let dict = sharedInstance.dictUserDetails {
            let token = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.token)
            let authorization = WebServiceConstants.bearer + " " + token
            return [WebServiceConstants.language: MessageStringFile.appLanguage(), WebServiceConstants.authorization: authorization]
        }
        return [:]
    }
    
    class func isUserLoginWithFacebook() -> Bool {
        if let dict = sharedInstance.dictUserDetails {
            let socialId = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.socialId)
            if socialId != "" {
                return true
            }
        }
        return false
    }
    
    
    class func services(arr: NSArray?, dict: NSDictionary?) -> (str: String, arr: NSArray) {
        var services = ""
        var arrServices = NSArray()
        if let dictResponse = dict {
            services = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.services)
            if services == "" {
                let arr = dictResponse.hmGetNSArray(forKey: WebServiceConstants.services)
                arrServices = arr
            }
        }
        
        if arrServices.count == 0 {
            if let arrTmp = arr {
                arrServices = arrTmp
            }
        }
        
        if services == "" {
            var str = ""
            for i in 0 ..< arrServices.count {
                let dict = arrServices.hmNSDictionary(atIndex: i)
                let strVal = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name).hm_UppercaseEveryWord
                if i == 0 {
                    str = strVal
                } else {
                    str += ", " + strVal
                }
            }
            services = str
        }
        
        if services == "" {
            //services = MessageStringFile.notAvailable()
        }
        
        return (services, arrServices)
    }
    
    class func otherServices(arr: NSArray?, dict: NSDictionary?) -> (str: String, arr: NSArray) {
        var services = ""
        var arrServices = NSArray()
        if let dictResponse = dict {
            services = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.otherService)
            if services == "" {
                let arr = dictResponse.hmGetNSArray(forKey: WebServiceConstants.otherService)
                arrServices = arr
            }
        }
        
        if arrServices.count == 0 {
            if let arrTmp = arr {
                arrServices = arrTmp
            }
        }
        
        if services == "" {
            var str = ""
            for i in 0 ..< arrServices.count {
                let dict = arrServices.hmNSDictionary(atIndex: i)
                let strVal = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name).hm_UppercaseEveryWord
                if i == 0 {
                    str = strVal
                } else {
                    str += ", " + strVal
                }
            }
            services = str
        }
        
        if services == "" {
            services = MessageStringFile.notAvailable()
        }
        
        return (services, arrServices)
    }
    
    class func servicesRequired(arr: NSArray?, dict: NSDictionary?) -> (str: String, arr: NSArray) {
        var services = ""
        var arrServices = NSArray()
        if let dictResponse = dict {
            services = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.serviceRequirement)
            if services == "" {
                let arr = dictResponse.hmGetNSArray(forKey: WebServiceConstants.serviceRequirement)
                arrServices = arr
            }
        }
        
        if arrServices.count == 0 {
            if let arrTmp = arr {
                arrServices = arrTmp
            }
        }
        
        if services == "" {
            var str = ""
            for i in 0 ..< arrServices.count {
                let dict = arrServices.hmNSDictionary(atIndex: i)
                let strVal = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name).hm_UppercaseEveryWord
                if i == 0 {
                    str = strVal
                } else {
                    str += ", " + strVal
                }
            }
            services = str
        }
        
        if services == "" {
            services = MessageStringFile.notAvailable()
        }
        
        return (services, arrServices)
    }
    
    class func servicesProvide(arr: NSArray?, dict: NSDictionary?) -> (str: String, arr: NSArray) {
        var services = ""
        var arrServices = NSArray()
        if let dictResponse = dict {
            services = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.serviceProvide)
            if services == "" {
                let arr = dictResponse.hmGetNSArray(forKey: WebServiceConstants.serviceProvide)
                arrServices = arr
            }
        }
        
        if arrServices.count == 0 {
            if let arrTmp = arr {
                arrServices = arrTmp
            }
        }
        
        if services == "" {
            var str = ""
            for i in 0 ..< arrServices.count {
                let dict = arrServices.hmNSDictionary(atIndex: i)
                let strVal = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name).hm_UppercaseEveryWord
                if i == 0 {
                    str = strVal
                } else {
                    str += ", " + strVal
                }
            }
            services = str
        }
        
        if services == "" {
            services = MessageStringFile.notAvailable()
        }
        
        return (services, arrServices)
    }
    
    class func languages(arr: NSArray?, dict: NSDictionary?) -> (str: String, arr: NSArray) {
        var services = ""
        var arrServices = NSArray()
        if let dictResponse = dict {
            services = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.languageKnown)
            if services == "" {
                let arr = dictResponse.hmGetNSArray(forKey: WebServiceConstants.languageKnown)
                arrServices = arr
            }
        }
        
        if arrServices.count == 0 {
            if let arrTmp = arr {
                arrServices = arrTmp
            }
        }
        
        if services == "" {
            var str = ""
            for i in 0 ..< arrServices.count {
                let dict = arrServices.hmNSDictionary(atIndex: i)
                let strVal = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name).hm_UppercaseEveryWord
                if i == 0 {
                    str = strVal
                } else {
                    str += ", " + strVal
                }
            }
            services = str
        }
        
        if services == "" {
            services = MessageStringFile.notAvailable()
        }
        
        return (services, arrServices)
    }
    
    //MARK: Chat Data
    
    class func getDictChat() -> NSDictionary {
        if let dict = sharedInstance.dictChat {
            return dict
        }
        return NSDictionary()
    }
    
    class func setDictChat(otherUserId id: String, otherUserName name: String, otherUserImage imageName: String) {
        let userDetail = HMSocketUserDefaults.getSocketUserIdNameAndImage()
        let dict = NSMutableDictionary()
        dict.hmSet(object: id, forKey: ChatDictConstants.otherId)
        dict.hmSet(object: name, forKey: ChatDictConstants.otherName)
        dict.hmSet(object: imageName, forKey: ChatDictConstants.otherImage)
        dict.hmSet(object: userDetail.id, forKey: ChatDictConstants.myId)
        dict.hmSet(object: userDetail.name, forKey: ChatDictConstants.myName)
        dict.hmSet(object: userDetail.image, forKey: ChatDictConstants.myImage)
        sharedInstance.dictChat = dict
    }
    
    class func removeChatData() {
        sharedInstance.dictChat = nil
    }
    
    class func getCurrentChatUserData() -> (userId: String, userName: String, userImage: String, otherUserId: String, otherUserName: String, otherUserImage: String) {
        var userId = ""
        var userName = ""
        var userImage = ""
        var otherUserId = ""
        var otherUserName = ""
        var otherUserImage = ""
        
        if let dict = sharedInstance.dictChat {
            userId = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: ChatDictConstants.myId)
            userName = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: ChatDictConstants.myName)
            userImage = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: ChatDictConstants.myImage)
            otherUserId = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: ChatDictConstants.otherId)
            otherUserName = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: ChatDictConstants.otherName)
            otherUserImage = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: ChatDictConstants.otherImage)
        }
        
        return (userId: userId, userName: userName, userImage: userImage, otherUserId: otherUserId, otherUserName: otherUserName, otherUserImage: otherUserImage)
    }
    
    class func getChatUserIdNameAndImage() -> (userId: String, userName: String, userImage: String) {
        let userDetail = HMSocketUserDefaults.getSocketUserIdNameAndImage()
        return (userId: userDetail.id, userName: userDetail.name, userImage: userDetail.image)
    }
    
    //MARK: Download Upload
    
    class func appendNewUploadDownloadData(_ hmUploadDownload: HMDownloadUpload) {
        if sharedInstance.arrDownloadUpload != nil {
            sharedInstance.arrDownloadUpload?.append(hmUploadDownload)
        } else {
            sharedInstance.arrDownloadUpload = [hmUploadDownload]
        }
    }
    
    class func removeUploadDownloadData(messageUniqueId id: Int) {
        if let arr = sharedInstance.arrDownloadUpload {
            for i in 0 ..< arr.count {
                let hmUploadDownload = arr[i]
                if id == hmUploadDownload.messageUniqueId {
                    sharedInstance.arrDownloadUpload?.remove(at: i)
                    break
                }
            }
        }
        
        if let arr = sharedInstance.arrDownloadUpload {
            if arr.count == 0 {
                sharedInstance.arrDownloadUpload = nil
            }
        }
    }
    
    class func updateProgressInUploadDownloadArray(messageUniqueId id: Int, progress: Float) {
        if let arr = sharedInstance.arrDownloadUpload {
            for i in 0 ..< arr.count {
                let hmUploadDownload = arr[i]
                if id == hmUploadDownload.messageUniqueId {
                    hmUploadDownload.progress = progress
                    sharedInstance.arrDownloadUpload?[i] = hmUploadDownload
                }
            }
        }
    }
    
    class func getProgressFromUploadDownloadArray(messageUniqueId id: Int) -> Float {
        if let arr = sharedInstance.arrDownloadUpload {
            for i in 0 ..< arr.count {
                let hmUploadDownload = arr[i]
                if id == hmUploadDownload.messageUniqueId {
                    return hmUploadDownload.progress
                }
            }
        }
        return 0.0
    }
    
    class func cancelUploadDownloadTask(messageUniqueId id: Int) {
        if let arr = sharedInstance.arrDownloadUpload {
            for i in 0 ..< arr.count {
                let hmUploadDownload = arr[i]
                if id == hmUploadDownload.messageUniqueId {
                    if hmUploadDownload.state == HMDownloadUploadState.upload {
                        hmUploadDownload.uploadTask?.cancel()
                    } else if hmUploadDownload.state == HMDownloadUploadState.download {
                        hmUploadDownload.imageOperation?.cancel()
                    } else {
                        hmUploadDownload.uploadTask?.cancel()
                        hmUploadDownload.imageOperation?.cancel()
                    }
                    
                    sharedInstance.arrDownloadUpload?.remove(at: i)
                    break
                }
            }
        }
        
        if let arr = sharedInstance.arrDownloadUpload {
            if arr.count == 0 {
                sharedInstance.arrDownloadUpload = nil
            }
        }
    }
    
}

struct ChatDictConstants {
    static let otherId = "otherUserId"
    static let otherName = "otherUserName"
    static let otherImage = "otherUserImage"
    static let otherUserType = "otherUserType"
    static let myId = "userId"
    static let myName = "userName"
    static let myImage = "userImage"
}

