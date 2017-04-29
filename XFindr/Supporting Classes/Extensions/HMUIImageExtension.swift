//
//  HMUIImageExtension.swift
//  TapVendor
//
//  Created by Honey Maheshwari on 2/4/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import Foundation

extension UIImage {
    
    func hmMaskWith(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let hmContext = UIGraphicsGetCurrentContext()!
        hmContext.translateBy(x: 0, y: size.height)
        hmContext.scaleBy(x: 1.0, y: -1.0)
        hmContext.setBlendMode(.normal)
        
        let hmRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        hmContext.clip(to: hmRect, mask: cgImage!)
        
        color.setFill()
        hmContext.fill(hmRect)
        
        let hmImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return hmImage
    }
}
