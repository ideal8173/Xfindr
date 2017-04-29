//
//  MessageStringFile.swift
//  XFindr
//
//  Created by Rajat on 3/23/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

var language: AppLanguage = .en

class MessageStringFile: NSObject {
    
    class func appLanguage() -> String {
        return "\(language.rawValue)"
    }
    
    class func serverError() -> String {
        return "Problem retrieving data from server due to connectivity issue."
    }
    
    class func networkReachability() -> String {
        return "There's no network connection right now. Please check your Wifi connection or mobile data."
    }
    
    class func vInfoNeeded() -> String {
        return "Just a tiny bit more details needed:"
    }
    
    class func whoopsText() -> String {
        return "Whoop's"
    }
    
    class func okText() -> String {
        return "Ok"
    }
    
    class func doneText() -> String {
        return "Done"
    }
    
    class func yesText() -> String {
        return "Yes"
    }
    
    class func noText() -> String {
        return "No"
    }
    
    class func chooseImage() -> String {
        return "Choose Image"
    }
    
    class func colonSymbol() -> String {
        return ":"
    }
    
    class func camera() -> String {
        return "Camera"
    }
    
    class func gallery() -> String {
        return "Gallery"
    }
    
    class func cancel() -> String {
        return "Cancel"
    }
    
    class func save() -> String {
        return "Save"
    }
    
    class func contineAsVisitor() -> String {
        return "Contine As Visitor"
    }
    
    class func membersLogin() -> String {
        return "Members Login"
    }
    
    class func newToXfindr() -> String {
        return "New to Xfindr"
    }
    
    class func vEmail() -> String {
        return "Email."
    }
    
    class func vEmailNotValid() -> String {
        return "Enter valid email address."
    }
    
    class func vEmailOrMobile() -> String {
        return "Enter email or mobile number."
    }
    
    class func vMobileNotValid() -> String {
        return "Enter valid mobile number."
    }

    class func vPassword() -> String {
        return "Password."
    }
    
    class func vConfirmPassword() -> String {
        return "Confirm Password."
    }
    
    class func vPhoneNotValid() -> String {
        return "Enter valid mobile number."
    }
    
    class func vPhoneNumber() -> String {
        return "Phone Number."
    }
    
    class func vPasswordAndConfirmPasswordNotMatch() -> String {
        return "Password and confirm password should match."
    }
    
    class func vOldPassword() -> String {
        return "Please enter old password."
    }
    
    class func vNewPassword() -> String {
        return "Please enter new password."
    }
    
    class func vPasswordLength() -> String {
        return "Password at least 6 characters long."
    }
    
    class func vVerificationCode() -> String {
        return "Verification Code."
    }
    
    //MARK: Tutorial
    
    class func tutorialTxt1() -> String {
        return "All services around you Seek and Provide services nearby."
    }
    
    class func tutorialTxt2() -> String {
        return "Customize your profile, Chat online, Share picture and location...."
    }
    
    class func tutorialTxt3() -> String {
        return "Filter and Explore services all over the world."
    }
    
    class func submit() -> String {
        return "Submit"
    }
    
    //MARK: Sign In
    
    class func signIn() -> String {
        return "Sign In"
    }
    
    class func signInWithFb() -> String {
        return "Sign In with Facebook"
    }
    
    class func signUp() -> String {
        return "Sign Up"
    }
    
    class func dontHaveAccount() -> String {
        return "Don't have a Account?"
    }
    
    class func signInLater() -> String {
        return "Sign In Later"
    }
    
    class func enterEmailOrMobileNo() -> String {
        return "Enter email or mobile number"
    }
    
    class func password() -> String {
        return "Password"
    }
    
    class func forgotPasswordWithQuestionMark() -> String {
        return "Forgot Password?"
    }
    
    //MARK: Sign Up
    
    class func visibleToOthers() -> String {
        return "This won’t make your mobile number or email address visible to others"
    }
    
    class func termsAndConditions() -> String {
        return "Terms & Conditions"
    }
    
    class func byClickingSignUp() -> String {
        return "By clicking Sign Up you agree to the Terms & Conditions"
    }
    
    class func enterMobileNo() -> String {
        return "Enter Mobile Number"
    }
    
    class func enterEmail() -> String {
        return "Enter Email Address"
    }
    
    class func confirmPassword() -> String {
        return "Confirm Password"
    }
    
    class func signUpWithFb() -> String {
        return "Sign Up with Facebook"
    }
    
    class func signUpWith() -> String {
        return "Sign Up with:"
    }
    
    class func emailAddress() -> String {
        return "Email Address"
    }
    
    class func mobileNumber() -> String {
        return "Mobile Number"
    }
    
    class func countryCode() -> String {
        return "CC"
    }
    
    //MARK: Forgot Password
    
    class func forgotPassword() -> String {
        return "Forgot Password"
    }
    
    class func toResetPassword() -> String {
        return "To Reset Password:"
    }
    
    //MARK: Verification 
    
    class func verifyText() -> String {
        return "Enter the 4 digit code sent to you at %@"
    }

    class func resentCodeIn() -> String {
        return "Resend code in"
    }
    
    class func resentCode() -> String {
        return "Resent code"
    }
    
    class func myProfile() -> String {
        return "My Profile"
    }
    
    class func pleaseCompleteYourProfile() -> String {
        return "Please complete your profile."
    }
    
    //MARK: Profile
    
    class func iSpeak() -> String {
        return "I speak"
    }
    
    class func other() -> String {
        return "Other"
    }
    
    class func requirement() -> String {
        return "Requirement"
    }
    
    class func provide() -> String {
        return "Provide"
    }
    
    class func moreAboutMe() -> String {
        return "More About Me"
    }
    
    class func hashtags() -> String {
        return "Hashtags"
    }
    
    class func hashtagswithHash() -> String {
        return "#Hashtags"
    }
    
    
    class func favourite() -> String {
        return "Favourite"
    }
    
    class func unFavourite() -> String {
        return "Unfavourite"
    }
    
    class func block() -> String {
        return "Block"
    }
    
    class func unBlock() -> String {
        return "Unblock"
    }
    
    class func guestbook() -> String {
        return "Guestbook"
    }
    
    class func blockConfirmation() -> String {
        return "Once you block, this user will not able to see your profile anymore and you will no longer receive messages from this profile."
    }
    
    class func unBlockConfirmation() -> String {
        return "This user is blocked and not able to message you. To start communication you need to unblock this profile."
    }
    
    
    //MARK: Edit Profile
    
    class func vName() -> String {
        return "Name"
    }
    
    class func vDateOfBirth() -> String {
        return "Date Of Birth"
    }
    
    class func typeOfServiceYouAreProviding() -> String {
        return "Type of service you are providing"
    }
    
    class func whatAreYouProviding() -> String {
        return "What are you providing"
    }
    
//    class func moreAboutWhatYouProvide() -> String {
//        return "More about what you provide"
//    }
    
    class func otherServicesYouMayProvide() -> String {
        return "Other service(s) you may provide"
    }
    
    class func servicesYouMayRequire() -> String {
        return "Service(s) you may require"
    }
    
    class func typeOfServiceYouAreSeekingFor() -> String {
        return "Type of service you are seeking for"
    }
    
    class func whatAreYouSeeking() -> String {
        return "What are you seeking"
    }
    
    class func profileTitle() -> String {
        return "Profile Title"
    }
    
//    class func moreAboutWhatYouRequire() -> String {
//        return "More about what you require"
//    }
    
    class func otherServicesYouMayRequire() -> String {
        return "Other service(s) you may require"
    }
    
    class func servicesYouMayProvide() -> String {
        return "Service(s) you may provide"
    }
    
    class func showMyPhoneNumber() -> String {
        return "Show My Phone Number"
    }
    
    class func phoneNumberHideWarningMessage() -> String {
        return "If you choose not to show your phone number, user can still contact you through Xfindr"
    }
    
    class func refuseAllCommercialApproach() -> String {
        return "Refuse all commercial approach"
    }
    
    class func languagesSpoken() -> String {
        return "Languages Spoken"
    }
    
    class func chooseATypeOfService() -> String {
        return "Choose a type of service and give your profile more chances to be found by user when they do a detailed search (Filter)"
    }
    
    
    class func addNumber() -> String {
        return "Add Number"
    }
    
    class func characters() -> String {
        return "Characters"
    }    
    
    class func vSpecificServicesOrSkillsThatYouProvide() -> String {
        return "Specific services or skills that you provide"
    }
    
    class func vSpecificServicesOrSkillsThatYouAreSeeking() -> String {
        return "Specific services or skills that you are seeking"
    }
    
    class func specificServicesOrSkillsThatYouProvide() -> String {
        return "Specific services or skills that you provide"
    }
    
    class func specificServicesOrSkillsThatYouAreSeeking() -> String {
        return "Specific services or skills that you are seeking"
    }
    
    class func otherServicesOrSkillsThatYouCanProvide() -> String {
        return "Other services or skills that you can provide"
    }
    
    class func otherServicesOrSkillsThatYouMaySeekFor() -> String {
        return "Other services or skills that you may seek for"
    }
    
    class func servicesOrSkillsThatYouMayRequire() -> String {
        return "Services or skills that you may require"
    }
    
    class func servicesOrSkillsThatYouMayProvide() -> String {
        return "Services or skills that you may provide"
    }
    
    class func languages() -> String {
        return "Languages"
    }
    
    class func uploadPicturesUpTo3() -> String {
        return "Upload Pictures (up to 3)"
    }
    
    class func maximum() -> String {
        return "Maximum"
    }
    
    class func notAvailable() -> String {
        return "N/A"
    }
    
    class func searchServices() -> String {
        return "Search Services"
    }
    
    class func searchCity() -> String {
        return "Search City"
    }
    
    class func searchLanguage() -> String {
        return "Search Language"
    }
    
    class func deleteConfirmation() -> String {
        return "Are you sure you want to delete this?"
    }
    
    //MARK: Personal Information
    
    class func addLanguageBtn() -> String {
        return "+ Add"
    }
    
    class func vMoreAboutMe() -> String {
        return "More About Me"
    }
    
    class func vHashtag() -> String {
        return "#Hashtags"
    }
    
    class func vLanguage() -> String {
        return "At Least One Language"
    }
    
    class func upTo500Characters() -> String {
        return "Up to 500 characters"
    }
    
    class func maximum4Languages() -> String {
        return "Maximum 4 languages"
    }
    
    
    //MARK: Setting
    
    
    class func account() -> String {
        return "Account"
    }
    
    class func email() -> String {
        return "Email"
    }
    
    class func changePassword() -> String {
        return "Change Password"
    }
    
    class func notifications() -> String {
        return "Notifications"
    }
    
    class func preference() -> String {
        return "Preference"
    }
    
    class func showMyDistance() -> String {
        return "Show My Distance"
    }
    
    class func unitSystem() -> String {
        return "Unit System"
    }
    
    class func sound() -> String {
        return "Sound"
    }
    
    class func pushNotification() -> String {
        return "Push Notification"
    }
    
    class func showMyGuestbook() -> String {
        return "Show My Guestbook"
    }
    
    class func beFollowed() -> String {
        return "Be Followed"
    }
    
    class func applicationLanguage() -> String {
        return "Application Language"
    }
    
    class func about() -> String {
        return "About"
    }
    
    class func support() -> String {
        return "Support"
    }
    
    class func termsOfServices() -> String {
        return "Terms of Services"
    }
    
    class func privacyPolicy() -> String {
        return "Privacy Policy"
    }
    
    class func reset() -> String {
        return "Reset"
    }
    
    class func unblockAll() -> String {
        return "Unblock All"
    }
    
    class func deleteProfile() -> String {
        return "Delete Profile"
    }
    
    class func logout() -> String {
        return "Logout"
    }
    
    class func english() -> String {
        return "English"
    }
    
    class func french() -> String {
        return "French"
    }

    //MARK: Explore
    
    class func exploreHere() -> String {
        return "Explore Here"
    }
    
    class func enterACityOrAnAddress() -> String {
        return "Enter a city or an address"
    }
    
    //MARK: Filter
    
    class func keywords() -> String {
        return "Keyword(s)"
    }
    
    class func optionalTxt() -> String {
        return "optional"
    }
    
    class func optional() -> String {
        return "(optional)"
    }
    
    class func seeker() -> String {
        return "Seeker"
    }
    
    class func provider() -> String {
        return "Provider"
    }
    
    //MARK: Change Password
    
    class func currentPass() -> String {
        return "Current Password"
    }
    
    class func newPass() -> String {
        return "New Password"
    }
    
    class func confirmNewPass() -> String {
        return "Confirm New Password"
    }
    
    class func currentMobile() -> String {
        return "Current"
    }
    
    class func vCurrentPassword() -> String {
        return "Current Password."
    }
    
    class func vCurrentPasswordLength() -> String {
        return "Current Password should be at least 6 characters long."
    }
    
    class func vNewPasswordLength() -> String {
        return "New Password should be at least 6 characters long."
    }
    
    class func vOldAndNewPass() -> String {
        return "Old and New Password should not match."
    }
    
}

class ClassesHeader: NSObject {
    
    class func home() -> String {
        return "Users Around"
    }
    
    class func profile() -> String {
        return ""
    }
    
    class func editProfile() -> String {
        return "Edit Profile"
    }
    
    class func personalInformation() -> String {
        return "Personal Information"
    }
    
    class func termsAndConditions() -> String {
        return "Terms And Conditions"
    }
    
    class func privacyPolicy() -> String {
        return "Privacy Policy"
    }
    
    class func languages() -> String {
        return "Languages"
    }
    
    class func services() -> String {
        return "Services"
    }
    
    class func city() -> String {
        return "Cities"
    }
    
    class func settings() -> String {
        return "Settings"
    }
    
    class func explore() -> String {
        return "Explore"
    }
    
    class func favorites() -> String {
        return "Favorites"
    }
    
    class func changePassword() -> String {
        return "Change Password"
    }
    
    class func support() -> String {
        return "Support"
    }
    
    class func ChangeMobileNumber() -> String {
        return "Change Mobile Number"
    }
    
    class func ChangeEmail() -> String {
        return "Change Email"
    }
    
}


class PredefinedConstants: NSObject {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate

    static let userDeviceType = "iphone"
    static let userDeviceId = UIDevice.current.identifierForVendor!.uuidString
    static let deviceAppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    static let alertBackgroundColor = UIColor.white
    static let darkBlack = UIColor.black
    static let lightBlack  = UIColor.lightGray
    static let darkWhite = UIColor.darkGray
    
    static let blackColor = UIColor(hm_hexString: "#77c7fe")
    static let grayTextColor = UIColor(hm_hexString: "#9a9a9a")
    static let darkGrayTextColor = UIColor(hm_hexString: "#9e9e9e")
    
    static let navigationColor = UIColor(hm_hexString: "#0096ff")
    static let backgroundColor = UIColor(hm_hexString: "#0296FF")
    static let redColor = UIColor(hm_hexString: "#f31414")
    
    static let settingButtonTextColor = UIColor(hm_hexString: "#848484")
    static let settingButtonBackgroundColor = UIColor(hm_hexString: "#dbdbdb")
    
    static let darkBlueColor = UIColor(hm_hexString: "#0a3261")
    
    static let uncheckColor = UIColor(colorLiteralRed: 95.0/255.0, green: 95.0/255.0, blue: 95.0/255.0, alpha: 1)
    
    static func appFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica", size: size)!
    }
    
    static func appBoldFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Helvetica Bold", size: size)!
    }
    
    static let dividerLineColor = UIColor(hm_hexString: "#CCCCCC")
}
