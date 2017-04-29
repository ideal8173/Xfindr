//
//  Utilities.swift
//  testSwift3SupportinClasses
//
//  Created by Honey Maheshwari on 9/26/16.
//  Copyright © 2016 Honey Maheshwari. All rights reserved.
//

import UIKit

class HelperClass: NSObject {
        
    //MARK: Internet
    
    class var isInternetAvailable: Bool {
        get {
            let tempAppDelegate = UIApplication.shared.delegate as! AppDelegate
            if tempAppDelegate.reachability == nil {
                tempAppDelegate.reachability = Reachability()!
            }
            if tempAppDelegate.reachability!.isReachable {
                return true
            }
            return false
        }
    }

    //MARK: Check
    
    class func checkObjectInDictionaryWithNoDecimal(dictH: NSDictionary, strObject: String) -> String {
        return checkObjectInDictionary(dictH: dictH, strObject: strObject, pointValue: 0)
    }
    
    class func checkObjectInDictionary(dictH: NSDictionary, strObject: String) -> String {
        return checkObjectInDictionary(dictH: dictH, strObject: strObject, pointValue: 2)
    }
    
    class func checkObjectInDictionary(dictH: NSDictionary, strObject: String, pointValue: Int) -> String {
        var strHoney: String = ""
        if !(dictH.hmGetObject(forKey: strObject) is NSNull) && dictH.hmGetObject(forKey: strObject) != nil {
            if (dictH.hmGetObject(forKey: strObject) as? NSNumber != nil) {
                let numH = dictH.hmGetObject(forKey: strObject) as? NSNumber
                let floatH = numH?.floatValue
                if pointValue == 0 {
                    strHoney = NSString(format: "%.0f", floatH!) as String
                } else if pointValue == 1 {
                    strHoney = NSString(format: "%.1f", floatH!) as String
                } else if pointValue == 2 {
                    strHoney = NSString(format: "%.2f", floatH!) as String
                } else if pointValue == 3 {
                    strHoney = NSString(format: "%.3f", floatH!) as String
                } else if pointValue == 4 {
                    strHoney = NSString(format: "%.4f", floatH!) as String
                } else if pointValue == 5 {
                    strHoney = NSString(format: "%.5f", floatH!) as String
                } else if pointValue == 6 {
                    strHoney = NSString(format: "%.6f", floatH!) as String
                } else if pointValue == 7 {
                    strHoney = NSString(format: "%.7f", floatH!) as String
                } else if pointValue == 8 {
                    strHoney = NSString(format: "%.8f", floatH!) as String
                } else if pointValue == 9 {
                    strHoney = NSString(format: "%.9f", floatH!) as String
                } else if pointValue == 10 {
                    strHoney = NSString(format: "%.10f", floatH!) as String
                } else {
                    strHoney = NSString(format: "%.11f", floatH!) as String
                }
            } else if (dictH.hmGetObject(forKey: strObject) as? String != nil){
                strHoney = dictH.hmGetObject(forKey: strObject) as! String
            }
        }
        return strHoney
    }
    
    class func setObjectInNSDictionary(dict: NSDictionary!, key: String!, object: Any!) -> NSDictionary {
        let mutableDict = NSMutableDictionary(dictionary: dict).mutableCopy() as! NSMutableDictionary
        mutableDict.hmSet(value: object, forKey: key)
        let newDict = NSDictionary(dictionary: mutableDict)
        return newDict
    }
    
    class func openUrl(str: String) {
        if let url = URL(string: str) {
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { (completed) in
                        
                    })
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    class func hmGetTextSize(text: String, font: UIFont, boundedBySize: CGSize) -> CGSize {
        let attrString = NSAttributedString(string: text, attributes: [NSFontAttributeName: font])
        let size = attrString.boundingRect(with: boundedBySize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil).size
        return size
    }
    
    class func startIgnoringInteractionEvent() {
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    class func endIgnoringInteractionEvent() {
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
    class func textWithImage(image: UIImage?, str: String) -> NSAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.bounds = CGRect(x: 0.0, y: 5.0, width: attachment.image!.size.width, height: attachment.image!.size.height)
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(attributedString: attachmentString)
        myString.append(NSAttributedString(string: str))
        return myString
    }
    
    class func createAttributedString(mainString str1: String, stringToColor str2: String, font: UIFont?, color: UIColor?) -> NSAttributedString {
        let strToUnchangeChanege = NSMutableAttributedString(string: str1)
        var attributes: [String: Any] = [:]
        if let f = font {
            attributes[NSFontAttributeName] = f
        }
        if let c = color {
            attributes[NSForegroundColorAttributeName] = c
        }
        let strToChange = NSMutableAttributedString(string: str2, attributes: attributes)
        strToUnchangeChanege.append(strToChange)
        return strToUnchangeChanege
    }
    
}

struct ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}

class HMUtilities: NSObject {
    
    class func hmMainQueue(hmCompletion: @escaping HMVariable.hmCompletionHandler) {
        DispatchQueue.main.async {
            hmCompletion()
        }
    }
    
    class func hmDefaultPriority(hmCompletion: @escaping HMVariable.hmCompletionHandler) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            hmCompletion()
        }
    }
    
    class func hmDefaultMainQueue(hmCompletion: @escaping HMVariable.hmCompletionHandler) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            DispatchQueue.main.async {
                hmCompletion()
            }
        }
    }
    
    class func hmBackgroundQueue(hmCompletion: @escaping HMVariable.hmCompletionHandler) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            hmCompletion()
        }
    }
    
    class func hmMainBackgroundQueue(hmCompletion: @escaping HMVariable.hmCompletionHandler) {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            DispatchQueue.main.async {
                hmCompletion()
            }
        }
    }
    
    class func hmDelay(delay: Double, hmCompletion: @escaping HMVariable.hmCompletionHandler) {
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when) {
            hmCompletion()
        }
    }
    
}

public class HMVariable: NSObject {
    public typealias hmStringHandler = ((String) -> Swift.Void)
    public typealias hmAlertHandler = ((UIAlertAction) -> Swift.Void)
    public typealias hmCompletionHandler = @convention(block) () -> Swift.Void
    public typealias hmConnected = ((Bool) -> Swift.Void)
    public typealias hmDictionary = ((NSDictionary?) -> Swift.Void)
}


class HMAlert: NSObject {
    
    class func hmSimpleAlert(message: String?, inViewController vc: UIViewController!) {
        hmSimpleAlert(title: nil, message: message, buttonTitle: nil, inViewController: vc)
    }
    
    class func hmSimpleAlert(title: String?, message: String?, inViewController vc: UIViewController!) {
        hmSimpleAlert(title: title, message: message, buttonTitle: nil, inViewController: vc)
    }
    
    class func hmSimpleAlert(title: String?, message: String?, buttonTitle: String?, inViewController vc: UIViewController!) {
        
        var strButtonTitle = "Ok"
        if buttonTitle != nil {
            strButtonTitle = buttonTitle!
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: strButtonTitle, style: UIAlertActionStyle.default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func hmSimpleAlert(title: String?, message: String?, buttonTitle: String?, inViewController vc: UIViewController!, handler: @escaping HMVariable.hmAlertHandler) {
        
        var strButtonTitle = "Ok"
        if buttonTitle != nil {
            strButtonTitle = buttonTitle!
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: strButtonTitle, style: UIAlertActionStyle.default, handler: handler))
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func hmSimpleAlert(title: String?, message: String?, buttonTitle: String?, btnStyle: UIAlertActionStyle, inViewController vc: UIViewController!, handler: @escaping HMVariable.hmAlertHandler) {
        
        var strButtonTitle = "Ok"
        if buttonTitle != nil {
            strButtonTitle = buttonTitle!
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: strButtonTitle, style: btnStyle, handler: handler))
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    class func hmAlertWithTwoButton(message: String?, firstButtonTitle: String?, secondButtonTitle: String?, inViewController vc: UIViewController!, handler: @escaping HMVariable.hmStringHandler) {
        
        hmAlertWithTwoButton(title: nil, message: message, firstButtonTitle: firstButtonTitle, secondButtonTitle: secondButtonTitle, inViewController: vc, handler: handler)
        
    }
    
    class func hmAlertWithTwoButton(title: String?, message: String?, firstButtonTitle: String?, secondButtonTitle: String?, inViewController vc: UIViewController!, handler: @escaping HMVariable.hmStringHandler) {
        
        var strButton1Title = "Ok"
        if firstButtonTitle != nil {
            strButton1Title = firstButtonTitle!
        }
        
        var strButton2Title = "Cancel"
        if secondButtonTitle != nil {
            strButton2Title = secondButtonTitle!
        }
        
        if (strButton1Title.lowercased() == "ok" && strButton2Title.lowercased() == "cancel") {
            hmAlertWithArray(title: title, message: message, buttonArray: [strButton2Title, strButton1Title], inViewController: vc, handler: handler)
        } else {
            hmAlertWithArray(title: title, message: message, buttonArray: [strButton1Title, strButton2Title], inViewController: vc, handler: handler)
        }
        
    }
    
    class func hmAlertWithTwoButton(message: String?, firstButtonTitle: String?, firstButtonStyle: UIAlertActionStyle, secondButtonTitle: String?, secondButtonStyle: UIAlertActionStyle, inViewController vc: UIViewController!, handler: @escaping HMVariable.hmStringHandler) {
        
        hmAlertWithTwoButton(title: nil, message: message, firstButtonTitle: firstButtonTitle, firstButtonStyle: firstButtonStyle, secondButtonTitle: secondButtonTitle, secondButtonStyle: secondButtonStyle, inViewController: vc, handler: handler)

    }
    
    class func hmAlertWithTwoButton(title: String?, message: String?, firstButtonTitle: String?, firstButtonStyle: UIAlertActionStyle, secondButtonTitle: String?, secondButtonStyle: UIAlertActionStyle, inViewController vc: UIViewController!, handler: @escaping HMVariable.hmStringHandler) {
        
        var strButton1Title = "Ok"
        if firstButtonTitle != nil {
            strButton1Title = firstButtonTitle!
        }
        
        var strButton2Title = "Cancel"
        if secondButtonTitle != nil {
            strButton2Title = secondButtonTitle!
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: strButton1Title, style: firstButtonStyle, handler: { (action) in
            handler(strButton1Title)
        }))
        alert.addAction(UIAlertAction(title: strButton2Title, style: secondButtonStyle, handler: { (action) in
            handler(strButton2Title)
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func hmAlertWithTwoButtonAndCancel(title: String?, message: String?, firstButtonTitle: String?, secondButtonTitle: String?, inViewController vc: UIViewController!, handler: @escaping HMVariable.hmStringHandler) {
        
        var strButton1Title = "Ok"
        if firstButtonTitle != nil {
            strButton1Title = firstButtonTitle!
        }
        
        var strButton2Title = "Cancel"
        if secondButtonTitle != nil {
            strButton2Title = secondButtonTitle!
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: strButton1Title, style: UIAlertActionStyle.default, handler: { (action) in
            handler(strButton1Title)
        }))
        alert.addAction(UIAlertAction(title: strButton2Title, style: UIAlertActionStyle.cancel, handler: { (action) in
            handler(strButton2Title)
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    class func hmAlertWithTwoButtonAndDestructive(message: String?, firstButtonTitle: String?, secondButtonTitle: String?, inViewController vc: UIViewController!, handler: @escaping HMVariable.hmStringHandler) {
        
        hmAlertWithTwoButtonAndDestructive(title: nil, message: message, firstButtonTitle: firstButtonTitle, secondButtonTitle: secondButtonTitle, inViewController: vc, handler: handler)
    }
    
    class func hmAlertWithTwoButtonAndDestructive(title: String?, message: String?, firstButtonTitle: String?, secondButtonTitle: String?, inViewController vc: UIViewController!, handler: @escaping HMVariable.hmStringHandler) {
        
        var strButton1Title = "Ok"
        if firstButtonTitle != nil {
            strButton1Title = firstButtonTitle!
        }
        
        var strButton2Title = "Cancel"
        if secondButtonTitle != nil {
            strButton2Title = secondButtonTitle!
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: strButton1Title, style: UIAlertActionStyle.default, handler: { (action) in
            handler(strButton1Title)
        }))
        alert.addAction(UIAlertAction(title: strButton2Title, style: UIAlertActionStyle.destructive, handler: { (action) in
            handler(strButton2Title)
        }))
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    class func hmAlertWithArray(message: String?, buttonArray arrButtons:[String]!, inViewController vc: UIViewController!, handler: @escaping HMVariable.hmStringHandler) {
        
        hmAlertWithArray(title: nil, message: message, buttonArray: arrButtons, inViewController: vc, handler: handler)
        
    }
    
    class func hmAlertWithArray(title: String?, message: String?, buttonArray arrButtons:[String]!, inViewController vc: UIViewController!, handler: @escaping HMVariable.hmStringHandler) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        for btnTitles in arrButtons {
            alert.addAction(UIAlertAction(title: btnTitles, style: UIAlertActionStyle.default, handler: { (action) in
                handler(btnTitles)
            }))
        }
        vc.present(alert, animated: true, completion: nil)
        
    }
    
    class func hmAlertWithArray(message: String?, buttonArray arrButtons:[String]!, buttonStyleArray arrStyle:[UIAlertActionStyle], inViewController vc: UIViewController!, handler: @escaping HMVariable.hmStringHandler) {
        
        hmAlertWithArray(title: nil, message: message, buttonArray: arrButtons, buttonStyleArray: arrStyle, inViewController: vc, handler: handler)
    }
    
    class func hmAlertWithArray(title: String?, message: String?, buttonArray arrButtons:[String]!, buttonStyleArray arrStyle:[UIAlertActionStyle], inViewController vc: UIViewController!, handler: @escaping HMVariable.hmStringHandler) {
        
        if arrButtons.count == arrStyle.count {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            
            for i in 0 ..< arrButtons.count {
                alert.addAction(UIAlertAction(title: arrButtons[i], style: arrStyle[i], handler: { (action) in
                    handler(arrButtons[i])
                }))
            }
            vc.present(alert, animated: true, completion: nil)
        }
        
    }
    
}
