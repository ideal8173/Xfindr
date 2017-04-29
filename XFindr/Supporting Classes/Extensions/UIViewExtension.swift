//
//  UIViewExtension.swift
//  testFTChat
//
//  Created by Honey Maheshwari on 10/20/16.
//  Copyright © 2016 Honey Maheshwari. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func zoomInWithScale() {
        self.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.05, y: 1.05)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.15, animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
                    }, completion: { (finish) in
                        UIView.animate(withDuration: 0.15, animations: {
                            self.transform = CGAffineTransform.identity
                        })
                })
        })
    }
    
    func zoomInWithScale(_ hmCompletion: @escaping HMVariable.hmCompletionHandler) {
        self.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.05, y: 1.05)
            }, completion: { (finish) in
                UIView.animate(withDuration: 0.15, animations: {
                    self.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
                    }, completion: { (finish) in
                        UIView.animate(withDuration: 0.15, animations: {
                            self.transform = CGAffineTransform.identity
                            }, completion: { (finish) in
                                hmCompletion()
                        })
                })
        })
    }
    
    func setViewAlpha(withDuration duration: TimeInterval, fromAlpha: CGFloat, toAlpha: CGFloat, hmCompletion: @escaping HMVariable.hmCompletionHandler) {
        
        self.alpha = fromAlpha
        UIView.animate(withDuration: duration, animations: { 
            self.alpha = toAlpha
            }) { (finish) in
                hmCompletion()
        }
    }
    
    
    func setViewAlpha(withDuration duration: TimeInterval, toAlpha: CGFloat, hmCompletion: @escaping HMVariable.hmCompletionHandler) {
        
        UIView.animate(withDuration: duration, animations: {
            self.alpha = toAlpha
        }) { (finish) in
            hmCompletion()
        }
    }
    
    func setCornerRadiousAndBorder(_ color: UIColor, borderWidth: CGFloat) {
        self.layer.cornerRadius = 5
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
    }
    
    func setCornerRadiousAndBorder(_ color: UIColor, borderWidth: CGFloat, cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
    }
    
    func circleView(_ color: UIColor, borderWidth: CGFloat) {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
    }
    
    func setShadowOnView(_ shadowColor: UIColor) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 5
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func setShadowOnViewWithRadious(_ shadowColor: UIColor, shadowRadius: CGFloat) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    func dropViewWithBounce() {
        self.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            var frame: CGRect = self.frame
            frame.origin.y = self.superview!.center.y - 100
            self.frame = frame
            self.alpha = 1.0
        }, completion: { (completed) -> Void in
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                self.center = self.superview!.center
            })
        })
    }
    
    func pullViewToTop() {
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alpha = 0.0
            var frame: CGRect = self.frame
            frame.origin.y = -500
            self.frame = frame
        }, completion: { (completed) -> Void in
        })
    }
    
    func pullViewFromBottom() {
        self.alpha = 0.0
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alpha = 1.0
            self.frame.origin.y = self.superview!.frame.size.height - self.frame.size.height
        })
    }
    
    func hideViewToBottom() {
        self.alpha = 1.0
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alpha = 0.0
            self.frame.origin.y = self.superview!.frame.size.height + 10
        })
    }
    
}


extension UIView {
    
    /**
     Simply zooming in of a view: set view scale to 0 and zoom to Identity on 'duration' time interval.
     
     - parameter duration: animation duration
     */
    func zoomIn(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Simply zooming out of a view: set view scale to Identity and zoom out to 0 on 'duration' time interval.
     
     - parameter duration: animation duration
     */
    func zoomOut(duration: TimeInterval = 0.2) {
        self.transform = CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveLinear], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        }) { (animationCompleted: Bool) -> Void in
        }
    }
    
    /**
     Zoom in any view with specified offset magnification.
     
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomInWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseIn, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform.identity
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
    
    /**
     Zoom out any view with specified offset magnification.
     
     - parameter duration:     animation duration.
     - parameter easingOffset: easing offset.
     */
    func zoomOutWithEasing(duration: TimeInterval = 0.2, easingOffset: CGFloat = 0.2) {
        let easeScale = 1.0 + easingOffset
        let easingDuration = TimeInterval(easingOffset) * duration / TimeInterval(easeScale)
        let scalingDuration = duration - easingDuration
        UIView.animate(withDuration: easingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: easeScale, y: easeScale)
        }, completion: { (completed: Bool) -> Void in
            UIView.animate(withDuration: scalingDuration, delay: 0.0, options: .curveEaseOut, animations: { () -> Void in
                self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
            }, completion: { (completed: Bool) -> Void in
            })
        })
    }
    
    func shake(count : Float? = nil,for duration : TimeInterval? = nil,withTranslation translation : Float? = nil) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = count ?? 2
        animation.duration = (duration ?? 0.5)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation ?? -5
        layer.add(animation, forKey: "shake")
    }
    
}
