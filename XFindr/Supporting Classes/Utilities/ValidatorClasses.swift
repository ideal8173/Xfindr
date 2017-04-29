
//
//  ValidatorClasses.swift
//  Brifway
//
//  Created by Honey Maheshwari on 23/11/15.
//  Copyright © 2015 Honey Maheshwari. All rights reserved.
//

import UIKit

class ValidatorClasses: NSObject {

    class func isValidEmail(testStr:String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
            return regex.firstMatch(in: testStr, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, testStr.characters.count)) != nil
        } catch {
            return false
        }
    }
    
   class func trimString(tempString : String)-> String{
        let trimmedString = tempString.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmedString
    }
    
    class func isValidLinkOrUrl(testStr:String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
            return regex.firstMatch(in: testStr, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, testStr.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    static let emailAcceptableCharacter = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.-@"
    
    static let emailAcceptableForMultipleEmail = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.-@, "
    static let AddressAcceptableCharacter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890,/- "
    static let NameAcceptableCharacter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
    static let offerCode = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
    static let alphaNumericAccept = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    static let ZipCodeAcceptableCharacter = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890"
    static let phoneNoAcceptableCharacter = "1234567890"
    static let countryCode = "1234567890+"
    static let deviceType = "iPhone"
    static let googleSearchApiKey = "AIzaSyBkoAKN_vAXcvYNiL1OdQK7yz1x3JtEBu8"
    
    class func isValidFiscaleCode(testStr:String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Za-z]{6}[0-9lmnpqrstuvLMNPQRSTUV]{2}[abcdehlmprstABCDEHLMPRST]{1}[0-9lmnpqrstuvLMNPQRSTUV]{2}[A-Za-z]{1}[0-9lmnpqrstuvLMNPQRSTUV]{3}[A-Za-z]{1}", options: .caseInsensitive)
            return regex.firstMatch(in: testStr, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, testStr.characters.count)) != nil
        } catch {
            return false
        }
        
    }
    
}
