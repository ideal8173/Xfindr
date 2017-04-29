//
//  HMString.swift
//  testFTChat
//
//  Created by Honey Maheshwari on 9/1/16.
//  Copyright © 2016 Honey Maheshwari. All rights reserved.
//

import UIKit

class HMString: NSObject {
        
    class func getTextSizeFromString(_ text: String) -> CGSize {
        let att = NSString(string: text)
        let rect = att.boundingRect(with: CGSize(width: HMChatConstants.messageTextMaximumWidth, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: HMChatConstants.defaultMessageTextFont, NSParagraphStyleAttributeName: getHMDefaultMessageParagraphStyle()], context: nil)
        return CGSize(width: rect.width, height: rect.height)
    }
    
    class func getTextSizeFromString(_ text: String, withDefinedMaxWidth width: CGFloat) -> CGSize {
        let newText = stringByTrimingWhitespace(text)
        if newText == "" {
            return CGSize.zero
        }
        
        let att = NSString(string: newText)
        let rect = att.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: HMChatConstants.defaultMessageTextFont, NSParagraphStyleAttributeName: getHMDefaultMessageParagraphStyle()], context: nil)
        return CGSize(width: rect.width, height: rect.height)
    }
    
    class func getHMDefaultMessageParagraphStyle() -> NSMutableParagraphStyle{
        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = HMChatConstants.defaultLineSpacing
        return paragraphStyle;
    }
    
    class func stringByTrimingWhitespace(_ str: String) -> String {
        return str.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
}
