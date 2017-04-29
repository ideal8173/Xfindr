//
//  HMBubbleShape.swift
//  testFTChat
//
//  Created by Honey Maheshwari on 9/1/16.
//  Copyright © 2016 Honey Maheshwari. All rights reserved.
//

import UIKit

class HMShape: NSObject {
    
    class func hmGetBubbleShapePathWithSize(_ size:CGSize , isUserSelf : Bool) -> UIBezierPath {
        let path = UIBezierPath()
        
        let bubbleWidth = size.width - HMChatConstants.defaultAngleWidth
        let bubbleHeight = size.height
        let y : CGFloat = 0
        
        let m_PI_2 = Double.pi/2
        let m_PI = Double.pi

        if (isUserSelf){
            let x: CGFloat = 0
            path.move(to: CGPoint(x: x + bubbleWidth - HMChatConstants.defaultMessageRoundCorner, y: y))
            path.addLine(to: CGPoint(x: x + HMChatConstants.defaultMessageRoundCorner, y: y))
            path.addArc(withCenter: CGPoint(x: x + HMChatConstants.defaultMessageRoundCorner, y: y + HMChatConstants.defaultMessageRoundCorner), radius: HMChatConstants.defaultMessageRoundCorner, startAngle: CGFloat(-m_PI_2), endAngle: CGFloat(-m_PI), clockwise: false);
            path.addLine(to: CGPoint(x: x, y: y + bubbleHeight - HMChatConstants.defaultMessageRoundCorner))
            path.addArc(withCenter: CGPoint(x: x + HMChatConstants.defaultMessageRoundCorner, y: y + bubbleHeight - HMChatConstants.defaultMessageRoundCorner), radius: HMChatConstants.defaultMessageRoundCorner, startAngle: CGFloat(m_PI), endAngle: CGFloat(m_PI_2), clockwise: false);
            path.addLine(to: CGPoint(x: x + bubbleWidth - HMChatConstants.defaultMessageRoundCorner, y: y + bubbleHeight))
            path.addArc(withCenter: CGPoint(x: x + bubbleWidth - HMChatConstants.defaultMessageRoundCorner, y: y + bubbleHeight - HMChatConstants.defaultMessageRoundCorner), radius: HMChatConstants.defaultMessageRoundCorner, startAngle: CGFloat(m_PI_2), endAngle: 0, clockwise: false);
            path.addLine(to: CGPoint(x: x + bubbleWidth, y: y + HMChatConstants.defaultMessageRoundCorner * 2 + 8))
            path.addQuadCurve(to: CGPoint(x: x + bubbleWidth + HMChatConstants.defaultAngleWidth, y: y + HMChatConstants.defaultMessageRoundCorner - 2), controlPoint: CGPoint(x: x + bubbleWidth + 2.5, y: y + HMChatConstants.defaultMessageRoundCorner + 2))
            path.addQuadCurve(to: CGPoint(x: x + bubbleWidth, y: y + HMChatConstants.defaultMessageRoundCorner), controlPoint: CGPoint(x: x + bubbleWidth + 4, y: y + HMChatConstants.defaultMessageRoundCorner - 1))
            path.addArc(withCenter: CGPoint(x: x + bubbleWidth - HMChatConstants.defaultMessageRoundCorner, y: y + HMChatConstants.defaultMessageRoundCorner), radius: HMChatConstants.defaultMessageRoundCorner, startAngle: CGFloat(0), endAngle: CGFloat(-m_PI_2), clockwise: false);
            path.close()
        } else {
            let x = HMChatConstants.defaultAngleWidth
            path.move(to: CGPoint(x: x + HMChatConstants.defaultMessageRoundCorner, y: y))
            path.addLine(to: CGPoint(x: x + bubbleWidth - HMChatConstants.defaultMessageRoundCorner, y: y))
            path.addArc(withCenter: CGPoint(x: x + bubbleWidth - HMChatConstants.defaultMessageRoundCorner, y: y + HMChatConstants.defaultMessageRoundCorner), radius: HMChatConstants.defaultMessageRoundCorner, startAngle: CGFloat(-m_PI_2), endAngle: 0, clockwise: true);
            path.addLine(to: CGPoint(x: x + bubbleWidth, y: y + bubbleHeight - HMChatConstants.defaultMessageRoundCorner))
            path.addArc(withCenter: CGPoint(x: x + bubbleWidth - HMChatConstants.defaultMessageRoundCorner, y: y + bubbleHeight - HMChatConstants.defaultMessageRoundCorner), radius: HMChatConstants.defaultMessageRoundCorner, startAngle: 0, endAngle: CGFloat(m_PI_2), clockwise: true);
            path.addLine(to: CGPoint(x: x + HMChatConstants.defaultMessageRoundCorner, y: y + bubbleHeight))
            path.addArc(withCenter: CGPoint(x: x + HMChatConstants.defaultMessageRoundCorner, y: y + bubbleHeight - HMChatConstants.defaultMessageRoundCorner), radius: HMChatConstants.defaultMessageRoundCorner, startAngle: CGFloat(m_PI_2), endAngle: CGFloat(m_PI), clockwise: true);
            path.addLine(to: CGPoint(x: x, y: y + HMChatConstants.defaultMessageRoundCorner * 2 + 8))
            path.addQuadCurve(to: CGPoint(x: x - HMChatConstants.defaultAngleWidth, y: y + HMChatConstants.defaultMessageRoundCorner - 2), controlPoint: CGPoint(x: x - 2.5, y: y + HMChatConstants.defaultMessageRoundCorner + 2))
            path.addQuadCurve(to: CGPoint(x: x, y: y + HMChatConstants.defaultMessageRoundCorner), controlPoint: CGPoint(x: x - 4, y: y + HMChatConstants.defaultMessageRoundCorner - 1))
            path.addArc(withCenter: CGPoint(x: x + HMChatConstants.defaultMessageRoundCorner, y: y + HMChatConstants.defaultMessageRoundCorner), radius: HMChatConstants.defaultMessageRoundCorner, startAngle: CGFloat(m_PI), endAngle: CGFloat(-m_PI_2), clockwise: true);
            path.close()
        }
        return path;
    }
    
    class func hmGetBubbleShapePathWithSizeForDateLabel(_ size:CGSize) -> UIBezierPath {
        let path = UIBezierPath()
        
        let bubbleWidth = size.width
        let bubbleHeight = size.height
        let y: CGFloat = 0
        let x: CGFloat = 0
        let m_PI_2 = Double.pi/2
        let m_PI = Double.pi
        
        path.move(to: CGPoint(x: x + HMChatConstants.defaultMessageRoundCorner, y: y))
        path.addArc(withCenter: CGPoint(x: x + bubbleWidth - HMChatConstants.defaultMessageRoundCorner, y: y + HMChatConstants.defaultMessageRoundCorner), radius: HMChatConstants.defaultMessageRoundCorner, startAngle: CGFloat(-m_PI_2), endAngle: 0, clockwise: true);
        path.addLine(to: CGPoint(x: x + bubbleWidth, y: y + bubbleHeight - HMChatConstants.defaultMessageRoundCorner))
        path.addArc(withCenter: CGPoint(x: x + bubbleWidth - HMChatConstants.defaultMessageRoundCorner, y: y + bubbleHeight - HMChatConstants.defaultMessageRoundCorner), radius: HMChatConstants.defaultMessageRoundCorner, startAngle: 0, endAngle: CGFloat(m_PI_2), clockwise: true);
        path.addLine(to: CGPoint(x: x + HMChatConstants.defaultMessageRoundCorner, y: y + bubbleHeight))
        path.addArc(withCenter: CGPoint(x: x + HMChatConstants.defaultMessageRoundCorner, y: y + bubbleHeight - HMChatConstants.defaultMessageRoundCorner), radius: HMChatConstants.defaultMessageRoundCorner, startAngle: CGFloat(m_PI_2), endAngle: CGFloat(m_PI), clockwise: true);
        path.addLine(to: CGPoint(x: x, y: y + HMChatConstants.defaultMessageRoundCorner * 2 + 8))
        path.addArc(withCenter: CGPoint(x: x + HMChatConstants.defaultMessageRoundCorner, y: y + HMChatConstants.defaultMessageRoundCorner), radius: HMChatConstants.defaultMessageRoundCorner, startAngle: CGFloat(m_PI), endAngle: CGFloat(-m_PI_2), clockwise: true);
        path.close()
        return path;
    }
    
    class func hmDrawCrossImage(_ size: CGSize) -> UIImage {
        return hmDrawCrossImage(size, color: UIColor.white, lineWidth: 2.0)
    }
    
    class func hmDrawCrossImage(_ size: CGSize, color: UIColor) -> UIImage {
        return hmDrawCrossImage(size, color: color, lineWidth: 2.0)
    }
    
    class func hmDrawCrossImage(_ size: CGSize, color: UIColor, lineWidth: CGFloat) -> UIImage {
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        context?.setStrokeColor(color.cgColor)
        context?.setLineWidth(lineWidth)
        
        //CGContextStrokeRect(context, bounds)
        
        context?.beginPath()
        context?.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
        context?.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        context?.move(to: CGPoint(x: bounds.maxX, y: bounds.minY))
        context?.addLine(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        context?.strokePath()
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func hmDrawPauseImage(_ size: CGSize, width: CGFloat, fillColor: UIColor) -> UIImage {
        let shapeWidth = width - 5
        let rect = CGRect(origin: CGPoint.zero, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        context?.setFillColor(fillColor.cgColor)
        
        let point0 = CGPoint(x: rect.minX, y: rect.minY)
        let point1 = CGPoint(x: rect.minX, y: rect.maxY)
        let point2 = CGPoint(x: rect.minX + shapeWidth, y: rect.maxY)
        let point3 = CGPoint(x: rect.minX + shapeWidth, y: rect.minY)
        let point4 = CGPoint(x: rect.minX, y: rect.minY)
        let point5 = CGPoint(x: rect.minX + shapeWidth + 15.0, y: rect.maxY)
        let point6 = CGPoint(x: rect.minX + shapeWidth + 15.0, y: rect.minY)
        let point7 = CGPoint(x: rect.minX + shapeWidth + 15.0 + shapeWidth, y: rect.minY)
        let point8 = CGPoint(x: rect.minX + shapeWidth + 15.0 + shapeWidth, y: rect.maxY)
        
        context?.move(to: point0)
        context?.addLine(to: point1)
        context?.addLine(to: point2)
        context?.addLine(to: point3)
        context?.addLine(to: point4)
        context?.move(to: point5)
        context?.addLine(to: point6)
        context?.addLine(to: point7)
        context?.addLine(to: point8)
        context?.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func hmDrawPlayImage(_ size: CGSize, fillColor: UIColor) -> UIImage {
        //let rect = CGRect(origin: CGPoint.zero, size: size)
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: size.width, height: size.height + (size.height * 0.5)))
        let opaque = false
        let scale: CGFloat = 0
        //UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width, height: size.height + (size.height * 0.5)), opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        context?.setFillColor(fillColor.cgColor)
        
        let point1 = CGPoint(x: rect.minX, y: rect.minY)
        let point2 = CGPoint(x: rect.minX, y: rect.maxY)
        let point3 = CGPoint(x: rect.maxX, y: rect.midY)
        
        context?.move(to: point1)
        context?.addLine(to: point2)
        context?.addLine(to: point3)
        context?.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    class func hmDrawPlayImage(frame: CGRect, fillColor: UIColor) -> UIImage {
        let rect = frame
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(frame.size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        context?.beginPath()
        context?.setFillColor(fillColor.cgColor)
        
        let point1 = CGPoint(x: rect.minX, y: rect.minY)
        let point2 = CGPoint(x: rect.minX, y: rect.maxY)
        let point3 = CGPoint(x: rect.maxX, y: rect.midY)
        
        context?.move(to: point1)
        context?.addLine(to: point2)
        context?.addLine(to: point3)
        context?.fillPath()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
