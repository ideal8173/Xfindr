//
//  PopUpView.swift
//
//
//  Created by Honey Maheshwari on 3/10/16.
//  Copyright © 2016 Honey Maheshwari. All rights reserved.
//

import UIKit

@objc public protocol PopUpViewDelegate {
    func clickOnPopUpLeftButton()
    func clickOnPopUpRightButton()
}

open class PopUpView: UIView {
    open var delegate: PopUpViewDelegate?
    
    class var sharedInstance: PopUpView {
        struct Singleton {
            static let instance = PopUpView(frame: CGRect(x: 0,y: 0,width: Config().width,height: Config().height))
        }
        return Singleton.instance
    }
    
    public struct Config {
        public var width : CGFloat = UIScreen.main.bounds.width
        public var height : CGFloat = UIScreen.main.bounds.height
        public init() {}
        
        public func heightForView(_ text:String, width:CGFloat, fontSize: UIFont) -> CGFloat{
            let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.text = text
            label.font = fontSize
            label.sizeToFit()
            return label.frame.height
        }
    }
    
    fileprivate func update() {
        self.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5)
        self.frame = CGRect(x: 0, y: 0, width: Config().width, height: Config().height)
    }
    
    open class func orientationChanged(_ notification: NSNotification) {
        
        let popUpView = PopUpView.sharedInstance
        popUpView.update()
        
        if let svBack = popUpView.viewWithTag(1000000) {
            svBack.frame = CGRect(x: 0, y: 0, width: Config().width, height: Config().height)
            if let viewCenter = svBack.viewWithTag(1000001) {
                viewCenter.center = svBack.center
            }
        }
        
        if let svBack: UIScrollView = popUpView.viewWithTag(2000000) as? UIScrollView {
            svBack.frame = CGRect(x: 0, y: 0, width: Config().width, height: Config().height)
            if let viewCenter = svBack.viewWithTag(2000001) {
                
                var header: CGFloat = 0.0
                
                if let lblHeader: UILabel = viewCenter.viewWithTag(2000002) as? UILabel {
                    header = lblHeader.frame.size.height
                }
                var msg1 = header
                
                if let lblMsg1: UILabel = viewCenter.viewWithTag(2000003) as? UILabel {
                    let height = Config().heightForView(lblMsg1.text!, width: viewCenter.frame.size.width - 30, fontSize: lblMsg1.font!)
                    lblMsg1.frame.origin.y = msg1 + 10.0
                    lblMsg1.frame.size.height = height
                    msg1 = lblMsg1.frame.origin.y + lblMsg1.frame.size.height
                }
                
                var msg2 = msg1
                
                if let lblMsg2: UILabel = viewCenter.viewWithTag(2000004) as? UILabel {
                    let height = Config().heightForView(lblMsg2.text!, width: viewCenter.frame.size.width - 30, fontSize: lblMsg2.font!)
                    lblMsg2.frame.origin.y = msg2 + 5.0
                    lblMsg2.frame.size.height = height
                    msg2 = lblMsg2.frame.origin.y + lblMsg2.frame.size.height
                }
                
                var btn = msg2
                
                if let btnRight: UIButton = viewCenter.viewWithTag(2000005) as? UIButton {
                    btnRight.frame.origin.y = msg2 + 15.0
                    btn = btnRight.frame.origin.y + btnRight.frame.size.height
                }
                
                if let btnLeft: UIButton = viewCenter.viewWithTag(2000006) as? UIButton {
                    btnLeft.frame.origin.y = msg2 + 15.0
                    btn = btnLeft.frame.origin.y + btnLeft.frame.size.height
                }
                
                
                if let lblLine: UILabel = viewCenter.viewWithTag(2000007) as? UILabel {
                    lblLine.frame.origin.y = msg2 + 14.0
                    lblLine.frame.size.height = 1
                }
                
                viewCenter.frame.size.height = btn
                viewCenter.center = svBack.center
                svBack.contentSize.height = viewCenter.frame.origin.y + viewCenter.frame.size.height + 20.0
            }
        }
        
    }
    
    //MARK: for alert view
    open class func addPopUpAlertView(_ strHeader: String, leftBtnTitle: String, rightBtnTitle: String, firstLblTitle: String, secondLblTitle: String) {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PopUpView.orientationChanged(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let popUpView = PopUpView.sharedInstance
        let currentWindow : UIWindow = UIApplication.shared.keyWindow!
        popUpView.removeAllViews(false)
        popUpView.update()
        
        /// add scroll view
        let svBack = UIScrollView()
        svBack.frame = CGRect(x: 0, y: 0, width: Config().width, height: Config().height)
        popUpView.addSubview(svBack)
        svBack.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight, .flexibleTopMargin]
        
        /// add content view
        
        let viewCenter = UIView(frame: CGRect(x: 20, y: 0, width: Config().width * 0.85, height: 190))
        
        viewCenter.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        viewCenter.setCornerRadiousAndBorder(UIColor.clear, borderWidth: 0.0, cornerRadius: 5.0)
        viewCenter.clipsToBounds = true
        viewCenter.backgroundColor = PredefinedConstants.alertBackgroundColor
        
        // for header label
        var lblHeader = UILabel()
        if strHeader != "" {
            lblHeader = UILabel(frame: CGRect(x: 0, y: 0.0, width: viewCenter.frame.size.width, height: 45))
            lblHeader.text = strHeader
            lblHeader.numberOfLines = 4
            lblHeader.font = UIFont.systemFont(ofSize: 17.0)
            lblHeader.textColor = PredefinedConstants.darkBlack
            lblHeader.textAlignment = .center
            lblHeader.backgroundColor = UIColor.white
            lblHeader.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
            lblHeader.tag = 2000002
            viewCenter.addSubview(lblHeader)
        }
        
        // first Message label
        let font = UIFont.systemFont(ofSize: 14.0)
        let lblMsg1 = UILabel(frame: CGRect(x: 15, y: lblHeader.frame.size.height + 15, width: viewCenter.frame.size.width - 30, height: 20))
        lblMsg1.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        lblMsg1.numberOfLines = 0
        lblMsg1.text = firstLblTitle
        lblMsg1.font = UIFont.systemFont(ofSize: 14.0)
        lblMsg1.textColor = UIColor.darkGray
        lblMsg1.backgroundColor = UIColor.clear
        lblMsg1.textAlignment = .center
        lblMsg1.font = font
        
        lblMsg1.tag = 2000003
        
        let firstLblHeight = Config().heightForView(firstLblTitle, width: viewCenter.frame.size.width - 30, fontSize: font)
        lblMsg1.frame.size.height = firstLblHeight
        
        viewCenter.addSubview(lblMsg1)
        
        // second Message label
        let lblMsg2 = UILabel(frame: CGRect(x: 15, y: lblMsg1.frame.origin.y + lblMsg1.frame.size.height + 5, width: viewCenter.frame.size.width - 30, height: 20))
        lblMsg2.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        lblMsg2.numberOfLines = 0
        lblMsg2.text = secondLblTitle
        lblMsg2.textColor = UIColor.darkGray
        lblMsg2.font = UIFont.systemFont(ofSize: 14.0)
        lblMsg2.backgroundColor = UIColor.clear
        lblMsg2.textAlignment = .center
        lblMsg2.font = font
        lblMsg2.tag = 2000004
        //lblMsg2.sizeToFit()
        
        let secondLblHeight = Config().heightForView(secondLblTitle, width: viewCenter.frame.size.width - 30, fontSize: font)
        lblMsg2.frame.size.height = secondLblHeight
        viewCenter.addSubview(lblMsg2)
        
        // left button and right button
        var btnLeft = UIButton()
        var btnRight = UIButton()
        
        btnLeft = UIButton(frame: CGRect(x: 0, y: lblMsg2.frame.origin.y + lblMsg2.frame.size.height + 15, width: viewCenter.frame.size.width / 2, height: 40))
        btnLeft.backgroundColor = UIColor.clear
        
        btnRight = UIButton(frame: CGRect(x: viewCenter.frame.size.width / 2, y: lblMsg2.frame.origin.y + lblMsg2.frame.size.height + 15, width: viewCenter.frame.size.width / 2 + 1, height: 40))
        btnRight.backgroundColor = UIColor.clear
        
        btnLeft.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        btnRight.titleLabel?.font = UIFont.systemFont(ofSize: 16.0)
        btnLeft.setTitle(leftBtnTitle, for: UIControlState())
        btnLeft.setTitleColor(PredefinedConstants.darkGrayTextColor, for: UIControlState.normal)
        btnRight.setTitle(rightBtnTitle, for: UIControlState())
        btnRight.setTitleColor(PredefinedConstants.darkGrayTextColor, for: UIControlState.normal)
        
        if rightBtnTitle == "" {
            btnLeft = UIButton(frame: CGRect(x: 0, y: lblMsg2.frame.origin.y + lblMsg2.frame.size.height + 15, width: viewCenter.frame.size.width, height: 40))
            btnLeft.backgroundColor = UIColor.white
            btnRight.isHidden = true
            /*
            let labelLine = UILabel(frame: CGRect(x: 0.0, y: lblMsg2.frame.origin.y + lblMsg2.frame.size.height + 14, width: viewCenter.frame.size.width, height: 1))
            labelLine.backgroundColor = PredefinedConstants.lightBlack
            labelLine.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
            labelLine.tag = 2000007
            
            viewCenter.addSubview(labelLine)
            */
            viewCenter.backgroundColor = UIColor.white
            btnLeft.setTitle(leftBtnTitle, for: UIControlState())
            btnLeft.setTitleColor(PredefinedConstants.darkGrayTextColor, for: UIControlState.normal)
            lblHeader.backgroundColor = PredefinedConstants.alertBackgroundColor
        }
        
        btnLeft.addTarget(self, action: #selector(PopUpView.leftButtonPress), for: UIControlEvents.touchUpInside)
        btnRight.addTarget(self, action: #selector(PopUpView.rightButtonPress), for: UIControlEvents.touchUpInside)
        btnLeft.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        btnRight.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        
        btnRight.tag = 2000005
        btnLeft.tag = 2000006
        
        let labelLine = UILabel(frame: CGRect(x: 0.0, y: lblMsg2.frame.origin.y + lblMsg2.frame.size.height + 14, width: viewCenter.frame.size.width, height: 1))
        labelLine.backgroundColor = PredefinedConstants.lightBlack
        labelLine.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        labelLine.tag = 2000007
        viewCenter.addSubview(labelLine)
        
        viewCenter.addSubview(btnRight)
        viewCenter.addSubview(btnLeft)
        
        viewCenter.frame = CGRect(x: viewCenter.frame.origin.x, y: 0.0, width: viewCenter.frame.size.width, height: btnLeft.frame.size.height + btnLeft.frame.origin.y)
        
        //viewCenter.transform = CGAffineTransform.identity.scaledBy(x: 5.0, y: 5.0)
        
        viewCenter.alpha = 1.0
        
        svBack.addSubview(viewCenter)
        svBack.center = popUpView.center
        viewCenter.center = svBack.center
        svBack.contentSize = CGSize(width: 0, height: viewCenter.frame.origin.y + viewCenter.frame.size.height)
        
        viewCenter.frame.origin.y = -viewCenter.frame.size.height - 50.0
        
        svBack.tag = 2000000
        viewCenter.tag = 2000001
        svBack.contentSize.height = viewCenter.frame.origin.y + viewCenter.frame.size.height + 20.0
        
        currentWindow.addSubview(popUpView)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 2.0, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            viewCenter.center = svBack.center
        }) { (finished) in
            
        }
        /*
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            viewCenter.alpha = 1.0
            viewCenter.center = svBack.center
            //viewCenter.transform = CGAffineTransform.identity
        })
        */
    }
    
    
    //MARK:- add validation popup
    open class func addValidationView(_ arr: NSMutableArray, strHeader: String, strSubHeading: String) {
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PopUpView.orientationChanged(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let currentWindow : UIWindow = UIApplication.shared.keyWindow!
        let popUpView = PopUpView.sharedInstance
        popUpView.removeAllViews(false)
        popUpView.update()
        
        
        /// add scroll view
        let svBack = UIScrollView()
        svBack.frame = CGRect(x: 0, y: 0, width: Config().width, height: Config().height)
        popUpView.addSubview(svBack)
        svBack.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight, .flexibleTopMargin]
        
        //let viewCenter = UIView(frame: CGRect(x: 20, y: 0, width: popUpView.frame.size.width - 40, height: 50))
        let viewCenter = UIView(frame: CGRect(x: 20, y: 0, width: popUpView.frame.size.width - 40, height: 50))
        viewCenter.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        viewCenter.setCornerRadiousAndBorder(UIColor.clear, borderWidth: 0.0, cornerRadius: 5.0)
        viewCenter.clipsToBounds = true
        
        let scrlView = UIScrollView(frame: CGRect(x: 20, y: 0, width: popUpView.frame.size.width - 40, height: 50))
        scrlView.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        
        var nextLblY: CGFloat = 10.0
        let font = UIFont.systemFont(ofSize: 15.0)
        
        if strSubHeading != "" {
            let lblSubHeader = UILabel(frame: CGRect(x: 15.0, y: 15.0, width: viewCenter.frame.size.width - 30, height: 40))
            lblSubHeader.text = strSubHeading
            lblSubHeader.numberOfLines = 4
            
            lblSubHeader.font = font
            lblSubHeader.textColor = PredefinedConstants.darkBlack
            lblSubHeader.textAlignment = .left
            lblSubHeader.backgroundColor = UIColor.clear
            let height = Config().heightForView(strSubHeading, width: scrlView.frame.size.width - 30, fontSize: font)
            lblSubHeader.frame.size.height = height
            
            nextLblY = height + 5 + lblSubHeader.frame.origin.y
            lblSubHeader.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
            scrlView.addSubview(lblSubHeader)
        }
        
        for i in 0 ..< arr.count {
            var str = arr[i] as! String
            str = "- " + str
            let lbl = UILabel(frame: CGRect(x: 15, y: nextLblY, width: scrlView.frame.size.width - 30, height: 20))
            lbl.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
            lbl.numberOfLines = 0
            lbl.text = str
            lbl.font = UIFont.systemFont(ofSize: 14.0)
            lbl.textColor = PredefinedConstants.darkBlack
            lbl.backgroundColor = UIColor.clear
            let height = Config().heightForView(str, width: scrlView.frame.size.width - 30, fontSize: lbl.font)
            lbl.frame = CGRect(x: 15, y: nextLblY, width: lbl.frame.size.width, height: height)
            nextLblY = nextLblY + height + 5
            scrlView.addSubview(lbl)
        }
        
        scrlView.backgroundColor = UIColor.white
        let totalViewHeight = nextLblY + 5
        
        if strHeader != "" {
            let lblHeader = UILabel(frame: CGRect(x: 10.0, y: 0.0, width: viewCenter.frame.size.width - 20, height: 40))
            lblHeader.text = strHeader
            lblHeader.numberOfLines = 4
            lblHeader.font = UIFont.systemFont(ofSize: 18.0)
            lblHeader.textColor = PredefinedConstants.darkBlack
            
            lblHeader.textAlignment = .center
            lblHeader.backgroundColor = UIColor.clear
            let lblHeaderLine = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: viewCenter.frame.size.width, height: 40))
            lblHeaderLine.text = ""
            lblHeaderLine.backgroundColor = UIColor.lightGray
            
            lblHeaderLine.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
            lblHeader.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
            viewCenter.addSubview(lblHeaderLine)
            viewCenter.addSubview(lblHeader)
        } else {
            
        }
        
        if Config().height - 150 < totalViewHeight {
            if strHeader != "" {
                scrlView.frame = CGRect(x: 0.0, y: 40.0, width: viewCenter.frame.size.width, height: totalViewHeight - 200)
            } else {
                scrlView.frame = CGRect(x: 0.0, y: 0.0, width: viewCenter.frame.size.width, height: totalViewHeight - 150)
            }
            scrlView.contentSize = CGSize(width: 0.0, height: totalViewHeight)
        } else {
            if strHeader != "" {
                scrlView.frame = CGRect(x: 0.0, y: 40.0, width: viewCenter.frame.size.width, height: totalViewHeight)
            } else {
                scrlView.frame = CGRect(x: 0.0, y: 0.0, width: viewCenter.frame.size.width, height: totalViewHeight)
            }
            scrlView.contentSize = CGSize(width: 0.0, height: totalViewHeight - 20)
        }
        
        if strHeader != "" {
            viewCenter.frame = CGRect(x: viewCenter.frame.origin.x, y: 0.0, width: viewCenter.frame.size.width, height: scrlView.frame.size.height + 90)
        } else {
            viewCenter.frame = CGRect(x: viewCenter.frame.origin.x, y: 0.0, width: viewCenter.frame.size.width, height: scrlView.frame.size.height + 40)
        }
        
        viewCenter.backgroundColor = UIColor.white
        viewCenter.addSubview(scrlView)
        viewCenter.center = svBack.center
        viewCenter.setCornerRadiousAndBorder(UIColor.lightGray, borderWidth: 0.0, cornerRadius: 5.0)
        
        let labelLine = UILabel(frame: CGRect(x: 0.0, y: scrlView.frame.origin.y + scrlView.frame.size.height + 9, width: viewCenter.frame.size.width, height: 1))
        labelLine.backgroundColor = PredefinedConstants.lightBlack
        labelLine.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        viewCenter.addSubview(labelLine)
        
        let btnOk = UIButton(frame: CGRect(x: 0.0, y: scrlView.frame.origin.y + scrlView.frame.size.height + 10, width: viewCenter.frame.size.width, height: 40))
        btnOk.setTitle("OK", for: UIControlState())
        // btnOk.backgroundColor = PredefinedConstants.darkBlack
        btnOk.backgroundColor = UIColor.white
        btnOk.setTitleColor(PredefinedConstants.darkGrayTextColor, for: UIControlState.normal)
        btnOk.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        btnOk.addTarget(self, action: #selector(PopUpView.okButtonPress), for: UIControlEvents.touchUpInside)
        btnOk.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        
        viewCenter.addSubview(btnOk)
        
        //viewCenter.transform = CGAffineTransform.identity.scaledBy(x: 5.0, y: 5.0)
        viewCenter.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        viewCenter.alpha = 0.0
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            viewCenter.alpha = 1.0
            viewCenter.transform = CGAffineTransform.identity
        })
        
        svBack.addSubview(viewCenter)
        
        if viewCenter.frame.size.height > Config().height{
            svBack.contentSize = CGSize(width: 0, height: viewCenter.frame.origin.y + viewCenter.frame.size.height)
        }else{
            svBack.contentSize = CGSize(width: 0, height: Config().height)
        }
        svBack.contentSize = CGSize(width: 0, height: viewCenter.frame.origin.y + viewCenter.frame.size.height)
        
        svBack.tag = 1000000
        viewCenter.tag = 1000001
        currentWindow.addSubview(popUpView)
        /*
         // set constraints for all view
         let leadC = NSLayoutConstraint(item: popUpView, attribute: .leading, relatedBy: .equal, toItem: currentWindow, attribute: .leading, multiplier: 1, constant: 0)
         let trialC = NSLayoutConstraint(item: popUpView, attribute: .trailing, relatedBy: .equal, toItem: currentWindow, attribute: .trailing, multiplier: 1, constant: 0)
         let topC = NSLayoutConstraint(item: popUpView, attribute: .top, relatedBy: .equal, toItem: currentWindow, attribute: .top, multiplier: 1, constant: 0)
         let bottomC = NSLayoutConstraint(item: popUpView, attribute: .bottom, relatedBy: .equal, toItem: currentWindow
         , attribute: .bottom, multiplier: 1, constant: 0)
         let centreX = NSLayoutConstraint(item: popUpView, attribute: .centerX, relatedBy: .equal, toItem: currentWindow, attribute: .centerX, multiplier: 1, constant: 0)
         let centreY = NSLayoutConstraint(item: popUpView, attribute: .centerY, relatedBy: .equal, toItem: currentWindow, attribute: .centerY, multiplier: 1, constant: 0)
         
         NSLayoutConstraint.activate([leadC, trialC, topC, bottomC, centreX, centreY])
         popUpView.translatesAutoresizingMaskIntoConstraints = false
         */
    }
    
    
    //MARK:- network lost view
    open class func addNetworkLostView(){
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PopUpView.orientationChanged(_:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        let currentWindow : UIWindow = UIApplication.shared.keyWindow!
        let popUpView = PopUpView.sharedInstance
        popUpView.removeAllViews(false)
        popUpView.update()
        
        /// add scroll view
        let svBack = UIScrollView()
        svBack.frame = CGRect(x: 0, y: 0, width: Config().width, height: Config().height)
        popUpView.addSubview(svBack)
        svBack.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth, .flexibleHeight, .flexibleTopMargin]
        
        // add view back
        let viewBack = UIView(frame: CGRect(x: 15, y: 0, width: popUpView.frame.size.width - 30, height: 50))
        viewBack.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin]
        viewBack.center = svBack.center
        
        // add view centre
        let viewCenter = UIView(frame: CGRect(x: 15, y: 20, width: viewBack.frame.size.width - 30, height: 50))
        viewCenter.setCornerRadiousAndBorder(UIColor.red, borderWidth: 1.0, cornerRadius: 5.0)
        viewCenter.clipsToBounds = true
        
        // add label header netwrk lost
        let lblHeader = UILabel(frame: CGRect(x: 10.0, y: 10.0, width: viewCenter.frame.size.width - 20, height: 30))
        lblHeader.text = "CONNECTION LOST"
        lblHeader.numberOfLines = 1
        lblHeader.font = UIFont.systemFont(ofSize: 16.0)
        lblHeader.textColor = PredefinedConstants.darkBlack
        lblHeader.textAlignment = .center
        lblHeader.backgroundColor = UIColor.clear
        
        // add image no network
        let imgNetwork = UIImageView(frame: CGRect(x: 20.0, y: lblHeader.frame.origin.y + lblHeader.frame.size.height + 5, width: viewCenter.frame.size.width - 40, height: 120))
        imgNetwork.image = UIImage(named: "imgNoInternet")
        imgNetwork.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        
        // add label no network message
        let font = UIFont.systemFont(ofSize: 14.0)
        let lblSubHeader = UILabel(frame: CGRect(x: 20, y: imgNetwork.frame.origin.y + imgNetwork.frame.size.height + 10, width: viewCenter.frame.size.width - 40, height: 30))
        lblSubHeader.text = MessageStringFile.networkReachability()
        lblSubHeader.numberOfLines = 0
        lblSubHeader.font = font
        lblSubHeader.textColor = PredefinedConstants.lightBlack
        lblSubHeader.textAlignment = .center
        lblSubHeader.backgroundColor = UIColor.clear
        lblSubHeader.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        let height = Config().heightForView(MessageStringFile.networkReachability(), width: viewCenter.frame.size.width - 40, fontSize: font)
        lblSubHeader.frame.size.height = height
        
        // add button try again
        let btnTryAgain = UIButton(frame: CGRect(x: 50, y: lblSubHeader.frame.origin.y + lblSubHeader.frame.size.height + 10, width: viewCenter.frame.size.width - 100, height: 40))
        btnTryAgain.setTitle("Try Again", for: UIControlState())
        btnTryAgain.backgroundColor = PredefinedConstants.darkBlack
        btnTryAgain.setTitleColor(PredefinedConstants.darkGrayTextColor, for: UIControlState.normal)
        btnTryAgain.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        btnTryAgain.addTarget(self, action: #selector(PopUpView.btnRetryPress), for: UIControlEvents.touchUpInside)
        btnTryAgain.autoresizingMask = [.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleWidth]
        
        // add sub view
        viewCenter.addSubview(lblHeader)
        viewCenter.addSubview(lblSubHeader)
        viewCenter.addSubview(imgNetwork)
        viewCenter.addSubview(btnTryAgain)
        
        // view centre frame
        viewCenter.frame = CGRect(x: 15, y: 20, width: viewBack.frame.size.width - 30, height: btnTryAgain.frame.origin.y + btnTryAgain.frame.size.height + 10)
        viewCenter.backgroundColor = UIColor.white
        viewBack.addSubview(viewCenter)
        
        // add button close
        let btnClose = UIButton(frame: CGRect(x: viewCenter.frame.origin.x + viewCenter.frame.size.width - 20, y: 10, width: 30, height: 30))
        btnClose.setTitle("X", for: UIControlState())
        btnClose.backgroundColor = UIColor.red
        btnClose.setTitleColor(PredefinedConstants.darkGrayTextColor, for: UIControlState.normal)
        btnClose.titleLabel?.font = UIFont.systemFont(ofSize: 17.0)
        btnClose.addTarget(self, action: #selector(PopUpView.okButtonPress), for: UIControlEvents.touchUpInside)
        btnClose.circleView(UIColor.red, borderWidth: 1.0)
        viewBack.addSubview(btnClose)

         // view back frame
        viewBack.frame = CGRect(x: 15, y: 20, width: popUpView.frame.size.width - 30, height: viewCenter.frame.size.height + 20)
        viewBack.center = svBack.center
        svBack.addSubview(viewBack)
        
        viewBack.transform = CGAffineTransform.identity.scaledBy(x: 5.0, y: 5.0)
        viewBack.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            viewBack.alpha = 1.0
            viewBack.transform = CGAffineTransform.identity
        })
        
        if viewBack.frame.size.height > Config().height{
            svBack.contentSize = CGSize(width: 0, height: viewBack.frame.origin.y + viewBack.frame.size.height)
        }else{
            svBack.contentSize = CGSize(width: 0, height: Config().height)
        }
        
        svBack.tag = 1000000
        viewBack.tag = 1000001
        currentWindow.addSubview(popUpView)
    }
    
    
    open class func showLoaderView() {
        let currentWindow : UIWindow = UIApplication.shared.keyWindow!
        let popUpView = PopUpView.sharedInstance
        popUpView.removeAllViews(false)
        popUpView.update()
        let viewCenter = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
        viewCenter.setCornerRadiousAndBorder(UIColor.clear, borderWidth: 0.0, cornerRadius: 5.0)
        
        let img = UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        // let path = NSBundle.mainBundle().pathForResource("loading", ofType: "gif")
        //let url: NSURL = NSURL(fileURLWithPath: path!)
        // img.image = UIImage.animatedImageWithAnimatedGIFURL(url)
        
        img.center = viewCenter.center
        viewCenter.addSubview(img)
        
        viewCenter.backgroundColor = UIColor.white
        viewCenter.center = popUpView.center
        
        viewCenter.transform = CGAffineTransform.identity.scaledBy(x: 5.0, y: 5.0)
        viewCenter.alpha = 0.0
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            viewCenter.alpha = 1.0
            viewCenter.transform = CGAffineTransform.identity
        })
        
        popUpView.addSubview(viewCenter)
        currentWindow.addSubview(popUpView)
    }
    
    open class func hideLoaderView() {
        let popUpView = PopUpView.sharedInstance
        let subView = popUpView.subviews
        if subView.count > 0 {
            for views in subView {
                views.removeFromSuperview()
            }
        }
        popUpView.removeFromSuperview()
        popUpView.alpha = 1.0
    }
    
    // button actions for popup view
    
    open class func okButtonPress() {  // only remove
        let popUpView = PopUpView.sharedInstance
        popUpView.removeAllViews(false)
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            popUpView.delegate?.clickOnPopUpLeftButton()
        })
        
    }
    
    open class func leftButtonPress() {
        let popUpView = PopUpView.sharedInstance
        popUpView.removeAllViews(false)
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            popUpView.delegate?.clickOnPopUpLeftButton()
        })
    }
    
    open class func rightButtonPress() {
        let popUpView = PopUpView.sharedInstance
        popUpView.removeAllViews(false)
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
            popUpView.delegate?.clickOnPopUpRightButton()
        })
    }
    
    open class func btnRetryPress() {
        let popUpView = PopUpView.sharedInstance
        popUpView.removeAllViews(true)
        let dispatchTime: DispatchTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime, execute: {
         //   popUpView.delegate?.clickOnPopUpRetryAgainButton()
        })
    }
    
    
    
    // romve all view from popup view
    fileprivate func removeAllViews(_ withAnimation: Bool) {
        let popUpView = PopUpView.sharedInstance
        let subView = popUpView.subviews

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        if withAnimation {
            
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                popUpView.alpha = 0.0
                subView[0].transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
            }, completion: { (completion) -> Void in
                if subView.count > 0 {
                    for views in subView {
                        views.removeFromSuperview()
                    }
                }
                popUpView.removeFromSuperview()
                popUpView.alpha = 1.0
            })
        } else {
            if subView.count > 0 {
                for views in subView {
                    views.removeFromSuperview()
                }
            }
            popUpView.removeFromSuperview()
            popUpView.alpha = 1.0
        }
    }
    
    
} /// end of class



