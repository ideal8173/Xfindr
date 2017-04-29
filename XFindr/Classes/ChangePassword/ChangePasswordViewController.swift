//
//  ChangePasswordView.swift
//  XFindr
//
//  Created by Neeleshwari on 27/03/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class ChangePasswordViewController : UIViewController, UITextFieldDelegate, PopUpViewDelegate {
    
    //Outlets
    
    @IBOutlet var btnNavigationSave: UIBarButtonItem!
    @IBOutlet var viewChangePassword: UIView!
    @IBOutlet var tfCurrrentPassword: UITextField!
    @IBOutlet var tfNewPassword: UITextField!
    @IBOutlet var tfConfirmPassword: UITextField!

    
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setDelegates()
        self.setDisplayView()
        self.changeLanguage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tapGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    //MARK:- Function to set navigation bar
    
    func setNavigation() {
        self.title = ClassesHeader.changePassword()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    
    // MARK:- Fuctions
    
    func setDelegates()  {
        tfCurrrentPassword.delegate = self
        tfNewPassword.delegate = self
        tfConfirmPassword.delegate = self
    }
    
    func setDisplayView()  {
        self.viewChangePassword.setShadowOnView(PredefinedConstants.grayTextColor)
        tfCurrrentPassword.becomeFirstResponder()
    }
    
    func changeLanguage() {
        tfCurrrentPassword.attributedPlaceholder = NSAttributedString(string: MessageStringFile.currentPass(),attributes: [NSForegroundColorAttributeName: PredefinedConstants.grayTextColor])
        tfNewPassword.attributedPlaceholder = NSAttributedString(string: MessageStringFile.newPass(),attributes:[NSForegroundColorAttributeName: PredefinedConstants.grayTextColor])
        tfConfirmPassword.attributedPlaceholder = NSAttributedString(string: MessageStringFile.confirmNewPass(),attributes: [NSForegroundColorAttributeName: PredefinedConstants.grayTextColor])
        btnNavigationSave.title = MessageStringFile.save()
    }
    
    func tapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.addTarget(self, action: #selector(didTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func didTap() {
        self.view.endEditing(true)
    }
    
    //MARK:- Check Validations
    
    func checkValidation() -> NSMutableArray{
        let arrValid = NSMutableArray()
        
        if tfCurrrentPassword.text?.characters.count == 0 {
            arrValid.add(MessageStringFile.vCurrentPassword())
        } else if (tfCurrrentPassword.text?.characters.count)! < 6 {
            arrValid.add(MessageStringFile.vCurrentPasswordLength())
        }
        if tfNewPassword.text?.characters.count == 0 {
            arrValid.add(MessageStringFile.vNewPassword())
        } else if (tfNewPassword.text?.characters.count)! < 6 {
            arrValid.add(MessageStringFile.vNewPasswordLength())
        }
        
        if tfCurrrentPassword.text! == tfNewPassword.text! {
            arrValid.add(MessageStringFile.vOldAndNewPass())
        }
        
        if tfConfirmPassword.text?.characters.count == 0 {
            arrValid.add(MessageStringFile.vConfirmPassword())
            
        } else if tfConfirmPassword.text! != tfNewPassword.text {
            arrValid.add(MessageStringFile.vPasswordAndConfirmPasswordNotMatch())
        }
        
        return arrValid
    }
    
    //MARK:- PopUp Delegates
    
    func clickOnPopUpRightButton() {
        
    }
    
    func clickOnPopUpLeftButton() {
        PopUpView.sharedInstance.delegate = nil
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- TextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfCurrrentPassword {
            let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
            return (newLength > 20) ? false : true
        } else if textField == tfNewPassword {
            let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
            return (newLength > 20) ? false : true
        } else if textField == tfConfirmPassword {
            let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
            return (newLength > 20) ? false : true
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfCurrrentPassword {
            tfNewPassword.becomeFirstResponder()
        } else if textField == tfNewPassword {
            tfConfirmPassword.becomeFirstResponder()
        } else if textField == tfConfirmPassword {
            tfConfirmPassword.resignFirstResponder()
        }
        return true
    }
    
    // MARK:- Buttons Action
    
    @IBAction func btnNavigationSave(_ sender: Any) {
        self.view.endEditing(true)
        let arrValid = checkValidation()
        if arrValid.count == 0 {
            self.callWebserviceChangePass()
        } else {
            PopUpView.addValidationView(arrValid, strHeader: MessageStringFile.whoopsText(), strSubHeading: MessageStringFile.vInfoNeeded())
        }
        
    }
    
    //MARK:- Change Password Webservice
    
    func callWebserviceChangePass() {
        if HelperClass.isInternetAvailable {
            let params = [WebServiceConstants.old_Pass: tfCurrrentPassword.text!, WebServiceConstants.new_Pass: tfNewPassword.text!, WebServiceConstants.language:MessageStringFile.appLanguage()]
            print("params >>>> \(params)")
            HMWebService.createRequestAndGetResponse(WebServiceLinks.changePassword, methodType: HM_HTTPMethod.POST, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                print("theReply >>>> \(String(describing: theReply))")
                if dictResponse!.count > 0 {
                    let JSON: NSDictionary = dictResponse! as NSDictionary
                    var msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                    if msg == "" {
                        msg = MessageStringFile.serverError()
                    }
                    
                    if JSON.hmGetInt(forKey: WebServiceConstants.success) == 1 {
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
    }
    
    func showAlert(firstLblTitle: String, secondLblTitle: String){
        PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: firstLblTitle, secondLblTitle: secondLblTitle)
        PopUpView.sharedInstance.delegate = nil
    }
    
    
}





