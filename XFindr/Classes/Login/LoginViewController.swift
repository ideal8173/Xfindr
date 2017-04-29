//
//  LoginViewController.swift
//  XFindr
//
//  Created by Rajat on 3/23/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate, PopUpViewDelegate {
    
    
    @IBOutlet var svView: UIScrollView!
    //@IBOutlet var imgLogo: UIImageView!
    
    // Text Field Outlet
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    
    // Buttons Outlet
    @IBOutlet var btnSignWithFacebook: UIButton!
    @IBOutlet var btnLogIn: UIButton!
    @IBOutlet var btnSignup: UIButton!
    @IBOutlet var btnForgotPassword: UIButton!
    //@IBOutlet var btnSignInLater: UIButton!
    
    //@IBOutlet var lblDontHaveAcc: UILabel!
    //@IBOutlet var lblSignUp: UILabel!
    
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    
    var firstTime: Bool = true
    
    // MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setDelegate()
        self.otherFunction()
        changeLanguage()
        svView.contentSize = CGSize(width: 0, height: btnSignWithFacebook.frame.origin.y + btnSignWithFacebook.frame.size.height + 50)
        
        tfEmail.text = XFindrUserDefaults.getEmailPassword().email
        /*
        if XFindrUserDefaults.isUserLogin {
            self.moveToMenu()
        }
        */
        
        /*
        if firstTime {
            self.imgLogo.removeFromSuperview()
            self.svView.alpha = 0.0
            
            self.view.addSubview(self.imgLogo)
            self.imgLogo.center = self.view.center
            //self.imgLogo.transform = CGAffineTransform.identity.scaledBy(x: 5.0, y: 5.0)
            self.imgLogo.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        }
 */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.animateView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    // MARK:- Functions..
    
    func changeLanguage() {
        //tf_FirstName.attributedPlaceholder = NSAttributedString(string:"First Name", attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
        tfEmail.attributedPlaceholder = NSAttributedString(string: MessageStringFile.enterEmailOrMobileNo(), attributes: [NSForegroundColorAttributeName: UIColor.white])
        tfPassword.attributedPlaceholder = NSAttributedString(string: MessageStringFile.password(), attributes: [NSForegroundColorAttributeName: UIColor.white])
        btnLogIn.setTitle(MessageStringFile.signIn(), for: UIControlState.normal)
        btnForgotPassword.setTitle(MessageStringFile.forgotPasswordWithQuestionMark(), for: UIControlState.normal)
        
        
        
        let signInWithFb = MessageStringFile.signInWithFb() + "  "
        let string_to_color = MessageStringFile.signInWithFb()
        
        let range = (signInWithFb as NSString).range(of: string_to_color)
        let attributedString = NSMutableAttributedString(string: signInWithFb)
        attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1), range: range)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: range)
        btnSignWithFacebook.setAttributedTitle(attributedString, for: UIControlState.normal)
        btnSignWithFacebook.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnSignWithFacebook.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        btnSignWithFacebook.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        
        
        let signUp = MessageStringFile.dontHaveAccount() + " " + MessageStringFile.signUp()
        let string_to_color2 = MessageStringFile.signUp()
        let range2 = (signUp as NSString).range(of: string_to_color2)
        let fullRange = (signUp as NSString).range(of: signUp)
        let attributedString2 = NSMutableAttributedString(string: signUp)
        attributedString2.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1), range: range2)
        attributedString2.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: fullRange)
        //lblSignUp.attributedText = attributedString2
        btnSignup.setAttributedTitle(attributedString2, for: UIControlState.normal)
        //lblDontHaveAcc.text = MessageStringFile.dontHaveAccount()
        
        
        /*
         let str = "Terms & Conditions and"
         let string_to_color = "Terms & Conditions"
         let range = (str as NSString).rangeOfString(string_to_color)
         let rangeAnd = (str as NSString).rangeOfString(" and")
         let attributedString = NSMutableAttributedString(string:str)
         attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor(red: 0.122, green: 0.627, blue: 0.847, alpha: 1.0) , range: range)
         attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor() , range: rangeAnd)
         attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(integer: 1), range: range)
         btnTermandConditions.setAttributedTitle(attributedString, forState: UIControlState.Normal)
         */
    }
    
    func setNavigation() {
        /*
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationItem.setHidesBackButton(true, animated: true)
        */
        /*
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.black]
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        */
        self.title = ""
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.view.backgroundColor = UIColor.clear
        self.navigationController!.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.navigationController!.navigationBar.barStyle = .default
    }
    
    func setDelegate() {
        tfEmail.delegate = self
        tfPassword.delegate = self
    }
    
    func otherFunction() {
        //btnSignWithFacebook.circleView(UIColor.white, borderWidth: 1.0)
        btnLogIn.circleView(UIColor.white, borderWidth: 1.0)
    }
    
    func animateView() {
        if firstTime {
            firstTime = false
            UIView.animate(withDuration: 0.7, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                //self.imgLogo.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.7, delay: 0.2, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    //self.imgLogo.frame.origin.y = self.svView.frame.origin.y + 64
                    self.svView.alpha = 1.0
                }, completion: { (finished) in
                    //self.imgLogo.frame.origin.y = 0.0
                    //self.imgLogo.center.x = self.svView.center.x
                    //self.svView.addSubview(self.imgLogo)
                    /*
                     UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: { () -> Void in
                     
                     }) { (finished) -> Void in
                     }
                     */
                })
            })
            
//            UIView.animate(withDuration: 0.7, delay: 0, options: .curveLinear, animations: { () -> Void in
//                self.imgLogo.transform = CGAffineTransform.identity
//            }) { (finished) -> Void in
            
//            }
        }
    }
    
    func checkValidation() -> NSMutableArray{
        let arrValid = NSMutableArray()
        
        if tfEmail.text?.characters.count == 0 {
            arrValid.add(MessageStringFile.vEmailOrMobile())
        } else {
            let type = self.checkMailAndPhone()
            if type == .mobileNumber {
                if ValidatorClasses.trimString(tempString: tfEmail.text!).characters.count < 8 || ValidatorClasses.trimString(tempString: tfEmail.text!).characters.count > 14 {
                    arrValid.add(MessageStringFile.vPhoneNotValid())
                }
            }else{
                if !ValidatorClasses.isValidEmail(testStr: tfEmail.text!){
                    arrValid.add(MessageStringFile.vEmailNotValid())
                }
            }
        }
        
        if tfPassword.text?.characters.count == 0 {
            arrValid.add(MessageStringFile.vPassword())
        } else if (tfPassword.text?.characters.count)! < 6 {
            arrValid.add(MessageStringFile.vPasswordLength())
        }
        return arrValid
    }
    
    func checkMailAndPhone() -> RegisterationType {
        let strPassword = self.tfEmail.text!
        
        var countSmall = 0
        var countCapital = 0
        var countNumber = 0
        var countSpecial = 0
        var countType = 0
        var type: RegisterationType!
        
        for chr in strPassword.characters {
            if (chr >= "a" && chr <= "z") {
                countSmall += 1
            }else if (chr >= "A" && chr <= "Z") {
                countCapital += 1
            }else if (chr >= "0" && chr <= "9") {
                countNumber += 1
            }else{
                countSpecial += 1
            }
        }
        if countSmall > 0 {
            countType += 1
        }
        if countCapital > 0 {
            countType += 1
        }
        if countNumber > 0 {
            countType += 1
        }
        if countSpecial > 0 {
            countType += 1
        }
        
        if countSmall == 0 && countCapital == 0 && countSpecial == 0 && countNumber > 0 {
            type = RegisterationType.mobileNumber
        }else{
            type = RegisterationType.email
        }
        
        return type
    }
    
    func checkForLogin() {
        let dict = AppVariables.getDictUserDetail()
        let email = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.email)
        let phoneNo = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.phoneNo)
        let is_email_verified = dict.hmGetInt(forKey: WebServiceConstants.isEmailVerified)
        let is_mobile_verified = dict.hmGetInt(forKey: WebServiceConstants.isMobileVerified)
        
        if email != "" && is_email_verified == 0 {
            self.moveToVerification(verificationType: .loginEmail)
            self.resetLoginButton()
        } else if phoneNo != "" && is_mobile_verified == 0 {
            self.moveToVerification(verificationType: .loginMobile)
            self.resetLoginButton()
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.btnLogIn.transform = CGAffineTransform.identity.scaledBy(x: 50.0, y: 50.0)
            }, completion: { (finished) in
                self.moveToMenu(animated: false)
                self.resetLoginButton()
            })
        }
    }
    
    func moveToMenu(animated: Bool) {
        XFindrUserDefaults.setEmailPasswordInUserDefaults(email: tfEmail.text!, password: tfPassword.text!, isRemember: false)
        XFindrUserDefaults.setUserLoginStatus(status: 1)
        PredefinedConstants.appDelegate.loginUserOnSocket()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func moveToVerification(verificationType: VerificationType) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
        vc.verificationType = verificationType
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func resetLoginButton() {
        self.btnLogIn.transform = CGAffineTransform.identity
        self.btnLogIn.frame.size.width = 200.0
        self.btnLogIn.center.x = self.svView.center.x
        self.btnLogIn.backgroundColor = UIColor.clear
        self.btnLogIn.circleView(UIColor.white, borderWidth: 1.0)
        self.btnLogIn.setTitle(MessageStringFile.signIn(), for: UIControlState.normal)
    }
    
    func showAlert(firstLblTitle: String, secondLblTitle: String){
        PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: firstLblTitle, secondLblTitle: secondLblTitle)
        PopUpView.sharedInstance.delegate = nil
    }
    
    //MARK:- PopUp Delegates
    
    func clickOnPopUpLeftButton() {
        
    }
    
    func clickOnPopUpRightButton() {
        
    }
    
    //MARK:- TextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.frame.origin.y > 220 {
            svView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y - 200), animated: true)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfEmail {
            let validCharacterSet = NSCharacterSet(charactersIn: ValidatorClasses.emailAcceptableCharacter).inverted
            let filter = string.components(separatedBy: validCharacterSet)
            if filter.count == 1 {
                let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
                return (newLength > 50) ? false : true
            } else {
                return false
            }
        } else if textField == tfPassword {
            let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
            return (newLength > 20) ? false : true
        }
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfEmail {
            tfPassword.becomeFirstResponder()
        } else if textField == tfPassword {
            tfPassword.resignFirstResponder()
            svView.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
        }
        return true
    }
    
    // MARK:- Buttons Actions...
    
    @IBAction func btnSignWithFacebook(_ sender: Any) {
        if HelperClass.isInternetAvailable {
            self.btnSignWithFacebook.isHidden = true
            self.svView.addSubview(self.aviIndicator)
            self.aviIndicator.center = self.btnSignWithFacebook.center
            self.aviIndicator.color = UIColor.white
            HMFacebookLogin.hmLoginUserWithFacebook(inViewController: self, hmCompletion: { (facebookData, status) in
                switch status {
                case .success:
                    self.callRegistrationWebservice(fbDetatil: facebookData)
                    break
                case .canceled:
                    self.btnSignWithFacebook.isHidden = false
                    self.aviIndicator.removeFromSuperview()
                    break
                default:
                    self.btnSignWithFacebook.isHidden = false
                    self.aviIndicator.removeFromSuperview()
                    break
                }
            })
        } else {
            self.showAlert(firstLblTitle: MessageStringFile.networkReachability(), secondLblTitle: "")
        }
    }
    
    @IBAction func btnForgotPassword(_ sender: Any) {
        self.view.endEditing(true)
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController")as! ForgotPasswordViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnLogIn(_ sender: Any) {
        self.view.endEditing(true)
        svView.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
        let arrValid = checkValidation()
        if arrValid.count == 0 {
            //performSegue(withIdentifier: "segueLoginTabBar", sender: nil)
            
            //self.moveToMenu()
            if HelperClass.isInternetAvailable {
                self.aviIndicator.color = self.view.backgroundColor
                self.btnLogIn.setTitle(nil, for: UIControlState.normal)
                UIApplication.shared.beginIgnoringInteractionEvents()
                UIView.animate(withDuration: 0.3, animations: {
                    self.btnLogIn.frame.size.width = self.btnLogIn.frame.size.height
                    self.btnLogIn.center.x = self.svView.center.x
                    self.btnLogIn.backgroundColor = UIColor.white
                    self.btnLogIn.circleView(UIColor.white, borderWidth: 1.0)
                }, completion: { (finished) in
                    self.svView.addSubview(self.aviIndicator)
                    self.aviIndicator.center = self.btnLogIn.center
                    self.callLoginWebservice()
                })
            } else {
                self.showAlert(firstLblTitle: MessageStringFile.networkReachability(), secondLblTitle: "")
            }
            
        } else {
            PopUpView.addValidationView(arrValid, strHeader: MessageStringFile.whoopsText(), strSubHeading: MessageStringFile.vInfoNeeded())
        }
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        self.view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func btnSignInLater(_ sender: Any) {
        self.moveToMenu(animated: true)
    }
    
    func callLoginWebservice() {
        let params = [WebServiceConstants.emailPhoneNo: tfEmail.text!, WebServiceConstants.password: tfPassword.text!, WebServiceConstants.deviceType: PredefinedConstants.userDeviceType, WebServiceConstants.deviceId: PredefinedConstants.userDeviceId, WebServiceConstants.appVersion: PredefinedConstants.deviceAppVersion, WebServiceConstants.language: MessageStringFile.appLanguage()]
        print("params >>>>> \(params)")
        print("WebServiceLinks.login >>>>> \(WebServiceLinks.login)")
        
        HMWebService.createRequestAndGetResponse(WebServiceLinks.login, methodType: HM_HTTPMethod.POST, andHeaderDict: [WebServiceConstants.language: MessageStringFile.appLanguage()], andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
            
            UIApplication.shared.endIgnoringInteractionEvents()
            self.aviIndicator.removeFromSuperview()
            
            var success: Int = 10
            
            print("error >>>>>> \(String(describing: error))")
            print("dictResponse >>>>>> \(String(describing: dictResponse))")
            if error == nil {
                let JSON: NSDictionary = dictResponse! as NSDictionary
                var msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                if msg == "" {
                    msg = MessageStringFile.serverError()
                }
                success = JSON.hmGetInt(forKey: WebServiceConstants.success)
                if success == 1 {
                    //let dictUserInfo = JSON.hmGetNSDictionary(forKey: WebServiceConstants.userInfo)
                    let dictUserInfo = JSON.hmGetNSDictionary(forKey: WebServiceConstants.result)
                    AppVariables.setDictUserDetail(dictUserInfo)
                } else {
                    self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                }
            } else {
                self.showAlert(firstLblTitle: MessageStringFile.serverError(), secondLblTitle: "")
            }
            
            if success != 1 {
                self.resetLoginButton()
            } else {
                self.checkForLogin()
            }
        })
    }
    
    func callRegistrationWebservice(fbDetatil: HMFacebookData) {
        if HelperClass.isInternetAvailable {
            let params = [WebServiceConstants.email: fbDetatil.email, WebServiceConstants.phoneNo: "", WebServiceConstants.password: "", WebServiceConstants.deviceType: PredefinedConstants.userDeviceType, WebServiceConstants.deviceId: PredefinedConstants.userDeviceId, WebServiceConstants.appVersion: PredefinedConstants.deviceAppVersion, WebServiceConstants.socialId: fbDetatil.id, WebServiceConstants.language: MessageStringFile.appLanguage(), WebServiceConstants.name: fbDetatil.fullName, WebServiceConstants.countryCode: ""]

            print("params >>>> \(params)")
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            HMWebService.createRequestAndGetResponse(WebServiceLinks.registration, methodType: HM_HTTPMethod.POST, andHeaderDict: [WebServiceConstants.language: MessageStringFile.appLanguage()], andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                
                UIApplication.shared.endIgnoringInteractionEvents()
                self.btnSignWithFacebook.isHidden = false
                self.aviIndicator.removeFromSuperview()
                
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
                        self.moveToMenu(animated: true)
                    } else {
                        self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                    }
                } else {
                    self.showAlert(firstLblTitle: MessageStringFile.serverError(), secondLblTitle: "")
                }
                
            })
        } else {
            self.btnSignWithFacebook.isHidden = false
            self.aviIndicator.removeFromSuperview()
            self.showAlert(firstLblTitle: MessageStringFile.networkReachability(), secondLblTitle: "")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
}
