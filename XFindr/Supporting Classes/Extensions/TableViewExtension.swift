//
//  TableViewExtension.swift
//  ExtensionDemo
//
//  Created by Honey Maheshwari on 1/14/16.
//  Copyright © 2016 Honey Maheshwari. All rights reserved.
//

import UIKit

extension UITableView {
    
    func displayBackgroundText(text: String, fontStyle: String, fontSize: CGFloat) {
        let lblHoney = UILabel();
        
        if let headerView = self.tableHeaderView {
            lblHoney.frame = CGRect(x: 0, y: headerView.bounds.size.height, width: self.bounds.size.width, height: self.bounds.size.height - headerView.bounds.size.height)
        } else {
            lblHoney.frame = CGRect(x: 10, y: 0, width: self.bounds.size.width - 20, height: self.bounds.size.height);
        }
        lblHoney.text = text;
        lblHoney.textColor = UIColor.black;
        lblHoney.numberOfLines = 0;
        lblHoney.textAlignment = .center;
        lblHoney.font = UIFont(name: fontStyle, size:fontSize);
        //        lblHoney.sizeToFit();
        
        let backgroundViewHoney = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
        backgroundViewHoney.addSubview(lblHoney);
        self.backgroundView = backgroundViewHoney;
    }
    
    func displayBackgroundText(text: String, fontStyle: String) {
        let lblHoney = UILabel();
        
        if let headerView = self.tableHeaderView {
            lblHoney.frame = CGRect(x: 0, y: headerView.bounds.size.height, width: self.bounds.size.width, height: self.bounds.size.height - headerView.bounds.size.height)
        } else {
            lblHoney.frame = CGRect(x: 10, y: 0, width: self.bounds.size.width - 20, height: self.bounds.size.height);
        }
        lblHoney.text = text;
        lblHoney.textColor = UIColor.black;
        lblHoney.numberOfLines = 0;
        lblHoney.textAlignment = .center;
        lblHoney.font = UIFont(name: fontStyle, size:18);
        //        lblHoney.sizeToFit();
        
        let backgroundViewHoney = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
        backgroundViewHoney.addSubview(lblHoney);
        self.backgroundView = backgroundViewHoney;
    }
    
    func displayBackgroundText(text: String) {
        let lblHoney = UILabel();
        
        if let headerView = self.tableHeaderView {
            lblHoney.frame = CGRect(x: 0, y: headerView.bounds.size.height, width: self.bounds.size.width, height: self.bounds.size.height - headerView.bounds.size.height)
        } else {
            lblHoney.frame = CGRect(x: 10, y: 0, width: self.bounds.size.width - 20, height: self.bounds.size.height);
        }
        lblHoney.text = text;
        lblHoney.textColor = UIColor.black;
        lblHoney.numberOfLines = 0;
        lblHoney.textAlignment = .center;
        lblHoney.font = UIFont(name: "Helvetica", size:18);
        //lblHoney.sizeToFit();
        
        let backgroundViewHoney = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
        backgroundViewHoney.addSubview(lblHoney);
        self.backgroundView = backgroundViewHoney;
    }
}


extension UICollectionView {
    
    func displayBackgroundText(text: String, fontStyle: String, fontSize: CGFloat) {
        let lblHoney = UILabel();
        lblHoney.frame = CGRect(x: 10, y: 0, width: self.bounds.size.width - 20, height: self.bounds.size.height);
        lblHoney.text = text;
        lblHoney.textColor = UIColor.black;
        lblHoney.numberOfLines = 0;
        lblHoney.textAlignment = .center;
        lblHoney.font = UIFont(name: fontStyle, size:fontSize);
        
        let backgroundViewHoney = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
        backgroundViewHoney.addSubview(lblHoney);
        self.backgroundView = backgroundViewHoney;
    }
    
    func displayBackgroundText(text: String, fontStyle: String) {
        let lblHoney = UILabel();
        lblHoney.frame = CGRect(x: 10, y: 0, width: self.bounds.size.width - 20, height: self.bounds.size.height);
        lblHoney.text = text;
        lblHoney.textColor = UIColor.black;
        lblHoney.numberOfLines = 0;
        lblHoney.textAlignment = .center;
        lblHoney.font = UIFont(name: fontStyle, size:18);
        
        let backgroundViewHoney = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
        backgroundViewHoney.addSubview(lblHoney);
        self.backgroundView = backgroundViewHoney;
    }
    
    func displayBackgroundText(text: String) {
        let lblHoney = UILabel();
        lblHoney.frame = CGRect(x: 10, y: 0, width: self.bounds.size.width - 20, height: self.bounds.size.height);
        lblHoney.text = text;
        lblHoney.textColor = UIColor.black;
        lblHoney.numberOfLines = 0;
        lblHoney.textAlignment = .center;
        lblHoney.font = UIFont(name: "Helvetica", size:18);
        
        let backgroundViewHoney = UIView(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height));
        backgroundViewHoney.addSubview(lblHoney);
        self.backgroundView = backgroundViewHoney;
    }
}

extension UITableViewCell {
    func shake123(duration: CFTimeInterval = 0.3, pathLength: CGFloat = 15) {
        let position: CGPoint = self.center
        
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: position.x, y: position.y))
        path.addLine(to: CGPoint(x: position.x-pathLength, y: position.y))
        path.addLine(to: CGPoint(x: position.x+pathLength, y: position.y))
        path.addLine(to: CGPoint(x: position.x-pathLength, y: position.y))
        path.addLine(to: CGPoint(x: position.x+pathLength, y: position.y))
        path.addLine(to: CGPoint(x: position.x, y: position.y))
        
        let positionAnimation = CAKeyframeAnimation(keyPath: "position")
        
        positionAnimation.path = path.cgPath
        positionAnimation.duration = duration
        positionAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        
        CATransaction.begin()
        self.layer.add(positionAnimation, forKey: nil)
        CATransaction.commit()
    }
}
