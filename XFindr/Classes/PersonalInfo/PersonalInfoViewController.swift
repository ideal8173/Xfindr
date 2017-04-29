//
//  PersonalInfoViewController.swift
//  XFindr
//
//  Created by Neeleshwari on 06/04/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class PersonalInfoViewController: UIViewController, UITextViewDelegate, SelectionDelegate, PopUpViewDelegate {
    
    @IBOutlet var scrlView: UIScrollView!
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var btnNavigationSave: UIBarButtonItem!
    
    @IBOutlet var lblServiceType: UILabel!
    @IBOutlet var lblServiceMessage: UILabel!
    @IBOutlet var btnServices: UIButton!
    @IBOutlet var imgArrow: UIImageView!
    @IBOutlet var lblAdditionalServices: UILabel!
    @IBOutlet var tvAdditionalServices: UIPlaceHolderTextView!
    @IBOutlet var lblAboutMe: UILabel!
    @IBOutlet var tvAboutMe: UIPlaceHolderTextView!
    @IBOutlet var lblOtherServices: UILabel!
    @IBOutlet var tvOtherServices: UIPlaceHolderTextView!
    @IBOutlet var lblServices: UILabel!
    @IBOutlet var tvServices: UIPlaceHolderTextView!
    @IBOutlet var lblHashtags: UILabel!
    @IBOutlet var tvHashtags: UIPlaceHolderTextView!
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    
    var strUserType = ""
    var arrServices = NSMutableArray()
    var dictPrevious = NSDictionary()
    var isFirstTime: Bool = true
    //MARK:- Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.setDelegates()
        self.setDisplayView()
        self.changeLanguage()
        HMUtilities.hmMainQueue {
            self.setupViewFrame()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.setNavigation()
        if isFirstTime {
            isFirstTime = false
            self.setPreviousData(self.dictPrevious)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    // MARK:- Functions..Set Navigation
    
    func setNavigation() {
        /*
        self.navigationController?.navigationBar.isTranslucent = false;
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = PredefinedConstants.navigationColor
        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
 */
        self.title = ClassesHeader.personalInformation()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    // MARK:- Fuctions
    
    func setPreviousData(_ dictPrevious: NSDictionary) {
        if strUserType == WebServiceConstants.provider {
            let serviceFunc = AppVariables.services(arr: dictPrevious.hmGetNSArray(forKey: WebServiceConstants.providerServices), dict: nil)
            self.arrServices = serviceFunc.arr.mutableCopy() as! NSMutableArray
            self.btnServices.setTitle(serviceFunc.str, for: UIControlState.normal)
            
            if self.btnServices.hmCurrentTitle == "" {
                self.btnServices.setTitleColor(PredefinedConstants.darkGrayTextColor, for: UIControlState.normal)
            } else {
                self.btnServices.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            
            tvAdditionalServices.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.providerNote)
            tvAboutMe.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.providerDesc)
            tvOtherServices.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.providerOther)
            tvServices.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.providerRequire)
            tvHashtags.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.providerHashtag)
        } else {
            let serviceFunc = AppVariables.services(arr: dictPrevious.hmGetNSArray(forKey: WebServiceConstants.seekerServices), dict: nil)
            self.arrServices = serviceFunc.arr.mutableCopy() as! NSMutableArray
            self.btnServices.setTitle(serviceFunc.str, for: UIControlState.normal)
            
            if self.btnServices.hmCurrentTitle == "" {
                self.btnServices.setTitleColor(PredefinedConstants.darkGrayTextColor, for: UIControlState.normal)
            } else {
                self.btnServices.setTitleColor(UIColor.black, for: UIControlState.normal)
            }
            
            tvAdditionalServices.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.seekerNote)
            tvAboutMe.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.seekerDesc)
            tvOtherServices.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.seekerOther)
            tvServices.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.seekerProvide)
            tvHashtags.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.seekerHashtag)
        }
    }
    
    func setDelegates()  {
        self.tvAdditionalServices.delegate = self
        self.tvAboutMe.delegate = self
        self.tvOtherServices.delegate = self
        self.tvServices.delegate = self
        self.tvHashtags.delegate = self
    }
    
    func setDisplayView()  {
        self.lblServiceMessage.text = MessageStringFile.chooseATypeOfService()
        self.btnServices.setCornerRadiousAndBorder(PredefinedConstants.grayTextColor, borderWidth: 1)
        self.tvAdditionalServices.setCornerRadiousAndBorder(PredefinedConstants.grayTextColor, borderWidth: 1)
        self.tvAboutMe.setCornerRadiousAndBorder(PredefinedConstants.grayTextColor, borderWidth: 1)
        self.tvOtherServices.setCornerRadiousAndBorder(PredefinedConstants.grayTextColor, borderWidth: 1)
        self.tvServices.setCornerRadiousAndBorder(PredefinedConstants.grayTextColor, borderWidth: 1)
        self.tvHashtags.setCornerRadiousAndBorder(PredefinedConstants.grayTextColor, borderWidth: 1)
        let font = PredefinedConstants.appFont(size: 12.0)
        let color = PredefinedConstants.darkGrayTextColor
        var btnTitle = ""
        if strUserType == WebServiceConstants.provider {
            btnTitle = MessageStringFile.typeOfServiceYouAreProviding()
            self.lblServiceType.text = btnTitle
            self.lblAdditionalServices.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.whatAreYouProviding(), stringToColor: " (50 " + "\(MessageStringFile.characters()))", font: PredefinedConstants.appFont(size: 12.0), color: color)
            self.lblAboutMe.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.profileTitle(), stringToColor: " (500 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblOtherServices.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.otherServicesYouMayProvide(), stringToColor: " \(MessageStringFile.optional()) (50 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblServices.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.servicesYouMayRequire(), stringToColor: " \(MessageStringFile.optional()) (50 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblHashtags.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.hashtags(), stringToColor: " \(MessageStringFile.optional())", font: font, color: color)
        } else {
            btnTitle = MessageStringFile.typeOfServiceYouAreSeekingFor()
            self.lblServiceType.text = btnTitle
            self.lblAdditionalServices.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.whatAreYouSeeking(), stringToColor: " (50 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblAboutMe.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.profileTitle(), stringToColor: " (500 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblOtherServices.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.otherServicesYouMayRequire(), stringToColor: " \(MessageStringFile.optional()) (50 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblServices.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.servicesYouMayProvide(), stringToColor: " \(MessageStringFile.optional()) (50 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblHashtags.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.hashtags(), stringToColor: " \(MessageStringFile.optional())", font: font, color: color)
        }
        
        self.tvAdditionalServices.placeholderColor = PredefinedConstants.darkGrayTextColor
        self.tvAboutMe.placeholderColor = PredefinedConstants.darkGrayTextColor
        self.tvOtherServices.placeholderColor = PredefinedConstants.darkGrayTextColor
        self.tvServices.placeholderColor = PredefinedConstants.darkGrayTextColor
        self.tvHashtags.placeholderColor = PredefinedConstants.darkGrayTextColor
        
        if strUserType == WebServiceConstants.provider {
            self.tvAdditionalServices.placeholder = MessageStringFile.whatAreYouProviding() + " (50 " + "\(MessageStringFile.characters()))"
            self.tvAboutMe.placeholder = MessageStringFile.profileTitle() + " (500 " + "\(MessageStringFile.characters()))"
            self.tvOtherServices.placeholder = MessageStringFile.otherServicesYouMayProvide() + " " + MessageStringFile.optional() + " (50 " + "\(MessageStringFile.characters()))"
            self.tvServices.placeholder = MessageStringFile.servicesYouMayRequire() + " " + MessageStringFile.optional() + " (50 " + "\(MessageStringFile.characters()))"
            self.tvHashtags.placeholder = MessageStringFile.hashtags() + " " + MessageStringFile.optional()
        } else {
            self.tvAdditionalServices.placeholder = MessageStringFile.whatAreYouSeeking() + " (50 " + "\(MessageStringFile.characters()))"
            self.tvAboutMe.placeholder = MessageStringFile.profileTitle() + " (500 " + "\(MessageStringFile.characters()))"
            self.tvOtherServices.placeholder = MessageStringFile.otherServicesYouMayRequire() + " " + MessageStringFile.optional() + " (50 " + "\(MessageStringFile.characters()))"
            self.tvServices.placeholder = MessageStringFile.servicesYouMayProvide() + " " + MessageStringFile.optional() + " (50 " + "\(MessageStringFile.characters()))"
            self.tvHashtags.placeholder = MessageStringFile.hashtags() + " " + MessageStringFile.optional()
        }        
        
        if self.btnServices.hmCurrentTitle == "" {
            self.btnServices.setTitle(btnTitle, for: UIControlState.normal)
            self.btnServices.setTitleColor(PredefinedConstants.darkGrayTextColor, for: UIControlState.normal)
        }
        
        self.scrlView.keyboardDismissMode = .onDrag
    }
    
    func changeLanguage() {
        btnNavigationSave.title = MessageStringFile.save()
    }
    
    func setupViewFrame() {
        self.lblServiceType.sizeToFit()
        let joinPadding: CGFloat = 10.0
        let differencePadding: CGFloat = 15.0
        self.lblServiceMessage.frame.origin.y = self.lblServiceType.frame.origin.y + self.lblServiceType.frame.size.height + joinPadding
        self.lblServiceMessage.sizeToFit()
        self.btnServices.frame.origin.y = self.lblServiceMessage.frame.origin.y + self.lblServiceMessage.frame.size.height + joinPadding
        
        self.imgArrow.center.y = self.btnServices.center.y
        
        self.lblAdditionalServices.frame.origin.y = self.btnServices.frame.origin.y + self.btnServices.frame.size.height + differencePadding
        self.lblAdditionalServices.sizeToFit()
        self.tvAdditionalServices.frame.origin.y = self.lblAdditionalServices.frame.origin.y + self.lblAdditionalServices.frame.size.height + joinPadding
        
        self.lblAboutMe.frame.origin.y = self.tvAdditionalServices.frame.origin.y + self.tvAdditionalServices.frame.size.height + differencePadding
        self.lblAboutMe.sizeToFit()
        self.tvAboutMe.frame.origin.y = self.lblAboutMe.frame.origin.y + self.lblAboutMe.frame.size.height + joinPadding
        
        self.lblAboutMe.frame.origin.y = self.tvAdditionalServices.frame.origin.y + self.tvAdditionalServices.frame.size.height + differencePadding
        self.lblAboutMe.sizeToFit()
        self.tvAboutMe.frame.origin.y = self.lblAboutMe.frame.origin.y + self.lblAboutMe.frame.size.height + joinPadding
        
        self.lblOtherServices.frame.origin.y = self.tvAboutMe.frame.origin.y + self.tvAboutMe.frame.size.height + differencePadding
        self.lblOtherServices.sizeToFit()
        self.tvOtherServices.frame.origin.y = self.lblOtherServices.frame.origin.y + self.lblOtherServices.frame.size.height + joinPadding
        
        self.lblServices.frame.origin.y = self.tvOtherServices.frame.origin.y + self.tvOtherServices.frame.size.height + differencePadding
        self.lblServices.sizeToFit()
        self.tvServices.frame.origin.y = self.lblServices.frame.origin.y + self.lblServices.frame.size.height + joinPadding
        
        self.lblHashtags.frame.origin.y = self.tvServices.frame.origin.y + self.tvServices.frame.size.height + differencePadding
        self.lblHashtags.sizeToFit()
        self.tvHashtags.frame.origin.y = self.lblHashtags.frame.origin.y + self.lblHashtags.frame.size.height + joinPadding
        
        self.viewContainer.frame.size.height = self.tvHashtags.frame.origin.y + self.tvHashtags.frame.size.height + 30.0
        self.scrlView.contentSize = CGSize(width: 0, height: self.viewContainer.frame.origin.y + self.viewContainer.frame.size.height + 30)
    }
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeKeyboard()
    }
    */
    
    func removeKeyboard() {
        self.tvAdditionalServices.resignFirstResponder()
        self.tvAboutMe.resignFirstResponder()
        self.tvOtherServices.resignFirstResponder()
        self.tvServices.resignFirstResponder()
        self.tvHashtags.resignFirstResponder()
    }
    
    //MARK:- PopUp Delegates
    
    func clickOnPopUpRightButton() {
        
    }
    
    func clickOnPopUpLeftButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- TextView Delegate Methods
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self.scrlView.setContentOffset(CGPoint(x: 0, y: (textView.frame.origin.y - 70)), animated: true)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if textView == tvAdditionalServices {
                tvAboutMe.becomeFirstResponder()
            } else if textView == tvAboutMe {
                tvOtherServices.becomeFirstResponder()
            } else if textView == tvOtherServices {
                tvServices.becomeFirstResponder()
            } else if textView == tvServices {
                tvHashtags.becomeFirstResponder()
            } else if textView == tvHashtags {
                tvHashtags.resignFirstResponder()
                self.scrlView.setContentOffset(CGPoint.zero, animated: true)
            }
            return false
        }
        
        if textView == tvAdditionalServices {
            if (tvAdditionalServices.text.characters.count > 50 && range.length == 0) {
                return false
            }
        } else if textView == tvAboutMe {
            if (tvAboutMe.text.characters.count > 500 && range.length == 0) {
                return false
            }
        } else if textView == tvOtherServices {
            if (tvOtherServices.text.characters.count > 50 && range.length == 0) {
                return false
            }
        } else if textView == tvServices {
            if (tvServices.text.characters.count > 50 && range.length == 0) {
                return false
            }
        }
    
        return true
    }
    
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        scrlView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        return true
    }
    
    //MARK:- CheckValidation
    
    func checkValidation() -> NSMutableArray{
        let arrValid = NSMutableArray()
        return arrValid
    }
    
    //MARK:- Button Actions...
    
    @IBAction func btnNavigationSave(_ sender: Any) {
        self.view.endEditing(true)
        
        if HelperClass.isInternetAvailable {
            self.showSaveLoader(status: true)
            var params: [String: String] = [:]
            
            if strUserType.lowercased() == WebServiceConstants.provider {
                params = [WebServiceConstants.providerServices: self.arrServices.hmJsonString(), WebServiceConstants.providerNote: tvAdditionalServices.text!, WebServiceConstants.providerDesc: tvAboutMe.text!, WebServiceConstants.providerHashtag: tvHashtags.text!, WebServiceConstants.providerRequire: tvServices.text!, WebServiceConstants.providerOther: tvOtherServices.text!]
            } else {
                params = [WebServiceConstants.seekerServices: self.arrServices.hmJsonString(), WebServiceConstants.seekerNote: tvAdditionalServices.text!, WebServiceConstants.seekerDesc: tvAboutMe.text!,WebServiceConstants.seekerOther: tvOtherServices.text!,WebServiceConstants.seekerHashtag: tvHashtags.text!, WebServiceConstants.seekerProvide: tvServices.text!]
            }
            
            print("WebServiceLinks.updateServices >>>>>> \(WebServiceLinks.updateServices)")
            print("params >>>>>> \(params)")
            
            HMWebService.createRequestAndGetResponse(WebServiceLinks.updateServices, methodType: HM_HTTPMethod.POST, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                print("theReply >>>>>> \(String(describing: theReply))")
                self.showSaveLoader(status: false)
                if dictResponse!.count > 0 {
                    let JSON: NSDictionary = dictResponse! as NSDictionary
                    var msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                    if msg == "" {
                        msg = MessageStringFile.serverError()
                    }
                    
                    if JSON.hmGetInt(forKey: WebServiceConstants.success) == 1 {
                        let dictUserInfo = JSON.hmGetNSDictionary(forKey: WebServiceConstants.result)
                        AppVariables.setDictUserDetail(dictUserInfo)
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
        
        
//        let arrValid = checkValidation()
//        if arrValid.count == 0 {
            //delegate?.personalInfoSelectedData(aboutMe: tvMoreAboutMe.text!, hashtags: tvHashtags.text!, languages: self.arrLanguages)
        //_ = self.navigationController?.popViewController(animated: true)
//        } else {
//            PopUpView.addValidationView(arrValid, strHeader: MessageStringFile.whoopsText(), strSubHeading: MessageStringFile.vInfoNeeded())
//        }
    }
    
    @IBAction func btnServices(_ sender: Any) {
        SelectionViewController.openSelectionViewController(selectionType: SelectionType.services, fromClass: .personalInfo, maxSelection: 1, shouldConfirmDelegate: true, inViewController: self, previouslySelectedData: self.arrServices)
    }
    
    //MARK: Selection Delegate
    
    func selectedData(selectionType: SelectionType, fromClass: FromClass, arrSelected: NSArray) {

        if selectionType == .services {
            if arrSelected.count > 0 {
                self.arrServices = arrSelected.mutableCopy() as! NSMutableArray
            }
        }
        var btnTitle = ""
        for i in 0 ..< self.arrServices.count {
            let dict = self.arrServices.hmNSDictionary(atIndex: i)
            let name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name).hm_UppercaseEveryWord
            if i == 0 {
                btnTitle = name
            } else {
                btnTitle = btnTitle + ", " + name
            }
        }
        
        if btnTitle == "" {
            if strUserType == WebServiceConstants.provider {
                btnTitle = MessageStringFile.typeOfServiceYouAreProviding()
            } else {
                btnTitle = MessageStringFile.typeOfServiceYouAreSeekingFor()
            }
            self.btnServices.setTitleColor(PredefinedConstants.darkGrayTextColor, for: UIControlState.normal)
        } else {
            self.btnServices.setTitleColor(UIColor.black, for: UIControlState.normal)
        }
        
        self.btnServices.setTitle(btnTitle, for: UIControlState.normal)
    }
    
    func selectionDidCancel() {
        
    }
    
    func showAlert(firstLblTitle: String, secondLblTitle: String){
        PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: firstLblTitle, secondLblTitle: secondLblTitle)
        PopUpView.sharedInstance.delegate = nil
    }
    
    func showSaveLoader(status: Bool) {
        if status {
            self.aviIndicator.color = UIColor.white
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: self.aviIndicator), animated: true)
            self.viewContainer.isUserInteractionEnabled = false
            self.navigationItem.setHidesBackButton(true, animated: true)
        } else {
            self.viewContainer.isUserInteractionEnabled = true
            self.navigationItem.setRightBarButton(self.btnNavigationSave, animated: true)
            self.navigationItem.setHidesBackButton(false, animated: true)
        }
    }
    
}
