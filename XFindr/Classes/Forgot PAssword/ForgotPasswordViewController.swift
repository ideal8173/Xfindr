//
//  ForgotPasswordViewController.swift
//  XFindr
//
//  Created by Anurag on 3/24/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate, PopUpViewDelegate {
    
    @IBOutlet var svView: UIScrollView!
    @IBOutlet var lblForgotPassword: UILabel!
    @IBOutlet var lblToResetPassword: UILabel!
    @IBOutlet var tfEmail: UITextField!
    @IBOutlet var btnSubmit: UIButton!
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    
    // MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setDelegate()
        self.otherFunction()
        self.setNavigation()
        self.changeLanguage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.title = ""
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
    }
    
    func setDelegate() {
        tfEmail.delegate = self
    }
    
    func otherFunction() {
        btnSubmit.circleView(UIColor.white, borderWidth: 1.0)
    }
    
    func changeLanguage() {
        tfEmail.attributedPlaceholder = NSAttributedString(string: MessageStringFile.enterEmailOrMobileNo(), attributes: [NSForegroundColorAttributeName: UIColor.white])
        lblForgotPassword.text = MessageStringFile.forgotPassword()
        lblToResetPassword.text = MessageStringFile.toResetPassword()
        btnSubmit.setTitle(MessageStringFile.submit(), for: UIControlState.normal)
    }
    
    func checkValidation() -> NSMutableArray{
        let arrValid = NSMutableArray()
        /*
        if tfEmail.text?.characters.count == 0 {
            arrValid.add(MessageStringFile.vEmail())
        } else if !ValidatorClasses.isValidEmail(testStr: tfEmail.text!){
            arrValid.add(MessageStringFile.vEmailNotValid())
        }
        */
        
        if tfEmail.text?.characters.count == 0 {
            arrValid.add(MessageStringFile.vEmailOrMobile())
        } else {
            let type = self.checkMailAndPhone()
            if type == .mobileNumber {
                if ValidatorClasses.trimString(tempString: tfEmail.text!).characters.count < 8 || ValidatorClasses.trimString(tempString: tfEmail.text!).characters.count > 14 {
                    arrValid.add(MessageStringFile.vPhoneNotValid())
                }
            } else {
                if !ValidatorClasses.isValidEmail(testStr: tfEmail.text!){
                    arrValid.add(MessageStringFile.vEmailNotValid())
                }
            }
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
    
    //MARK:- PopUp delegates
    
    func clickOnPopUpLeftButton() {
        _ = self.navigationController?.popViewController(animated: true)
        PopUpView.sharedInstance.delegate = nil
    }
    
    func clickOnPopUpRightButton() {
        
    }
    
    //MARk:- TextField Delegate Methods
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.frame.origin.y > 250 {
            svView.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y  - 210), animated: true)
        }else {
            svView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
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
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if textField == tfEmail {
            tfEmail.resignFirstResponder()
            svView.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
        }
        return true
    }
    
    // MARK:- Button Action
    @IBAction func btnSubmit(_ sender: Any) {
        
        self.view.endEditing(true)
        svView.setContentOffset(CGPoint(x: 0, y: -64), animated: true)
        let arrValid = checkValidation()
        if arrValid.count == 0 {
            if HelperClass.isInternetAvailable {
                var params: [String: Any] = [:]
                let type = self.checkMailAndPhone()
                if type == .mobileNumber {
                    params = [WebServiceConstants.phoneNo: tfEmail.text!, WebServiceConstants.language: MessageStringFile.appLanguage()]
                } else {
                    params = [WebServiceConstants.email: tfEmail.text!, WebServiceConstants.language: MessageStringFile.appLanguage()]
                }
                
                UIApplication.shared.beginIgnoringInteractionEvents()
                btnSubmit.setTitle(nil, for: UIControlState.normal)
                
                self.svView.addSubview(self.aviIndicator)
                self.aviIndicator.center = self.btnSubmit.center
                
                HMWebService.createRequestAndGetResponse(WebServiceLinks.forgotPassword, methodType: HM_HTTPMethod.POST, andHeaderDict: [WebServiceConstants.language: MessageStringFile.appLanguage()], andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                    
                    print("theReply >>>> \(String(describing: theReply))")
                    
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.btnSubmit.setTitle(MessageStringFile.submit(), for: UIControlState.normal)
                    self.aviIndicator.removeFromSuperview()
                    if dictResponse!.count > 0 {
                        let JSON: NSDictionary = dictResponse! as NSDictionary
                        var msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                        if msg == "" {
                            msg = MessageStringFile.serverError()
                        }
                        
                        if JSON.hmGetInt(forKey: WebServiceConstants.success) == 1 {
                            //self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                            PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: msg, secondLblTitle: "")
                            PopUpView.sharedInstance.delegate = self
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
    
    func showAlert(firstLblTitle: String, secondLblTitle: String){
        PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: firstLblTitle, secondLblTitle: secondLblTitle)
        PopUpView.sharedInstance.delegate = nil
    }
}
