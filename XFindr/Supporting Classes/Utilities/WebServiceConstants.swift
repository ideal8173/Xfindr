//
//  WebServiceConstants.swift
//  XFindr
//
//  Created by Rajat on 3/23/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import Foundation
import UIKit

class WebServiceLinks: NSObject {
    
    static let staticBaseUrl: String = "http://192.168.1.101/xfindr/api/v1/baseurl"
    //static let staticBaseUrl: String = "http://xfindr.com/api/v1/baseurl"
    
    class var baseUrl: String {
        get {
            if let dict = UserDefaults.standard.dictionary(forKey: XFindrUserDefaults.baseUrlData) {
                let dictData = dict as NSDictionary
                let baseUrl = dictData.hmGetString(forKey: WebServiceConstants.baseurl)
                if baseUrl.hm_Length > 0 {
                    return baseUrl
                }
            }
            return WebServiceLinks.staticBaseUrl.replacingOccurrences(of: "baseurl", with: "")
        }
    }
    
    class func userImageUrl() -> String {
        if let dict = UserDefaults.standard.dictionary(forKey: XFindrUserDefaults.baseUrlData) {
            let dictData = dict as NSDictionary
            let userImage = dictData.hmGetString(forKey: WebServiceConstants.userImage)
            if userImage.hm_Length > 0 {
                return userImage
            }
        }
        return "http://xfindr.com/public/uploads/user/"
    }
    
    class var login: String {
        get {
            return (baseUrl + "login")
        }
    }
    
    class var registration: String {
        get {
            return (baseUrl + "registration")
        }
    }
    
    class var verifyMobile: String {
        get {
            return (baseUrl + "verify-mobile")
        }
    }
    
    class var nearByUser: String {
        get {
            return (baseUrl + "near-by-user")
        }
    }
    
    class var sendVerificationCode: String {
        get {
            return (baseUrl + "send-verification-code")
        }
    }
    
    class var userDetail: String {
        get {
            return (baseUrl + "user-detail")
        }
    }
    
    class var serviceList: String {
        get {
            return (baseUrl + "service-list")
        }
    }
    
    class var languageList: String {
        get {
            return (baseUrl + "language-list")
        }
    }
    
    class var cityList: String {
        get {
            return (baseUrl + "city-list")
        }
    }
    
    class var updateProfile: String {
        get {
            return (baseUrl + "update-profile")
        }
    }
    
    class var deleteImage: String {
        get {
            return (baseUrl + "delete-image")
        }
    }
    
    class var termsAndPrivacy: String {
        get {
            return (baseUrl + "terms-and-privacy")
        }
    }
    
    class var forgotPassword: String {
        get {
            return (baseUrl + "forgot-password")
        }
    }
    
    class var setting: String {
        get {
            return (baseUrl + "setting")
        }
    }
    
    class var favouriteUserList: String {
        get {
            return (baseUrl + "favourite-user-list")
        }
    }
    
    class var addFavouriteUser: String {
        get {
            return (baseUrl + "add-favourite-user")
        }
    }
    
    class var blockUser: String {
        get {
            return (baseUrl + "block-user")
        }
    }
    
    class var userList: String {
        get {
            return (HMSocketConstants.baseUrl + "user_list")
        }
    }
    
    class var changePassword: String {
        get {
            return (baseUrl + "change-password")
        }
    }
    
    class var updateServices: String {
        get {
            return (baseUrl + "update-services")
        }
    }
    
    class var updateUserType: String {
        get {
            return (baseUrl + "update-user-type")
        }
    }
    
}

struct WebServiceConstants {
    
    static let success = "success"
    static let msg = "msg"
    static let result = "result"
    
    static let webServiceLinks = "web_service_links"
    static let baseurl = "baseurl"
    static let userImage = "user_image"
    
    static let apiKey = "Apikey"
    
    static let page = "pageno"
    static let token = "token"
    static let authorization = "Authorization"
    static let bearer = "Bearer"
    //MARK: Sign Up
    
    static let email = "email"
    static let phoneNo = "phone_no"
    static let password = "password"
    static let deviceType = "device_type"
    static let deviceId = "device_id"
    static let appVersion = "app_version"
    static let socialId = "socialid"
    static let language = "language"
    static let name = "name"
    static let user_name = "user_name"
    static let countryCode = "country_code"
    static let age = "age"
    static let languageKnown = "language_known"
    
    //MARK: Login
    static let emailPhoneNo = "email_phone_no"
    
    //MARK: Verification
    
    static let isEmailVerified = "is_email_verified"
    static let isMobileVerified = "is_mobile_verified"
    static let code = "code"
    
    //MARK: HOME
    
    static let userId = "user_id"
    static let user_type = "user_type"
    static let service = "service"
    static let presence_status = "presence_status"
    static let images = "images"
    static let _id = "_id"
    
    static let services = "services"
    static let otherService = "other_service"
    static let serviceRequirement = "service_requirement"
    static let serviceProvide = "service_provide"
    
    static let both = "both"
    static let seeker = "seeker"
    static let provider = "provider"
    static let userSelf = "self"
    static let online = "online"
    static let offline = "offline"
    static let long = "long"
    static let lat = "lat"
    
    //MARK: Profile
    
    static let lat_long = "lat_long"
    static let description = "description"
    static let hashtags = "hastag"
    static let reviewList = "guest_book"
    static let reviewCount = "guest_book_count"
    static let dateOfBirth = "date_of_birth"
    static let sec = "sec"
    
    static let fromName = "from_name"
    static let review = "review"
    static let city = "city"
    static let state = "state"
    static let country = "country"
    static let urgentRequirement = "urgent_requirement"
    static let yes = "yes"
    static let no = "no"
    static let image1 = "image1"
    static let image2 = "image2"
    static let image3 = "image3"
    
    static let favourite_status = "favourite_status"
    static let block_status = "block_status"
    static let login_id = "login_id"
    
    static let image = "image"
    
    static let pageType = "page_type"
    static let termAndConditions = "term_and_conditions"
    static let privacyPolicy = "privacy_policy"
    
    static let distance = "distance"
    static let soundStatus = "sound_status"
    static let notificationStatus = "notification_status"
    static let guestStatus = "guest_status"
    static let followedStatus = "followed_status"
    static let unitSystem = "unit_system"
    
    
    static let providerServices = "provider_services"
    static let providerNote = "provider_note"
    static let providerDesc = "provider_desc"
    static let providerHashtag = "provider_hashtag"
    static let providerRequire = "provider_require"
    static let providerOther = "provider_other"
    static let seekerServices = "seeker_services"
    static let seekerNote = "seeker_note"
    static let seekerDesc = "seeker_desc"
    static let seekerOther = "seeker_other"
    static let seekerHashtag = "seeker_hashtag"
    static let seekerProvide = "seeker_provide"
    
    
    // Favourite
    static let type = "type"
    static let favourite = "favourite"
    static let unfavourite = "unfavourite"
    
    
    // block
    static let block = "block"
    static let unBlock = "unblock"
    
    static let favourite_id = "favourite_id"
    static let favourite_image = "favourite_image"
    static let favourite_name = "favourite_name"
    
    static let by_image = "by_image"
    static let by_name = "by_name"
    static let from_id = "from_id"
    static let publish_status = "publish_status"
    static let rate_on = "rate_on"
    static let to_id = "to_id"
    static let to_image = "to_image"
    static let to_name = "to_name"
    
    static let old_Pass = "old_password"
    static let new_Pass = "new_password"
}

/*
 name,date_of_birth,user_type,description,service,other,other_service,requirement,language,hastag,
 image1,image2,image3,urgent_requirement(yes/no),service_provide,language_known,city,
 state,country
 */

/*
 dictResponse >>>>>> Optional(["msg": You have registered successfully. Please complete your profile., "verify_code": 3975, "result": {
 "_id" = 58df9ed37ac6f6632c8b4567;
 address = "";
 age = "";
 "app_version" = "1.0";
 "country_code" = 1;
 description = "";
 "device_id" = "A73AC91B-CD80-46F8-AA53-E2BA72FCDC84";
 "device_type" = iphone;
 distance = 1;
 email = "honey@idealittechno.com";
 "emailverify_code" = 8ef897e468650c19f3f31529712fc500;
 "extra_images" =     (
 );
 image = "";
 "is_email_verified" = 0;
 "is_mobile_verified" = 0;
 language = en;
 "lat_long" =     (
 );
 name = "";
 "notification_status" = 1;
 other = "";
 "other_requirement" = "";
 password = "$2y$10$sbxBSKfZlb4/3lY1vej.gOYoFWLV/B7E6JfoA7A00hqUddZgHKjQa";
 "phone_no" = "";
 "presence_status" = online;
 "rate_status" = 1;
 rating = "";
 "rating_count" = "";
 requirement = "";
 services =     (
 );
 setting = 30;
 socialid = "<null>";
 "sound_status" = 1;
 status = active;
 token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1OGRmOWVkMzdhYzZmNjYzMmM4YjQ1NjciLCJpc3MiOiJodHRwOlwvXC8xOTIuMTY4LjEuMTAxXC94ZmluZGVyXC9hcGlcL3YxXC9yZWdpc3RyYXRpb24iLCJpYXQiOjE0OTEwNTAxOTUsImV4cCI6MTQ5MTE3MDE5NSwibmJmIjoxNDkxMDUwMTk1LCJqdGkiOiIwNDdhNzAzNjBkYjAyNmFjZWI3NTRkMDhiMzEyMzhlZSJ9.aBLaNEK6oK0Gy6CKAE_OkjBbX9OzaOQ6CEZhidAIVi4";
 "unit_system" = mile;
 "user_type" = provider;
 }, "success": 1])
 */
