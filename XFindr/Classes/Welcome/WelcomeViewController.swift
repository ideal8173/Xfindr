//
//  WelcomeViewController.swift
//  XFindr
//
//  Created by Rajat on 3/28/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet var viewMain: UIView!
    @IBOutlet var svTutorial: UIScrollView!
    @IBOutlet var pageCounter: UIPageControl!
    @IBOutlet var lblWelcomeToXfindr: UILabel!
    @IBOutlet var btnSignIn: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var imgMobile: UIImageView!
    @IBOutlet var imgBg: UIImageView!
    @IBOutlet var lblTextBg: UILabel!
    @IBOutlet var btnContinueAsVisitor: UIButton!
    @IBOutlet var lblMembersLogin: UILabel!
    @IBOutlet var lblNewToXfindr: UILabel!
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    
    @IBAction func btnContinueAsVisitor(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.svTutorial.delegate = self
        callBaseUrl()
        changeLanguage()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupScrollView()
        //updatePageControl()
        /*
        let image = UIImage.outlinedEllipse(size: CGSize(width: 7.0, height: 7.0), color: .darkGray)
        self.pageCounter.pageIndicatorTintColor = UIColor.init(patternImage: image!)
        self.pageCounter.currentPageIndicatorTintColor = .darkGray
        */
        btnSignIn.circleView(UIColor.white, borderWidth: 1.0)
        btnSignUp.circleView(UIColor.white, borderWidth: 1.0)
        //let color = UIColor(hm_hexString: "#77C7FE")
        //ObjectiveCHelper.gradientView(self.viewGradian, withArrayColor: [color.withAlphaComponent(0.1), color.withAlphaComponent(0.6), color.withAlphaComponent(1.0), color.withAlphaComponent(0.6), color.withAlphaComponent(0.1)])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.slide)
    }
    
    func changeLanguage() {
        btnSignIn.setTitle(MessageStringFile.signIn(), for: UIControlState.normal)
        btnSignUp.setTitle(MessageStringFile.signUp(), for: UIControlState.normal)
        lblMembersLogin.text = MessageStringFile.membersLogin()
        lblNewToXfindr.text = MessageStringFile.newToXfindr()
        
        let continueAsVisitor = MessageStringFile.contineAsVisitor()
        let range = (continueAsVisitor as NSString).range(of: continueAsVisitor)
        let attributedString = NSMutableAttributedString(string: continueAsVisitor)
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1), range: range)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: PredefinedConstants.darkBlueColor, range: range)
        btnContinueAsVisitor.setAttributedTitle(attributedString, for: UIControlState.normal)
        
        
        
        /*
        btnLogIn.setTitle(MessageStringFile.signIn(), for: UIControlState.normal)
        btnForgotPassword.setTitle(MessageStringFile.forgotPassword(), for: UIControlState.normal)
        btnSignWithFacebook.setTitle(MessageStringFile.signInWithFb(), for: UIControlState.normal)
        lblDontHaveAcc.text = MessageStringFile.dontHaveAccount()
        lblSignUp.text = MessageStringFile.signUp()
        btnSignInLater.setTitle(MessageStringFile.signInLater(), for: UIControlState.normal)
 */
    }
    
    func setupScrollView() {
        
        if self.svTutorial.subviews.count > 0 {
            for vw in self.svTutorial.subviews {
                vw.removeFromSuperview()
            }
        }
        
        let arrImages = [["text": MessageStringFile.tutorialTxt1(), "image": "tuto_1_\(language).png"], ["text": MessageStringFile.tutorialTxt2(), "image": "tuto_2_\(language).png"], ["text": MessageStringFile.tutorialTxt3(), "image": "tuto_3_\(language).png"]]
        
        
        self.svTutorial.frame.size.height = self.btnSignIn.frame.origin.y - 30.0
        self.imgBg.frame.size.height = self.svTutorial.frame.size.height
        self.imgMobile.frame.size.height = self.svTutorial.frame.size.height - 100.0 - self.imgMobile.frame.origin.y
        self.lblTextBg.frame.origin.y = self.svTutorial.frame.size.height - 100.0
        self.pageCounter.frame.origin.y = self.lblTextBg.frame.origin.y - 5.0
        self.lblWelcomeToXfindr.frame.origin.y = self.pageCounter.frame.origin.y + self.pageCounter.frame.size.height - 10.0
        
        let lblHeight: CGFloat = 70.0
        //let imagePadding: CGFloat = 15.0
        let imageY = self.imgMobile.frame.origin.y + 70.0
        let imageHeight = self.imgMobile.frame.size.height - 70.0
        let imageWidth = self.svTutorial.frame.size.width
        
        //let imgBG =
        
        for i in 0 ..< arrImages.count {
            let dict = arrImages[i] as NSDictionary
//            let lbl = UILabel(frame: CGRect(x: CGFloat((CGFloat(i) * self.svTutorial.frame.size.width) + CGFloat(5.0)), y: (self.svTutorial.frame.size.height - lblHeight), width: self.svTutorial.frame.size.width - 10.0, height: lblHeight))
            let lbl = UILabel(frame: CGRect(x: CGFloat((CGFloat(i) * self.svTutorial.frame.size.width) - 0.0), y: (self.svTutorial.frame.size.height - lblHeight), width: self.svTutorial.frame.size.width + 0.0, height: lblHeight))
            lbl.numberOfLines = 0
            lbl.textAlignment = .center
            lbl.textColor = PredefinedConstants.backgroundColor
            lbl.font = PredefinedConstants.appFont(size: 15.0)
            lbl.text = dict.hmGetString(forKey: "text")
            
//            let imgView = UIImageView(frame: CGRect(x: CGFloat((CGFloat(i) * self.svTutorial.frame.size.width) + self.imgMobile.frame.origin.x), y: imageY, width: imageWidth, height: imageHeight))
            let imgView = UIImageView(frame: CGRect(x: CGFloat(CGFloat(i) * self.svTutorial.frame.size.width), y: imageY, width: imageWidth, height: imageHeight))
            imgView.image = UIImage(named: dict.hmGetString(forKey: "image"))
            
            self.svTutorial.addSubview(lbl)
            self.svTutorial.addSubview(imgView)
        }
        self.svTutorial.contentSize = CGSize(width: CGFloat(CGFloat(arrImages.count) * self.svTutorial.frame.size.width), height: 0.0)
        self.pageCounter.numberOfPages = arrImages.count
    }
    
    func setNavigation() {
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController!.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.navigationController!.navigationBar.barStyle = .default
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollWidth = self.svTutorial.frame.size.width
        let alpha = 1.0 - (scrollView.contentOffset.x / scrollWidth)
        self.lblWelcomeToXfindr.alpha = alpha
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let xyz = scrollView.contentOffset.x / scrollView.frame.size.width
        let pageIndex: Int = Int(xyz)
        self.pageCounter.currentPage = pageIndex
        //updatePageControl()
    }
    
    func updatePageControl() {
        for i in 0 ..< pageCounter.numberOfPages {
            let dot = pageCounter.subviews[i]
            if i == pageCounter.currentPage {
                dot.backgroundColor = UIColor.white
                dot.layer.cornerRadius = dot.frame.size.height / 2
            } else {
                dot.backgroundColor = UIColor.clear
                dot.layer.cornerRadius = dot.frame.size.height / 2;
                dot.layer.borderColor = UIColor.white.cgColor
                dot.layer.borderWidth = 1
            }
        }
    }

    func callBaseUrl() {
        self.viewMain.alpha = 0.0
        self.view.addSubview(self.aviIndicator)
        self.aviIndicator.center = self.view.center
        //UIApplication.shared.isNetworkActivityIndicatorVisible = true
        HMWebService.createRequestAndGetResponse(WebServiceLinks.staticBaseUrl, methodType: HM_HTTPMethod.GET, andHeaderDict: [:], andParameterDict: [:]) { (dictResponse, error, theReply) in
            print("dictResponse >>>>>> \(String(describing: dictResponse))")
            self.baseUrlData(dictResponse: dictResponse as NSDictionary?)
        }
    }
    
    func baseUrlData(dictResponse: NSDictionary?) {
        
        if let dictData = dictResponse {
            if dictData.hmGetInt(forKey: WebServiceConstants.success) == 1 {
                let result = dictData.hmGetNSDictionary(forKey: WebServiceConstants.result)
                XFindrUserDefaults.setBaseUrlData(dict: result)
            }
        }
        
        var login = false
        if XFindrUserDefaults.isUserLogin {
            let emailPassword = XFindrUserDefaults.getEmailPassword()
            if emailPassword.email.hm_Length > 0 && emailPassword.password.hm_Length > 0 {
                login = true
            }
        }
        
        if login {
            let emailPassword = XFindrUserDefaults.getEmailPassword()
            callLoginWebservice(email: emailPassword.email, password: emailPassword.password)
        } else if HMFacebookLogin.hmCanLoginWithFacebook() && XFindrUserDefaults.isUserLogin {
            HMFacebookLogin.hmLoginUserWithFacebook(inViewController: self, hmCompletion: { (facebookData, status) in
                switch status {
                case .success:
                    self.callRegistrationWebservice(fbDetatil: facebookData)
                    break
                default:
                    self.setViewToDefault()
                    break
                }
            })
        } else {
            self.setViewToDefault()
        }
    }

    func setViewToDefault() {
        self.viewMain.frame.origin.y = ScreenSize.height + 5
        self.aviIndicator.removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations: {
            self.viewMain.alpha = 1.0
            self.viewMain.frame.origin.y = 0.0
        })
        //UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func callLoginWebservice(email: String, password: String) {
        let params = [WebServiceConstants.emailPhoneNo: email, WebServiceConstants.password: password, WebServiceConstants.deviceType: PredefinedConstants.userDeviceType, WebServiceConstants.deviceId: PredefinedConstants.userDeviceId, WebServiceConstants.appVersion: PredefinedConstants.deviceAppVersion, WebServiceConstants.language: MessageStringFile.appLanguage()]
        print("params >>>>> \(params)")
        print("WebServiceLinks.login >>>>> \(WebServiceLinks.login)")
        
        HMWebService.createRequestAndGetResponse(WebServiceLinks.login, methodType: HM_HTTPMethod.POST, andHeaderDict: [WebServiceConstants.language: MessageStringFile.appLanguage()], andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
            self.setViewToDefault()
            print("error >>>>>> \(String(describing: error))")
            print("dictResponse >>>>>> \(String(describing: dictResponse))")
            if error == nil {
                let JSON: NSDictionary = dictResponse! as NSDictionary
                var msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                if msg == "" {
                    msg = MessageStringFile.serverError()
                }
                let success = JSON.hmGetInt(forKey: WebServiceConstants.success)
                if success == 1 {
                    let dictUserInfo = JSON.hmGetNSDictionary(forKey: WebServiceConstants.result)
                    AppVariables.setDictUserDetail(dictUserInfo)
                    self.checkForLogin()
                } else {
                    self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                }
            } else {
                self.showAlert(firstLblTitle: MessageStringFile.serverError(), secondLblTitle: "")
            }
        })
    }
    
    func callRegistrationWebservice(fbDetatil: HMFacebookData) {
        if HelperClass.isInternetAvailable {
            let params = [WebServiceConstants.email: fbDetatil.email, WebServiceConstants.phoneNo: "", WebServiceConstants.password: "", WebServiceConstants.deviceType: PredefinedConstants.userDeviceType, WebServiceConstants.deviceId: PredefinedConstants.userDeviceId, WebServiceConstants.appVersion: PredefinedConstants.deviceAppVersion, WebServiceConstants.socialId: fbDetatil.id, WebServiceConstants.language: MessageStringFile.appLanguage(), WebServiceConstants.name: fbDetatil.fullName, WebServiceConstants.countryCode: ""]
            
            print("params >>>> \(params)")
            
            HMWebService.createRequestAndGetResponse(WebServiceLinks.registration, methodType: HM_HTTPMethod.POST, andHeaderDict: [WebServiceConstants.language: MessageStringFile.appLanguage()], andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                
                self.setViewToDefault()
                
                print("theReply >>>>>> \(String(describing: theReply))")
                print("error >>>>>> \(String(describing: error))")
                print("dictResponse >>>>>> \(String(describing: dictResponse))")
                
                if error == nil {
                    let JSON: NSDictionary = dictResponse! as NSDictionary
                    var msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                    if msg == "" {
                        msg = MessageStringFile.serverError()
                    }
                    if JSON.hmGetInt(forKey: WebServiceConstants.success) == 1 {
                        let dictUserInfo = JSON.hmGetNSDictionary(forKey: WebServiceConstants.result)
                        AppVariables.setDictUserDetail(dictUserInfo)
                        self.moveToMenu()
                    } else {
                        self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                    }
                } else {
                    self.showAlert(firstLblTitle: MessageStringFile.serverError(), secondLblTitle: "")
                }
                
            })
        } else {
            self.setViewToDefault()
            self.showAlert(firstLblTitle: MessageStringFile.networkReachability(), secondLblTitle: "")
        }
    }
    
    func checkForLogin() {
        let dict = AppVariables.getDictUserDetail()
        let email = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.email)
        let phoneNo = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.phoneNo)
        let is_email_verified = dict.hmGetInt(forKey: WebServiceConstants.isEmailVerified)
        let is_mobile_verified = dict.hmGetInt(forKey: WebServiceConstants.isMobileVerified)
        
        if email != "" && is_email_verified == 0 {
            self.moveToVerification(verificationType: .loginEmail)
        } else if phoneNo != "" && is_mobile_verified == 0 {
            self.moveToVerification(verificationType: .loginMobile)
        } else {
            self.moveToMenu()
            /*
            UIView.animate(withDuration: 0.5, animations: {
            }, completion: { (finished) in
                self.moveToMenu()
            })
 */
        }
    }
    
    func moveToMenu() {
        XFindrUserDefaults.setUserLoginStatus(status: 1)
        PredefinedConstants.appDelegate.loginUserOnSocket()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func moveToVerification(verificationType: VerificationType) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
        vc.verificationType = verificationType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(firstLblTitle: String, secondLblTitle: String){
        PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: firstLblTitle, secondLblTitle: secondLblTitle)
        PopUpView.sharedInstance.delegate = nil
    }
    
    @IBAction func btnSignIn(_ sender: Any) {
        performSegue(withIdentifier: "segueLogin", sender: nil)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        performSegue(withIdentifier: "segueRegistration", sender: nil)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    
}

extension UIImage {
    
    /// Creates a circular outline image.
    class func outlinedEllipse(size: CGSize, color: UIColor, lineWidth: CGFloat = 1.0) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        context.setStrokeColor(color.cgColor)
        context.setLineWidth(lineWidth)
        // Inset the rect to account for the fact that strokes are
        // centred on the bounds of the shape.
        let rect = CGRect(origin: .zero, size: size).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        context.addEllipse(in: rect)
        context.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

/*
class CustomAlertViewController: UIAlertController {
    
    internal var cancelText: String?
    
    
    private var font: UIFont? = UIFont(name: "MuseoSansCyrl-500", size: 12)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.tintColor = UIColor.black
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.findLabel(scanView: self.view) //if you need ios 9 only, this can be made in viewWillAppear
    }
    
    func findLabel(scanView: UIView!) {
        if (scanView.subviews.count > 0) {
            for subview in scanView.subviews {
                print("subview >>>> \(subview)")
                if let label: UILabel = subview as? UILabel {
                    print("label >>>> \(label)")
                    
                    //if label.text?.lowercased() != MessageStringFile.cancel().lowercased() {
                        label.textColor = UIColor.blue
                    //}
                    /*
                    if (self.cancelText != nil && label.text == self.cancelText!) {
                        
                        HMUtilities.hmMainQueue {
                            label.textColor = UIColor.red //for ios 8.x
                            label.tintColor = UIColor.red //for ios 9.x
                        }

                    }
                    
                    if (self.font != nil) {
                        label.font = self.font
                    }
                    */
                }
                self.findLabel(scanView: subview)
            }
        }
    }
    
}
*/
