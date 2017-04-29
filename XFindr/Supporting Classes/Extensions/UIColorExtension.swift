//
//  UIColorExtension.swift
//  testFTChat
//
//  Created by Honey Maheshwari on 9/1/16.
//  Copyright © 2016 Honey Maheshwari. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    convenience init(hm_hexString: String) {
        let hexString: String = hm_hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hm_hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color:UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:1)
    }
    
    func hm_ColortoHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        
        return String(format:"#%06x", rgb)
    }
    
    convenience init(hm_hexStringWithAlpha: String) {
        let r, g, b, a: CGFloat
        
        if hm_hexStringWithAlpha.hasPrefix("#") {
            let start = hm_hexStringWithAlpha.characters.index(hm_hexStringWithAlpha.startIndex, offsetBy: 1)
            let hexColor = hm_hexStringWithAlpha.substring(from: start)
            
            if hexColor.characters.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        self.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        return
    }
}
