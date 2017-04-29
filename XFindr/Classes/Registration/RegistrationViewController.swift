//
//  RegistrationViewController.swift
//  XFindr
//
//  Created by Anurag on 3/23/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController , UITextFieldDelegate, PopUpViewDelegate, CountryPickerDelegate {
    
    
    @IBOutlet var svView: UIScrollView!
    @IBOutlet var lblSignUpWith: UILabel!
    @IBOutlet var lblEmailWarningMsg: UILabel!
    
    // Buttons Outlet
    @IBOutlet var btnSignWithFacebook: UIButton!
    @IBOutlet var btnSignUp: UIButton!
    @IBOutlet var btnTermsCondition: UIButton!
    /*
    @IBOutlet var btnAccept: UIButton!
    @IBOutlet var imgCheckUnchek: UIImageView!
    */
    // Text Fields Outlet
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var tfConfirmPassword: UITextField!
    @IBOutlet var tfCC: UITextField!
    @IBOutlet var tfMobileNo: UITextField!
    @IBOutlet var viewMobile: UIView!
    @IBOutlet var viewEmail: UIView!
    
    @IBOutlet var btnEmailAddress: UIButton!
    @IBOutlet var btnMobileNo: UIButton!
    @IBOutlet var imgCountryCodeFlag: UIImageView!
    
    @IBOutlet var viewCountryPicker: UIView!
    @IBOutlet var countryPicker: CountryPicker!
    @IBOutlet var imgCallIcon: UIImageView!
    
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    // Variables
    var isChecked = false
    var registrationType: RegisterationType = .email
    var selectedCountry: Country?
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setDelegate()
        self.otherFunction()
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        countryPicker.countryPickerDelegate = self
        countryPicker.showPhoneNumbers = true
        countryPicker.setCountry(code!)
        
        let index = countryPicker.selectedRow(inComponent: 0)
        let country = countryPicker.countries[index]
        self.selectedCountry = country
        if let selectedCountry = self.selectedCountry {
            tfCC.text = selectedCountry.phoneCode
            imgCountryCodeFlag.image = selectedCountry.flag
        }
        imgCallIcon.image = UIImage(named: "phone_icon")?.hmMaskWith(color: UIColor.white)
        changeLanguage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        /*
        UIView.animate(withDuration: 0.4, delay: 0, options: .curveLinear, animations: { () -> Void in
            self.btnSignUp.transform = self.btnSignUp.transform.rotated(by: CGFloat(M_PI ))
            self.btnSignUp.transform = self.btnSignUp.transform.rotated(by: CGFloat(M_PI))
        }) { (finished) -> Void in
        }
 */
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.title = ""
    }
    
    // MARK:- Functions..
    
    func changeLanguage() {
        
        tfEmail.attributedPlaceholder = NSAttributedString(string: MessageStringFile.enterEmail(), attributes: [NSForegroundColorAttributeName: UIColor.white])
        tfPassword.attributedPlaceholder = NSAttributedString(string: MessageStringFile.password(), attributes: [NSForegroundColorAttributeName: UIColor.white])
        tfConfirmPassword.attributedPlaceholder = NSAttributedString(string: MessageStringFile.confirmPassword(), attributes: [NSForegroundColorAttributeName: UIColor.white])
        tfCC.attributedPlaceholder = NSAttributedString(string: MessageStringFile.countryCode(), attributes: [NSForegroundColorAttributeName: UIColor.white])
        tfMobileNo.attributedPlaceholder = NSAttributedString(string: MessageStringFile.enterMobileNo(), attributes: [NSForegroundColorAttributeName: UIColor.white])
        
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
        
        lblSignUpWith.text = MessageStringFile.signUpWith()
        lblEmailWarningMsg.text = MessageStringFile.visibleToOthers()
        
        btnSignUp.setTitle(MessageStringFile.signUp(), for: UIControlState.normal)
        //btnTermsCondition
        
        btnEmailAddress.setTitle(" \(MessageStringFile.emailAddress())", for: UIControlState.normal)
        btnMobileNo.setTitle(" \(MessageStringFile.mobileNumber())", for: UIControlState.normal)
        
        let byClickingSignUp = MessageStringFile.byClickingSignUp()
        let string_to_underline = MessageStringFile.termsAndConditions()
        let range1 = (byClickingSignUp as NSString).range(of: string_to_underline)
        let attributedString1 = NSMutableAttributedString(string: byClickingSignUp)
        attributedString1.addAttribute(NSUnderlineStyleAttributeName, value: NSNumber(value: 1), range: range1)
        let fullRange = (byClickingSignUp as NSString).range(of: byClickingSignUp)
        attributedString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: fullRange)
        btnTermsCondition.setAttributedTitle(attributedString1, for: UIControlState.normal)
    }
    
    func setNavigation() {
        self.title = ""
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func setDelegate() {
        tfEmail.delegate = self
        tfPassword.delegate = self
        tfConfirmPassword.delegate = self
        tfCC.delegate = self
        tfMobileNo.delegate = self
    }
    
    func resignKeyboard() {
        tfEmail.resignFirstResponder()
        tfPassword.resignFirstResponder()
        tfConfirmPassword.resignFirstResponder()
        tfMobileNo.resignFirstResponder()
    }
    
    func otherFunction() {
        btnSignUp.circleView(UIColor.white, borderWidth: 1.0)
        svView.contentSize = CGSize(width: 0.0, height: btnSignWithFacebook.frame.size.height + btnSignWithFacebook.frame.origin.y + 50.0)
        HMUtilities.hmDefaultMainQueue {
            self.viewEmail.frame.origin.x = 0.0
            self.viewEmail.frame.size.width = self.view.frame.size.width
            self.viewMobile.frame.origin.x = self.view.frame.size.width
            self.viewMobile.frame.size.width = self.view.frame.size.width
            self.btnEmailAddress.backgroundColor = UIColor.white
            self.btnMobileNo.backgroundColor = UIColor.clear
            self.btnEmailAddress.circleView(UIColor.white, borderWidth: 1.0)
            self.btnMobileNo.circleView(UIColor.white, borderWidth: 1.0)
            self.btnEmailAddress.setTitleColor(PredefinedConstants.backgroundColor, for: UIControlState.normal)
            self.btnMobileNo.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.btnEmailAddress.setImage(UIImage(named: "email")?.hmMaskWith(color: PredefinedConstants.backgroundColor), for: UIControlState.normal)
            self.btnMobileNo.setImage(UIImage(named: "phone_icon")?.hmMaskWith(color: UIColor.white), for: UIControlState.normal)
        }
        registrationType = .email
    }
    
    func switchEmailOrMobile() {
        if registrationType == .email {
            if tfMobileNo.isFirstResponder {
                tfMobileNo.resignFirstResponder()
                tfEmail.becomeFirstResponder()
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.viewEmail.frame.origin.x = 0.0
                self.viewMobile.frame.origin.x = self.view.frame.size.width
                self.btnEmailAddress.backgroundColor = UIColor.white
                self.btnMobileNo.backgroundColor = UIColor.clear
                self.btnEmailAddress.setTitleColor(PredefinedConstants.backgroundColor, for: UIControlState.normal)
                self.btnMobileNo.setTitleColor(UIColor.white, for: UIControlState.normal)
                self.btnEmailAddress.setImage(UIImage(named: "email")?.hmMaskWith(color: PredefinedConstants.backgroundColor), for: UIControlState.normal)
                self.btnMobileNo.setImage(UIImage(named: "phone_icon")?.hmMaskWith(color: UIColor.white), for: UIControlState.normal)
            })
        } else {
            if tfEmail.isFirstResponder {
                tfEmail.resignFirstResponder()
                tfMobileNo.becomeFirstResponder()
            }
            UIView.animate(withDuration: 0.5, animations: {
                self.viewMobile.frame.origin.x = 0.0
                self.viewEmail.frame.origin.x = -self.view.frame.size.width
                self.btnMobileNo.backgroundColor = UIColor.white
                self.btnEmailAddress.backgroundColor = UIColor.clear
                self.btnEmailAddress.setTitleColor(UIColor.white, for: UIControlState.normal)
                self.btnMobileNo.setTitleColor(PredefinedConstants.backgroundColor, for: UIControlState.normal)
            self.btnEmailAddress.setImage(UIImage(named: "email"), for: UIControlState.normal)
            self.btnMobileNo.setImage(UIImage(named: "phone_icon")?.hmMaskWith(color: PredefinedConstants.backgroundColor), for: UIControlState.normal)
            })
        }
    }
    
    func checkValidation() -> NSMutableArray {
        let arrValid = NSMutableArray()
        
        if registrationType == .email {
            if tfEmail.text?.characters.count == 0 {
                arrValid.add(MessageStringFile.vEmail())
            } else if !ValidatorClasses.isValidEmail(testStr: tfEmail.text!){
                arrValid.add(MessageStringFile.vEmailNotValid())
            }
        } else {
            if ValidatorClasses.trimString(tempString: tfMobileNo.text!).characters.count == 0{
                arrValid.add(MessageStringFile.vPhoneNumber())
            }else if ValidatorClasses.trimString(tempString: tfMobileNo.text!).characters.count < 8 || ValidatorClasses.trimString(tempString: tfMobileNo.text!).characters.count > 14{
                arrValid.add(MessageStringFile.vPhoneNotValid())
            }
        }
        
        if tfPassword.text?.characters.count == 0 {
            arrValid.add(MessageStringFile.vPassword())
        } else if (tfPassword.text?.characters.count)! < 6 {
            arrValid.add(MessageStringFile.vPasswordLength())
        }
        
        if tfConfirmPassword.text?.characters.count == 0 {
            arrValid.add(MessageStringFile.vConfirmPassword())
        } else if tfConfirmPassword.text! != tfPassword.text {
            arrValid.add(MessageStringFile.vPasswordAndConfirmPasswordNotMatch())
        }
        
        return arrValid
    }
    
    func animateViewHoney(viewHoney: UIImageView, imageHoney: UIImage) {
        viewHoney.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.3/1.5, animations: { () -> Void in
            viewHoney.image = imageHoney
            viewHoney.transform = CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }) { (finished) -> Void in
            UIView.animate(withDuration: 0.3/2 , animations: { () -> Void in
                viewHoney.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }, completion: { (finished) -> Void in
                viewHoney.transform = CGAffineTransform.identity
            })
        }
    }
    
    func showAlert(firstLblTitle: String, secondLblTitle: String){
        PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: firstLblTitle, secondLblTitle: secondLblTitle)
        PopUpView.sharedInstance.delegate = nil
    }
    
    //MARK:- PopUp Delegates
    
    func clickOnPopUpRightButton() {
        
    }
    
    func clickOnPopUpLeftButton() {
        
    }
    
    //MARK:- TextField Delegate Methods
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfCC {
            tfCC.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.frame.origin.y > 220 {
            svView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y  - 200), animated: false)
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
        } else if textField == tfConfirmPassword {
            let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
            return (newLength > 20) ? false : true
        } else if textField == tfMobileNo {
            let validCharacterSet = NSCharacterSet(charactersIn: ValidatorClasses.phoneNoAcceptableCharacter).inverted
            let filter = string.components(separatedBy: validCharacterSet)
            if filter.count == 1 {
                let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
                return (newLength > 12) ? false : true
            } else {
                return false
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfEmail {
            tfPassword.becomeFirstResponder()
        } else if textField == tfMobileNo {
            tfPassword.becomeFirstResponder()
        } else if textField == tfPassword {
            tfConfirmPassword.becomeFirstResponder()
            
        } else if textField == tfConfirmPassword {
            tfConfirmPassword.resignFirstResponder()
            svView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        return true
    }
    
    // MARK:- Buttons Action
    
    @IBAction func btnSignUpWithFacebook(_ sender: Any) {
        if HelperClass.isInternetAvailable {
            self.btnSignWithFacebook.isHidden = true
            self.svView.addSubview(self.aviIndicator)
            self.aviIndicator.center = self.btnSignWithFacebook.center

            HMFacebookLogin.hmLoginUserWithFacebook(inViewController: self, hmCompletion: { (facebookData, status) in
                switch status {
                case .success:
                    self.callRegistrationWebservice(fbDetatil: facebookData)
                    break
                case .canceled:
                    self.aviIndicator.removeFromSuperview()
                    break
                default:
                    self.aviIndicator.removeFromSuperview()
                    break
                }
            })
        } else {
            self.showAlert(firstLblTitle: MessageStringFile.networkReachability(), secondLblTitle: "")
        }
    }
    
    @IBAction func btnTermCondition(_ sender: Any) {
        performSegue(withIdentifier: "segueTermsAndConditions", sender: nil)
    }
    
    @IBAction func btnSignUp(_ sender: Any) {
        self.view.endEditing(true)
        svView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        let arrValid = checkValidation()
        if arrValid.count == 0 {
            self.callRegistrationWebservice(fbDetatil: nil)
        } else {
            PopUpView.addValidationView(arrValid, strHeader: MessageStringFile.whoopsText(), strSubHeading: MessageStringFile.vInfoNeeded())
        }
    }
    
    @IBAction func btnMobileNo(_ sender: Any) {
        registrationType = .mobileNumber
        switchEmailOrMobile()
    }
    
    @IBAction func btnEmailAddress(_ sender: Any) {
        registrationType = .email
        switchEmailOrMobile()
    }
    
    @IBAction func btnPickCountryCode(_ sender: Any) {
        resignKeyboard()
        self.addAndRemoveCountryPicker(status: true)
    }
    
    @IBAction func btnDoneCountryPicker(_ sender: Any) {
        if let country = selectedCountry {
            tfCC.text = country.phoneCode
            imgCountryCodeFlag.image = country.flag
        }
        self.addAndRemoveCountryPicker(status: false)
    }
    
    @IBAction func btnCancelCountryPicker(_ sender: Any) {
        self.addAndRemoveCountryPicker(status: false)
    }
    
    func moveToMenu(animated: Bool) {
        XFindrUserDefaults.setUserLoginStatus(status: 1)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    func addAndRemoveCountryPicker(status: Bool) {
        
        if status {
            self.viewCountryPicker.frame = CGRect(x: 0.0, y: self.view.frame.size.height - self.viewCountryPicker.frame.size.height, width: self.view.frame.size.width, height: self.viewCountryPicker.frame.size.height)
            self.view.addSubview(self.viewCountryPicker)
        } else {
            self.viewCountryPicker.removeFromSuperview()
        }
    }
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        
        selectedCountry = Country(code: countryCode, name: name, phoneCode: phoneCode, flag: flag)
        
    }
    
    func callRegistrationWebservice(fbDetatil: HMFacebookData?) {
        if HelperClass.isInternetAvailable {
            
            var strCC = tfCC.text!.replacingOccurrences(of: "+", with: "")
            var phoneNo = tfMobileNo.text!
            var email = tfEmail.text!
            if self.registrationType == .mobileNumber {
                email = ""
            } else {
                phoneNo = ""
                strCC = ""
            }
            
            var params: [String: Any] = [:]
            
            if let detail = fbDetatil {
                params = [WebServiceConstants.email: detail.email, WebServiceConstants.phoneNo: "", WebServiceConstants.password: "", WebServiceConstants.deviceType: PredefinedConstants.userDeviceType, WebServiceConstants.deviceId: PredefinedConstants.userDeviceId, WebServiceConstants.appVersion: PredefinedConstants.deviceAppVersion, WebServiceConstants.socialId: detail.id, WebServiceConstants.language: MessageStringFile.appLanguage(), WebServiceConstants.name: detail.fullName, WebServiceConstants.countryCode: ""]
            } else {
                params = [WebServiceConstants.email: email, WebServiceConstants.phoneNo: phoneNo, WebServiceConstants.password: tfPassword.text!, WebServiceConstants.deviceType: PredefinedConstants.userDeviceType, WebServiceConstants.deviceId: PredefinedConstants.userDeviceId, WebServiceConstants.appVersion: PredefinedConstants.deviceAppVersion, WebServiceConstants.socialId: "", WebServiceConstants.language: MessageStringFile.appLanguage(), WebServiceConstants.name: "", WebServiceConstants.countryCode: strCC]
                self.svView.addSubview(self.aviIndicator)
                self.aviIndicator.center = self.btnSignUp.center
                self.btnSignUp.setTitle(nil, for: UIControlState.normal)
            }
            
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            HMWebService.createRequestAndGetResponse(WebServiceLinks.registration, methodType: HM_HTTPMethod.POST, andHeaderDict: [WebServiceConstants.language: MessageStringFile.appLanguage()], andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                
                UIApplication.shared.endIgnoringInteractionEvents()
                self.aviIndicator.removeFromSuperview()
                self.btnSignUp.setTitle(MessageStringFile.signUp(), for: UIControlState.normal)
                self.btnSignWithFacebook.isHidden = false
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
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyViewController") as! VerifyViewController
                        PredefinedConstants.appDelegate.loginUserOnSocket()
                        if self.registrationType == .email {
                            vc.verificationType = .registrationEmail
                            XFindrUserDefaults.setEmailPasswordInUserDefaults(email: self.tfEmail.text!, password: self.tfPassword.text!, isRemember: false)
                        } else {
                            vc.verificationType = .registrationMobile
                            XFindrUserDefaults.setEmailPasswordInUserDefaults(email: self.tfMobileNo.text!, password: self.tfPassword.text!, isRemember: false)
                        }
                        self.navigationController?.pushViewController(vc, animated: true)
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueTermsAndConditions" {
            let vc = segue.destination as! TermsAndConditionsViewController
            vc.tAndC = .termsAndCondition
        }
    }
    
}
