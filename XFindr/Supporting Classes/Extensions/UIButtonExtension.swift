//
//  UIButtonExtension.swift
//  testFTChat
//
//  Created by Honey Maheshwari on 9/16/16.
//  Copyright © 2016 Honey Maheshwari. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    
    func shrinkOnTap() {
        self.addTarget(self, action: #selector(shrink(_:)), for: .touchDown);
        self.addTarget(self, action: #selector(expand(_:)), for: .touchUpInside);
    }
    
    @objc fileprivate func shrink(_ sender: UIButton!) {
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8);
        })
    }
    
    @objc fileprivate func expand(_ sender: UIButton!) {
        UIView.animate(withDuration: 0.15, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1);
        })
    }
    
    var hmCurrentTitle: String {
        get {
            if let title = self.currentTitle {
                return title
            }
            return ""
        }
    }
    
}
