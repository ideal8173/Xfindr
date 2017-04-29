//
//  VerifyViewController.swift
//  XFindr
//
//  Created by Neeleshwari on 28/03/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class VerifyViewController: UIViewController ,PinCodeTextFieldDelegate ,PopUpViewDelegate{
    
    //Outlets
    @IBOutlet var scrlView: UIScrollView!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var tfVerificationCode: PinCodeTextField!
    @IBOutlet var lblHeadTitle: UILabel!
    @IBOutlet var btnResetTimer: UIButton!
    @IBOutlet var lblTimerReset: UILabel!
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    //Variables
    var verificationType: VerificationType = .registrationEmail
    var timeRemains = 60
    var timerVerify = Timer()
    var verificationCode = ""
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setDelegates()
        self.setDisplayView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigation()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.title = ""
        if verificationCode != "" {
            showAlert(firstLblTitle: verificationCode, secondLblTitle: "")
        }
        
    }
    
    // MARK:- Functions..
    func setNavigation() {
        self.title = ""
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        if verificationType == .registrationMobile || verificationType == .loginMobile || verificationType == .registrationEmail || verificationType == .loginEmail {
            self.navigationItem.setHidesBackButton(true, animated: true)
        }
    }
    
    // MARK:- Functions..
    
    //setDelegates
    func setDelegates()  {
        tfVerificationCode.delegate = self
        tfVerificationCode.keyboardType = .numberPad
        _ = tfVerificationCode.becomeFirstResponder()
    }
    
    //setDisplayView
    func setDisplayView()  {
        self.btnSubmit.circleView(UIColor.white, borderWidth: 1.0)
        let dictInfo = AppVariables.getDictUserDetail()
        var str = dictInfo.hmGetString(forKey: WebServiceConstants.email)
        if verificationType == .registrationMobile || verificationType == .loginMobile || verificationType == .mobile {
            var cc = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictInfo, strObject: WebServiceConstants.countryCode)
            if cc.range(of: "+") == nil {
                cc = "+" + cc
            }
            let phoneNo = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictInfo, strObject: WebServiceConstants.phoneNo)
            str = cc + " " + phoneNo
        }
        lblHeadTitle.text = String(format: MessageStringFile.verifyText(), str)
        btnResetTimer.isUserInteractionEnabled = false
        btnSubmit.setTitle(MessageStringFile.submit(), for: UIControlState.normal)
        self.resendVerificationCode()
    }
    
    func resendVerificationCode() {
        btnResetTimer.isUserInteractionEnabled = false
        lblTimerReset.text = MessageStringFile.resentCodeIn() + " 1:00"
        timerVerify.invalidate()
        timerVerify = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func update() {
        if(timeRemains > 0) {
            timeRemains -= 1
            let minR = timeRemains / 60
            let secR = timeRemains % 60
            let strMin = "0\(minR)"
            var strSec = ""
            
            if secR < 10 {
                strSec = "0\(secR)"
            }else{
                strSec = "\(secR)"
            }
            lblTimerReset.text = "\(MessageStringFile.resentCodeIn()) \(strMin):\(strSec)"
        } else {
            lblTimerReset.text = MessageStringFile.resentCode()
            btnResetTimer.isUserInteractionEnabled = true
        }
    }
    
    //Check Validations
    func checkValidation() -> NSMutableArray {
        let arrValid = NSMutableArray()
        if tfVerificationCode.text?.characters.count != 4 {
            arrValid.add(MessageStringFile.vVerificationCode())
        }
        return arrValid
    }
    
    func showAlert(firstLblTitle: String, secondLblTitle: String){
        PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: firstLblTitle, secondLblTitle: secondLblTitle)
        PopUpView.sharedInstance.delegate = nil
    }
    
    func moveToMenu(animated: Bool) {
        XFindrUserDefaults.setUserLoginStatus(status: 1)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! TabBarController
        self.navigationController?.pushViewController(vc, animated: animated)
    }
    
    //MARK:- PopUp Delegates
    
    func clickOnPopUpRightButton() {
        
    }
    
    func clickOnPopUpLeftButton() {
        
    }
    
    //MARK:- TextField Delegate Methods
    func textFieldShouldBeginEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: PinCodeTextField) {
        
    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        return true
    }
    
    func textField(_ textField: PinCodeTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let validCharacterSet = NSCharacterSet(charactersIn: ValidatorClasses.phoneNoAcceptableCharacter).inverted
        let filter = string.components(separatedBy: validCharacterSet)
        if filter.count == 1 {
            let newLength: Int = textField.text!.characters.count + string.characters.count - range.length
            return (newLength > 4) ? false : true
        } else {
            return false
        }
    }
    
    
    // MARK:- Button Actions....
    
    @IBAction func btnResetTimer(_ sender: Any) {
        
        if HelperClass.isInternetAvailable {
            var params: [String: Any] = [:]
            let dictInfo = AppVariables.getDictUserDetail()
            if self.verificationType == .registrationMobile || self.verificationType == .loginMobile {
                let cc = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictInfo, strObject: WebServiceConstants.countryCode)
                let phoneNo = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictInfo, strObject: WebServiceConstants.phoneNo)
                params = [WebServiceConstants.email: "", WebServiceConstants.phoneNo: phoneNo, WebServiceConstants.language: MessageStringFile.appLanguage(), WebServiceConstants.countryCode: cc]
            } else {
                let email = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictInfo, strObject: WebServiceConstants.email)
                params = [WebServiceConstants.email: email, WebServiceConstants.phoneNo: "", WebServiceConstants.language: MessageStringFile.appLanguage(), WebServiceConstants.countryCode: ""]
            }
            
            self.aviIndicator.frame.origin.x = self.btnResetTimer.frame.origin.x + self.btnResetTimer.frame.size.width - self.aviIndicator.frame.size.width
            self.aviIndicator.center.y = self.btnResetTimer.center.y
            self.scrlView.addSubview(self.aviIndicator)
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            HMWebService.createRequestAndGetResponse(WebServiceLinks.sendVerificationCode, methodType: HM_HTTPMethod.POST, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                
                UIApplication.shared.endIgnoringInteractionEvents()
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
                        self.timeRemains = 90
                        self.resendVerificationCode()
                        self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                    } else {
                        self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                    }
                } else {
                    self.showAlert(firstLblTitle: MessageStringFile.serverError(), secondLblTitle: "")
                }
                
            })
        } else {
            self.showAlert(firstLblTitle: MessageStringFile.networkReachability(), secondLblTitle: "")
        }
    }
    
    
    @IBAction func btnSubmit(_ sender: Any) {
        self.view.endEditing(true)
        let arrValid = checkValidation()
        if arrValid.count == 0 {
            btnSubmit.setTitle(MessageStringFile.submit(), for: UIControlState.normal)
            //email(optional) , phone_no(optional),language,country_code
            if HelperClass.isInternetAvailable {
                let dictInfo = AppVariables.getDictUserDetail()
                var params: [String: Any] = [:]
                if self.verificationType == .registrationMobile || self.verificationType == .loginMobile {
                    let cc = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictInfo, strObject: WebServiceConstants.countryCode)
                    let phoneNo = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictInfo, strObject: WebServiceConstants.phoneNo)
                    params = [WebServiceConstants.email: "", WebServiceConstants.phoneNo: phoneNo, WebServiceConstants.language: MessageStringFile.appLanguage(), WebServiceConstants.countryCode: cc, WebServiceConstants.code: tfVerificationCode.text!]
                } else {
                    let email = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictInfo, strObject: WebServiceConstants.email)
                    params = [WebServiceConstants.email: email, WebServiceConstants.phoneNo: "", WebServiceConstants.language: MessageStringFile.appLanguage(), WebServiceConstants.countryCode: "", WebServiceConstants.code: tfVerificationCode.text!]
                }
                
                print("params >>>>> \(params)")
                print("WebServiceLinks.verifyMobile >>>>> \(WebServiceLinks.verifyMobile)")
                
                self.scrlView.addSubview(self.aviIndicator)
                self.aviIndicator.center = self.btnSubmit.center
                self.btnSubmit.setTitle(nil, for: UIControlState.normal)
                UIApplication.shared.beginIgnoringInteractionEvents()
                
                HMWebService.createRequestAndGetResponse(WebServiceLinks.verifyMobile, methodType: HM_HTTPMethod.POST, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.aviIndicator.removeFromSuperview()
                    self.btnSubmit.setTitle(MessageStringFile.submit(), for: UIControlState.normal)
                    
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
                            self.moveToMenu(animated: true)
                        } else {
                            self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                        }
                    } else {
                        self.showAlert(firstLblTitle: MessageStringFile.serverError(), secondLblTitle: "")
                    }
                })
            } else {
                self.showAlert(firstLblTitle: MessageStringFile.networkReachability(), secondLblTitle: "")
            }
        } else {
            PopUpView.addValidationView(arrValid, strHeader: MessageStringFile.whoopsText(), strSubHeading: MessageStringFile.vInfoNeeded())
        }
    }
    
    @IBAction func btnEndEditing(_ sender: Any) {
        self.view.endEditing(true)
    }
    
}





