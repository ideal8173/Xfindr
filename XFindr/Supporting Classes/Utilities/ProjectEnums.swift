//
//  ProjectEnums.swift
//  XFindr
//
//  Created by Rajat on 3/28/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import Foundation

enum RegisterationType {
    case mobileNumber
    case email
}

enum AppLanguage: String {
    case en = "en"
    case fr = "fr"
}

enum VerificationType {
    case mobile
    case email
    case registrationEmail
    case registrationMobile
    case loginEmail
    case loginMobile
}

enum SelectionType {
//    case specificServices
//    case otherServices
//    case requiredServices
//    case provideServices
    case services
    case language
    case city
}

enum FromClass {
    case editProfile
    case filter
    case personalInfo
}

enum ProfileImagePickerType {
    case profile1
    case profile2
    case profile3
}

enum TAndC {
    case termsAndCondition
    case privacyPolicy
}

enum SettingCellType {
    case typeButton
    case typeSwitch
    case typeDetail
    case typeDetailWithData
}

enum UnitSystem: String {
    case miles = "miles"
    case metric = "metric"
}

enum SwitchStatus: String {
    case on = "on"
    case off = "off"
}

enum UserType: String {
    case seeker = "seeker"
    case provider = "provider"
}






