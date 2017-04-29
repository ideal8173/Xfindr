//
//  XFindrUserDefaults.swift
//  XFindr
//
//  Created by Rajat on 3/23/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class XFindrUserDefaults: NSObject {

    static let email = "xfindr_mail"
    static let password = "xfindr_password"
    static let isRemember = "xfindr_isRemember"
    static let baseUrlData = "xfindr_baseUrlData"
    static let loginStatus = "xfindr_loginStatus"
 
    //MARK:- User Info
    
    class func setEmailPasswordInUserDefaults(email: String, password: String, isRemember: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(email, forKey: XFindrUserDefaults.email)
        userDefaults.set(password, forKey: XFindrUserDefaults.password)
        if isRemember == true {
            userDefaults.set(true, forKey: XFindrUserDefaults.isRemember)
        } else {
            userDefaults.set(false, forKey: XFindrUserDefaults.isRemember)
        }
    }
    
    class func getEmailPassword() -> (email: String, password: String, isRemember: Bool) {
        let userDefaults = UserDefaults.standard
        var email = ""
        var password = ""
        var isRemember = false
        
        if let str = userDefaults.string(forKey: XFindrUserDefaults.email) {
            email = str
        }
        
        if email == "" {
            if let value = userDefaults.object(forKey: XFindrUserDefaults.email) {
                email = "\(value)"
            }
        }
        
        if let str = userDefaults.string(forKey: XFindrUserDefaults.password) {
            password = str
        }
        
        if password == "" {
            if let value = userDefaults.object(forKey: XFindrUserDefaults.password) {
                password = "\(value)"
            }
        }
        
        if userDefaults.bool(forKey: XFindrUserDefaults.isRemember) == true {
            isRemember = true
        }
        
        return(email, password, isRemember)
    }
    
    static var isUserLogin: Bool {
        get {
            if UserDefaults.standard.integer(forKey: loginStatus) != 0 {
                return true
            }
            return false
        }
    }
    
    class func setUserLoginStatus(status: Int?) {
        if status != nil {
            UserDefaults.standard.set(1, forKey: loginStatus)
        } else {
            UserDefaults.standard.removeObject(forKey: loginStatus)
        }
    }
    
    //MARK:- BaseUrl Data
    
    class func setBaseUrlData(dict: NSDictionary) {
        UserDefaults.standard.set(dict, forKey: XFindrUserDefaults.baseUrlData)
    }
    
    class func getBaseUrlData() -> NSDictionary {
        if let dict = UserDefaults.standard.dictionary(forKey: XFindrUserDefaults.baseUrlData) {
            let dictData = dict as NSDictionary
            return dictData
        }
        return NSDictionary()
    }
    
}
