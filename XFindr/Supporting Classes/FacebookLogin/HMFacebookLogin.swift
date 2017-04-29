//
//  HMFacebookLogin.swift
//  XFindr
//
//  Created by Honey Maheshwari on 4/11/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class HMFacebookLogin: NSObject {

    typealias hmFacebookCompletion = ((HMFacebookData, HMFacebookLoginStatus) -> Void)
    
    class func hmLoginUserWithFacebook(inViewController vc: UIViewController, hmCompletion: @escaping HMFacebookLogin.hmFacebookCompletion) {
        if FBSDKAccessToken.current() != nil {
            hmGetDataFromFacebook(inViewController: vc, hmCompletion: hmCompletion)
        } else {
            hmPerformFacebookLogin(inViewController: vc, hmCompletion: hmCompletion)
        }
    }
    
    class func hmCanLoginWithFacebook() -> Bool {
        if FBSDKAccessToken.current() != nil {
            return true
        }
        return false
    }
    
    class func hmLogoutFromFacebook() {
        FBSDKLoginManager().logOut()
    }
    
    fileprivate class func hmPerformFacebookLogin(inViewController vc: UIViewController, hmCompletion: @escaping HMFacebookLogin.hmFacebookCompletion) {
        //FBSDKLoginManager().logOut()
        let loginManager = FBSDKLoginManager()
        loginManager.loginBehavior = FBSDKLoginBehavior.web
        loginManager.logIn(withReadPermissions: ["public_profile", "email", "user_likes"], from: vc) { (loginManagerLoginResult, error) in
            if let result = loginManagerLoginResult {
                if result.isCancelled {
                    hmCompletion(HMFacebookData(), HMFacebookLoginStatus.canceled)
                } else {
                    hmGetDataFromFacebook(inViewController: vc, hmCompletion: hmCompletion)
                }
            } else {
                hmGetDataFromFacebook(inViewController: vc, hmCompletion: hmCompletion)
            }
        }
    }
    
    fileprivate class func hmGetDataFromFacebook(inViewController vc: UIViewController, hmCompletion: @escaping HMFacebookLogin.hmFacebookCompletion) {
        if FBSDKAccessToken.current() != nil {
            let fbGraphRequest: FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender, first_name, last_name, locale, email, picture.type(normal)"])
            fbGraphRequest.start(completionHandler: { (graphRequestConnection, result, error) in
                if error == nil {
                    if let data = result as? NSDictionary {
                        let first_name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: data, strObject: "first_name")
                        let last_name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: data, strObject: "last_name")
                        let id = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: data, strObject: "id")
                        let email = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: data, strObject: "email")
                        var imgUrl = ""
                        if id != "" {
                            imgUrl = "https://graph.facebook.com/" + id + "/picture?type=normal"
                        }
                        let fbData = HMFacebookData(id: id, firstName: first_name, lastName: last_name, email: email, imageUrlString: imgUrl)
                        hmCompletion(fbData, HMFacebookLoginStatus.success)
                    } else {
                        hmCompletion(HMFacebookData(), HMFacebookLoginStatus.dataNotAvailable)
                    }
                } else {
                    hmCompletion(HMFacebookData(), HMFacebookLoginStatus.error)
                }
            })
        } else {
            hmCompletion(HMFacebookData(), HMFacebookLoginStatus.dataNotAvailable)
        }
    }
    
}

class HMFacebookData: NSObject {
    
    var id: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var fullName: String = ""
    var email: String = ""
    var imageUrlString: String = ""
    
    override init() {
        self.id = ""
        self.firstName = ""
        self.lastName = ""
        self.fullName = ""
        self.email = ""
        self.imageUrlString = ""
    }
    
    init(id: String, firstName: String, lastName: String, email: String, imageUrlString: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = firstName + " " + lastName
        self.email = email
        self.imageUrlString = imageUrlString
    }
}

enum HMFacebookLoginStatus {
    case success
    case error
    case canceled
    case dataNotAvailable
}


