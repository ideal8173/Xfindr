//
//  EditProfileViewController.swift
//  XFindr
//
//  Created by Rajat on 4/6/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SelectionDelegate, PopUpViewDelegate {

    @IBOutlet var svView: UIScrollView!
    
    @IBOutlet var viewProfileImage: UIView!
    @IBOutlet var viewName: UIView!
    
    @IBOutlet var btnProfile1: UIButton!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDOB: UILabel!
    @IBOutlet var tfName: UITextField!
    @IBOutlet var tfDOB: UITextField!
    @IBOutlet var lblChooseToAppear: UILabel!
    @IBOutlet var lblProvider: SMIconLabel!
    @IBOutlet var lblSeeker: SMIconLabel!
    @IBOutlet var aviIndicatorUserType: UIActivityIndicatorView!
    //@IBOutlet var imgProviderOrSeeker: UIImageView!
    @IBOutlet var viewUrgentRequirement: UIView!
    @IBOutlet var lblUrgentRequirement: UILabel!
    @IBOutlet var btnUrgentRequirementNo: UIButton!
    @IBOutlet var btnUrgentRequirementYes: UIButton!
    
    @IBOutlet var viewDetail: UIView!

    @IBOutlet var lblServicesTypeTxt: UILabel!
    @IBOutlet var lblServicesType: UILabel!

    @IBOutlet var lblAdditionalServicesTxt: UILabel!
    @IBOutlet var lblAdditionalServices: UILabel!
    
    @IBOutlet var lblAboutMeTxt: UILabel!
    @IBOutlet var lblAboutMe: UILabel!
    
    @IBOutlet var lblOtherServicesTxt: UILabel!
    @IBOutlet var lblOtherServices: UILabel!
    
    @IBOutlet var lblServicesTxt: UILabel!
    @IBOutlet var lblServices: UILabel!
    
    @IBOutlet var lblHashtagsTxt: UILabel!
    @IBOutlet var lblHashtags: UILabel!
    
    @IBOutlet var viewMobileNumber: UIView!
    @IBOutlet var lblShowMyNo: UILabel!
    @IBOutlet var lblMobileNo: UILabel!
    @IBOutlet var lblShowPhoneWarning: UILabel!
    @IBOutlet var lblRefuseAll: UILabel!
    @IBOutlet var switchRefuse: UISwitch!
    
    @IBOutlet var viewLanguage: UIView!
    @IBOutlet var lblLanguagesTxt: UILabel!
    @IBOutlet var lblLanguages: UILabel!
    
    @IBOutlet var viewImages: UIView!
    @IBOutlet var lblUploadPictures: UILabel!
    @IBOutlet var btnProfile2: UIButton!
    @IBOutlet var btnProfile3: UIButton!
    @IBOutlet var btnDeleteProfile2: UIButton!
    @IBOutlet var btnDeleteProfile3: UIButton!
    
    @IBOutlet var viewDatePicker: UIView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var btnBarSave: UIBarButtonItem!
    
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    @IBOutlet var aviIndicatorDelete2: UIActivityIndicatorView!
    @IBOutlet var aviIndicatorDelete3: UIActivityIndicatorView!

    var flagProfile1 = false
    var flagProfile2 = false
    var flagProfile3 = false
    var imagePicker: UIImagePickerController? = UIImagePickerController()
    var profileImagePickerType: ProfileImagePickerType = ProfileImagePickerType.profile1
    var strUserType = WebServiceConstants.seeker
    var urgentRequirement = WebServiceConstants.no
    var dictService = NSMutableDictionary()
    /*
    var arrProviderServices = NSMutableArray()
    var arrSeekerServices = NSMutableArray()
    var arrOtherServices = NSMutableArray()
    var arrServicesRequire = NSMutableArray()
    var arrServicesProvide = NSMutableArray()
    */
    var arrLanguages = NSMutableArray()
    var isFirstTime = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tfName.delegate = self
        tfDOB.delegate = self
        //if isFirstTime {
            self.showLoader(status: true)
        //}
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigation()
    }

    override func viewDidAppear(_ animated: Bool) {
        //if isFirstTime {
            //isFirstTime = false
            
            let now = Date()
            var maxYears = DateComponents()
            maxYears.year = -5
            
            let maxYearsAgo = NSCalendar.current.date(byAdding: maxYears, to: now)
            datePicker.maximumDate = maxYearsAgo
            
            
            var minYears = DateComponents()
            minYears.year = -100
            
            let minYearsAgo = NSCalendar.current.date(byAdding: minYears, to: now)
            datePicker.minimumDate = minYearsAgo
            
            tfDOB.inputView = self.viewDatePicker
            let tapOnViewSpecificServices = UITapGestureRecognizer(target: self, action: #selector(clickOnViewDetail(_:)))
            tapOnViewSpecificServices.numberOfTapsRequired = 1
            self.viewDetail.isUserInteractionEnabled = true
            self.viewDetail.addGestureRecognizer(tapOnViewSpecificServices)
            
            self.setupViewData()
            
            /*
            let tapOnViewSpecificServices = UITapGestureRecognizer(target: self, action: #selector(clickOnViewSpecificServices(_:)))
            tapOnViewSpecificServices.numberOfTapsRequired = 1
            self.viewSpecificServices.isUserInteractionEnabled = true
            self.viewSpecificServices.addGestureRecognizer(tapOnViewSpecificServices)
            
            let tapOnViewOtherServices = UITapGestureRecognizer(target: self, action: #selector(clickOnViewOtherServices(_:)))
            tapOnViewOtherServices.numberOfTapsRequired = 1
            self.viewOtherServices.isUserInteractionEnabled = true
            self.viewOtherServices.addGestureRecognizer(tapOnViewOtherServices)
            
            let tapOnViewServicesRequire = UITapGestureRecognizer(target: self, action: #selector(clickOnViewServicesRequire(_:)))
            tapOnViewServicesRequire.numberOfTapsRequired = 1
            self.viewServicesRequire.isUserInteractionEnabled = true
            self.viewServicesRequire.addGestureRecognizer(tapOnViewServicesRequire)
            
            let tapOnViewAboutMe = UITapGestureRecognizer(target: self, action: #selector(clickOnViewAboutMe(_:)))
            tapOnViewAboutMe.numberOfTapsRequired = 1
            self.viewAboutMe.isUserInteractionEnabled = true
            self.viewAboutMe.addGestureRecognizer(tapOnViewAboutMe)
            
            self.setupViewData()
 */
        //}
    }
    
    func showLoader(status: Bool) {
        if status {
            self.view.addSubview(self.aviIndicator)
            self.aviIndicator.center = self.view.center
            self.svView.alpha = 0.0
        } else {
            self.aviIndicator.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
                self.svView.alpha = 1.0
            })
        }
    }
    
    func clickOnViewDetail(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "segueEditProfilePersonalInfo", sender: nil)
    }
    
    /*
    
    func clickOnViewSpecificServices(_ sender: UITapGestureRecognizer) {
        SelectionViewController.openSelectionViewController(selectionType: SelectionType.specificServices, fromClass: FromClass.editProfile, maxSelection: 2, shouldConfirmDelegate: true, inViewController: self, previouslySelectedData: arrSpecificServices)
    }
    
    func clickOnViewOtherServices(_ sender: UITapGestureRecognizer) {
        SelectionViewController.openSelectionViewController(selectionType: SelectionType.otherServices, fromClass: FromClass.editProfile, maxSelection: 5, shouldConfirmDelegate: true, inViewController: self, previouslySelectedData: arrOtherServices)
    }
    
    func clickOnViewServicesRequire(_ sender: UITapGestureRecognizer) {
        
        let dictResponse = AppVariables.getDictUserDetail()
        let user_type = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.user_type).lowercased()
        if user_type.lowercased() == WebServiceConstants.seeker {
            SelectionViewController.openSelectionViewController(selectionType: SelectionType.requiredServices, fromClass: FromClass.editProfile, maxSelection: 2, shouldConfirmDelegate: true, inViewController: self, previouslySelectedData: arrServicesRequire)
        } else {
            SelectionViewController.openSelectionViewController(selectionType: SelectionType.provideServices, fromClass: FromClass.editProfile, maxSelection: 2, shouldConfirmDelegate: true, inViewController: self, previouslySelectedData: arrServicesProvide)
        }
    }
    
    func clickOnViewAboutMe(_ sender: UITapGestureRecognizer) {
        
        performSegue(withIdentifier: "segueEditProfilePersonalInfo", sender: nil)
        
        //SelectionViewController.openSelectionViewController(selectionType: SelectionType.specificServices, fromClass: FromClass.editProfile, maxSelection: 2, shouldConfirmDelegate: true, inViewController: self)
    }
    */
    func setupViewData() {
        
        btnProfile1.circleView(UIColor.clear, borderWidth: 0.0)
        let dictResponse = AppVariables.getDictUserDetail()
        
        print("dictResponse >>>>> \(dictResponse)")
        
        let profile1 = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.image1)
        let profile2 = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.image2)
        let profile3 = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.image3)
        
        if profile1.hm_Length > 0 {
            if let url = URL(string: "\(WebServiceLinks.userImageUrl())\(profile1)") {
                btnProfile1.sd_setImage(with: url, for: UIControlState.normal, placeholderImage: UIImage(), options: SDWebImageOptions.retryFailed)
            }
        }
        
        if profile2.hm_Length > 0 {
            if let url = URL(string: "\(WebServiceLinks.userImageUrl())\(profile2)") {
                btnProfile2.sd_setImage(with: url, for: UIControlState.normal, placeholderImage: UIImage(), options: SDWebImageOptions.retryFailed)
            }
        }
        
        if profile3.hm_Length > 0 {
            if let url = URL(string: "\(WebServiceLinks.userImageUrl())\(profile3)") {
                btnProfile3.sd_setImage(with: url, for: UIControlState.normal, placeholderImage: UIImage(), options: SDWebImageOptions.retryFailed)
            }
        }
        
        tfName.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.name)
        
        let dateOfBirth = AppVariables.getUserDateOfBirth()
        tfDOB.text = dateOfBirth
        
        let user_type = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.user_type).lowercased()
        if user_type == WebServiceConstants.provider.lowercased() {
            strUserType = WebServiceConstants.provider
        } else {
            strUserType = WebServiceConstants.seeker
        }
        self.switchUser()
        
        urgentRequirement = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.urgentRequirement)
        
        if urgentRequirement == "" {
            urgentRequirement = WebServiceConstants.no
        }
        self.setviewAccToUrgentReq()
        self.setupStaticStaticText()

        self.updateTextAccordingToUser(dictResponse: dictResponse)
        
        /*
        self.lblServicesType.backgroundColor = UIColor.red
        self.lblAdditionalServices.backgroundColor = UIColor.red
        self.lblAboutMe.backgroundColor = UIColor.red
        self.lblOtherServices.backgroundColor = UIColor.red
        self.lblServices.backgroundColor = UIColor.red
        self.lblHashtags.backgroundColor = UIColor.red
        */
        
        self.lblShowMyNo.text = MessageStringFile.showMyPhoneNumber()
        self.lblShowPhoneWarning.text = MessageStringFile.phoneNumberHideWarningMessage()
        self.lblRefuseAll.text = MessageStringFile.refuseAllCommercialApproach()
        
        self.lblLanguagesTxt.text = MessageStringFile.languagesSpoken()
        let funcLang = AppVariables.languages(arr: nil, dict: dictResponse)
        let languageKnown = funcLang.str
        self.arrLanguages = funcLang.arr.mutableCopy() as! NSMutableArray
        self.lblLanguages.text = languageKnown
        
        
        self.lblUploadPictures.text = MessageStringFile.uploadPicturesUpTo3()
        
        self.setupViewFrame()
        
        self.showLoader(status: false)
        
        dictService.hmSet(object: dictResponse.hmGetNSArray(forKey: WebServiceConstants.providerServices), forKey: WebServiceConstants.providerServices)
        dictService.hmSet(object: HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.providerNote), forKey: WebServiceConstants.providerNote)
        dictService.hmSet(object: HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.providerDesc), forKey: WebServiceConstants.providerDesc)
        dictService.hmSet(object: HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.providerOther), forKey: WebServiceConstants.providerOther)
        dictService.hmSet(object: HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.providerRequire), forKey: WebServiceConstants.providerRequire)
        dictService.hmSet(object: HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.providerHashtag), forKey: WebServiceConstants.providerHashtag)
        
        dictService.hmSet(object: dictResponse.hmGetNSArray(forKey: WebServiceConstants.seekerServices), forKey: WebServiceConstants.seekerServices)
        dictService.hmSet(object: HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.seekerNote), forKey: WebServiceConstants.seekerNote)
        dictService.hmSet(object: HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.seekerDesc), forKey: WebServiceConstants.seekerDesc)
        dictService.hmSet(object: HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.seekerOther), forKey: WebServiceConstants.seekerOther)
        dictService.hmSet(object: HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.seekerProvide), forKey: WebServiceConstants.seekerProvide)
        dictService.hmSet(object: HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.seekerHashtag), forKey: WebServiceConstants.seekerHashtag)

        
        /*
        btnProfile1.circleView(UIColor.clear, borderWidth: 0.0)
        let dictResponse = AppVariables.getDictUserDetail()
        
        print("dictResponse >>>>> \(dictResponse)")
        
        let profile1 = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.image1)
        let profile2 = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.image2)
        let profile3 = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.image3)
        
        if profile1.hm_Length > 0 {
            if let url = URL(string: "\(WebServiceLinks.userImageUrl())\(profile1)") {
                btnProfile1.sd_setImage(with: url, for: UIControlState.normal, placeholderImage: UIImage(), options: SDWebImageOptions.retryFailed)
            }
        }
        
        if profile2.hm_Length > 0 {
            if let url = URL(string: "\(WebServiceLinks.userImageUrl())\(profile2)") {
                btnProfile2.sd_setImage(with: url, for: UIControlState.normal, placeholderImage: UIImage(), options: SDWebImageOptions.retryFailed)
            }
        }
        
        if profile3.hm_Length > 0 {
            if let url = URL(string: "\(WebServiceLinks.userImageUrl())\(profile3)") {
                btnProfile3.sd_setImage(with: url, for: UIControlState.normal, placeholderImage: UIImage(), options: SDWebImageOptions.retryFailed)
            }
        }
        
        
        tfName.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.name)
        
        let dateOfBirth = AppVariables.getUserDateOfBirth()
        tfDOB.text = dateOfBirth
        
        let user_type = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.user_type).lowercased()
        if user_type == WebServiceConstants.provider.lowercased() {
            strUserType = WebServiceConstants.provider
        } else {
            strUserType = WebServiceConstants.seeker
        }
        
        urgentRequirement = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.urgentRequirement)
        if urgentRequirement != "" {
            urgentRequirement = WebServiceConstants.no
        }
        self.setviewAccToUrgentReq()
        
        var specificServices = MessageStringFile.specificServicesOrSkillsThatYouAreSeeking() + MessageStringFile.colonSymbol()
        var otherServices = MessageStringFile.otherServicesOrSkillsThatYouMaySeekFor() + MessageStringFile.colonSymbol()
        if strUserType == WebServiceConstants.provider {
            specificServices = MessageStringFile.specificServicesOrSkillsThatYouProvide() + MessageStringFile.colonSymbol()
            otherServices = MessageStringFile.otherServicesOrSkillsThatYouCanProvide() + MessageStringFile.colonSymbol()
        }
        
        //SpecificServices
        lblSpecificServicesText.text = specificServices
        lblSpecificServicesText.numberOfLines = 0
        lblSpecificServicesText.lineBreakMode = .byWordWrapping
        lblSpecificServicesText.sizeToFit()
        lblSpecificServices.frame.origin.y = lblSpecificServicesText.frame.origin.y + lblSpecificServicesText.frame.size.height + 5
        
        let funcServ = AppVariables.services(arr: nil, dict: dictResponse)
        let services = funcServ.str
        self.arrSpecificServices = funcServ.arr.mutableCopy() as! NSMutableArray
        
        lblSpecificServices.text = services
        lblSpecificServices.numberOfLines = 0
        lblSpecificServices.lineBreakMode = .byWordWrapping
        lblSpecificServices.sizeToFit()
        viewSpecificServices.frame.size.height = lblSpecificServices.frame.origin.y + lblSpecificServices.frame.size.height + 10
        if let vw = viewSpecificServices.viewWithTag(100) {
            vw.center.y = viewSpecificServices.center.y
        }
        
        //OtherServices
        viewOtherServices.frame.origin.y = viewSpecificServices.frame.origin.y + viewSpecificServices.frame.size.height
        lblOtherServicesTxt.text = otherServices
        lblOtherServicesTxt.numberOfLines = 0
        lblOtherServicesTxt.lineBreakMode = .byWordWrapping
        lblOtherServicesTxt.sizeToFit()
        lblOtherServices.frame.origin.y = lblOtherServicesTxt.frame.origin.y + lblOtherServicesTxt.frame.size.height + 5
        
        let funcOthServ = AppVariables.otherServices(arr: nil, dict: dictResponse)
        let other = funcOthServ.str
        self.arrOtherServices = funcOthServ.arr.mutableCopy() as! NSMutableArray
        
        lblOtherServices.text = other
        lblOtherServices.numberOfLines = 0
        lblOtherServices.lineBreakMode = .byWordWrapping
        lblOtherServices.sizeToFit()
        viewOtherServices.frame.size.height = lblOtherServices.frame.origin.y + lblOtherServices.frame.size.height + 10
        if let vw = viewOtherServices.viewWithTag(101) {
            vw.frame.origin.y = (viewOtherServices.frame.size.height * 0.5) - (vw.frame.size.height * 0.5)
        }
        
        //ServicesRequire
        viewServicesRequire.frame.origin.y = viewOtherServices.frame.origin.y + viewOtherServices.frame.size.height
        
        var requirement = ""
        if user_type.lowercased() == WebServiceConstants.seeker {
            lblServicesRequireTxt.text = MessageStringFile.servicesOrSkillsThatYouMayRequire() + MessageStringFile.colonSymbol()
            let funcServReq = AppVariables.servicesRequired(arr: nil, dict: dictResponse)
            requirement = funcServReq.str
            self.arrServicesRequire = funcServReq.arr.mutableCopy() as! NSMutableArray
            
            /*
            requirement = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.serviceProvide)
            if requirement == "" {
                let arr = dictResponse.hmGetNSArray(forKey: WebServiceConstants.serviceProvide)
                if arr.count > 0 {
                    requirement = arr.componentsJoined(by: ", ")
                    arrServicesProvide = arr.mutableCopy() as! NSMutableArray
                }
            }
            */
        } else {
            
            lblServicesRequireTxt.text = MessageStringFile.servicesOrSkillsThatYouMayProvide() + MessageStringFile.colonSymbol()
            
            let funcServPro = AppVariables.servicesProvide(arr: nil, dict: dictResponse)
            requirement = funcServPro.str
            self.arrServicesProvide = funcServPro.arr.mutableCopy() as! NSMutableArray
            
            /*
            requirement = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.serviceRequirement)
            if requirement == "" {
                let arr = dictResponse.hmGetNSArray(forKey: WebServiceConstants.serviceRequirement)
                if arr.count > 0 {
                    requirement = arr.componentsJoined(by: ", ")
                    arrServicesRequire = arr.mutableCopy() as! NSMutableArray
                }
            }
 */
        }
        
        if requirement == "" {
            requirement = MessageStringFile.notAvailable()
        }
        
        lblServicesRequireTxt.numberOfLines = 0
        lblServicesRequireTxt.lineBreakMode = .byWordWrapping
        lblServicesRequireTxt.sizeToFit()
        lblServicesRequire.frame.origin.y = lblServicesRequireTxt.frame.origin.y + lblServicesRequireTxt.frame.size.height + 5
        
        lblServicesRequire.numberOfLines = 0
        lblServicesRequire.text = requirement
        lblServicesRequire.lineBreakMode = .byWordWrapping
        lblServicesRequire.sizeToFit()
        viewServicesRequire.frame.size.height = lblServicesRequire.frame.origin.y + lblServicesRequire.frame.size.height + 10
        
        if let vw = viewServicesRequire.viewWithTag(102) {
            vw.frame.origin.y = (viewServicesRequire.frame.size.height * 0.5) - (vw.frame.size.height * 0.5)
        }
        
        //AboutMe
        viewAboutMe.frame.origin.y = viewServicesRequire.frame.origin.y + viewServicesRequire.frame.size.height
        lblAboutMeTxt.text = MessageStringFile.moreAboutMe() + MessageStringFile.colonSymbol()
        lblAboutMeTxt.numberOfLines = 0
        lblAboutMeTxt.lineBreakMode = .byWordWrapping
        lblAboutMeTxt.sizeToFit()
        lblAboutMe.frame.origin.y = lblAboutMeTxt.frame.origin.y + lblAboutMeTxt.frame.size.height + 5
        
        var description = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.description)
        
        if description == "" {
            description = MessageStringFile.notAvailable()
        }
        
        lblAboutMe.text = description
        lblAboutMe.numberOfLines = 0
        lblAboutMe.lineBreakMode = .byWordWrapping
        lblAboutMe.sizeToFit()
        
        lblHashtagsTxt.frame.origin.y = lblAboutMe.frame.origin.y + lblAboutMe.frame.size.height + 10
        lblHashtagsTxt.text = MessageStringFile.hashtags() + MessageStringFile.colonSymbol()
        lblHashtagsTxt.numberOfLines = 0
        lblHashtagsTxt.lineBreakMode = .byWordWrapping
        lblHashtagsTxt.sizeToFit()
        lblHashtags.frame.origin.y = lblHashtagsTxt.frame.origin.y + lblHashtagsTxt.frame.size.height + 5
        
        
        var hashtags = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.hashtags)
        if hashtags == "" {
            let arr = dictResponse.hmGetNSArray(forKey: WebServiceConstants.hashtags)
            if arr.count > 0 {
                hashtags = arr.componentsJoined(by: "# ")
            }
        }
        if hashtags == "" {
            hashtags = MessageStringFile.notAvailable()
        }
        
        lblHashtags.text = hashtags
        lblHashtags.numberOfLines = 0
        lblHashtags.lineBreakMode = .byWordWrapping
        lblHashtags.sizeToFit()
        
        lblLanguagesTxt.frame.origin.y = lblHashtags.frame.origin.y + lblHashtags.frame.size.height + 10
        lblLanguagesTxt.text = MessageStringFile.languages() + MessageStringFile.colonSymbol()
        lblLanguagesTxt.numberOfLines = 0
        lblLanguagesTxt.lineBreakMode = .byWordWrapping
        lblLanguagesTxt.sizeToFit()
        lblLanguages.frame.origin.y = lblLanguagesTxt.frame.origin.y + lblLanguagesTxt.frame.size.height + 5
        
//        var languageKnown = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.languageKnown)
//        if languageKnown == "" {
//            let arrLanguageKnown = dictResponse.hmGetNSArray(forKey: WebServiceConstants.languageKnown)
//            self.arrLanguages = arrLanguageKnown.mutableCopy() as! NSMutableArray
//            if arrLanguageKnown.count > 0 {
//                languageKnown = arrLanguageKnown.componentsJoined(by: ", ")
//            }
//        }
//        if languageKnown == "" {
//            languageKnown = MessageStringFile.notAvailable()
//        }
        
        let funcLang = AppVariables.languages(arr: nil, dict: dictResponse)
        let languageKnown = funcLang.str
        self.arrLanguages = funcLang.arr.mutableCopy() as! NSMutableArray
        
        lblLanguages.text = languageKnown
        lblLanguages.lineBreakMode = .byWordWrapping
        lblLanguages.sizeToFit()
        
        
        viewAboutMe.frame.size.height = lblLanguages.frame.origin.y + lblLanguages.frame.size.height + 10
        
        if let vw = viewAboutMe.viewWithTag(103) {
            vw.frame.origin.y = (viewAboutMe.frame.size.height * 0.5) - (vw.frame.size.height * 0.5)
        }
        
        //Upload Image
        lblUploadPictures.frame.origin.y = viewAboutMe.frame.origin.y + viewAboutMe.frame.size.height + 10
        btnProfile2.frame.origin.y = lblUploadPictures.frame.origin.y + lblUploadPictures.frame.size.height + 10
        btnProfile3.frame.origin.y = lblUploadPictures.frame.origin.y + lblUploadPictures.frame.size.height + 10
        btnDeleteProfile2.frame.origin.y = btnProfile2.frame.origin.y
        btnDeleteProfile3.frame.origin.y = btnProfile3.frame.origin.y
        
        btnDeleteProfile2.setImage(UIImage(named: "trash_icon")?.hmMaskWith(color: PredefinedConstants.redColor), for: UIControlState.normal)
        btnDeleteProfile3.setImage(UIImage(named: "trash_icon")?.hmMaskWith(color: PredefinedConstants.redColor), for: UIControlState.normal)
        
        if profile2.hm_Length > 0 {
            btnDeleteProfile2.isHidden = false
        } else {
            btnDeleteProfile2.isHidden = true
        }
        
        if profile3.hm_Length > 0 {
            btnDeleteProfile3.isHidden = false
        } else {
            btnDeleteProfile3.isHidden = true
        }
        
        viewDetail.frame.size.height = btnProfile3.frame.origin.y + btnProfile3.frame.size.height + 10
        
        svView.contentSize = CGSize(width: 0.0, height: viewDetail.frame.origin.y + viewDetail.frame.size.height + 50)
        self.showLoader(status: false)
 */
    }
    
    func updateTextAccordingToUser(dictResponse: NSDictionary) {
        var serviceType = ""
        var serviceNote = ""
        var about = ""
        var other = ""
        var serviceMay = ""
        var hashtags = ""
        if strUserType == WebServiceConstants.provider {
            serviceType = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.providerServices)
            if serviceType == "" {
                serviceType = AppVariables.services(arr: dictResponse.hmGetNSArray(forKey: WebServiceConstants.providerServices), dict: nil).str
            }
            serviceNote = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.providerNote)
            about = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.providerDesc)
            other = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.providerOther)
            serviceMay = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.providerRequire)
            hashtags = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.providerHashtag)
        } else {
            serviceType = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.seekerServices)
            if serviceType == "" {
                serviceType = AppVariables.services(arr: dictResponse.hmGetNSArray(forKey: WebServiceConstants.seekerServices), dict: nil).str
            }
            serviceNote = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.seekerNote)
            about = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.seekerDesc)
            other = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.seekerOther)
            serviceMay = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.seekerProvide)
            hashtags = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.seekerHashtag)
        }
        
        
        if serviceType.hm_Length == 0 {
            serviceType = MessageStringFile.notAvailable()
        }
        
        if serviceNote.hm_Length == 0 {
            serviceNote = MessageStringFile.notAvailable()
        }
        
        if about.hm_Length == 0 {
            about = MessageStringFile.notAvailable()
        }
        
        if other.hm_Length == 0 {
            other = MessageStringFile.notAvailable()
        }
        
        if serviceMay.hm_Length == 0 {
            serviceMay = MessageStringFile.notAvailable()
        }
        
        if hashtags.hm_Length == 0 {
            hashtags = MessageStringFile.notAvailable()
        }
        
        
        
        self.lblServicesType.text = serviceType
        self.lblAdditionalServices.text = serviceNote
        self.lblAboutMe.text = about
        self.lblOtherServices.text = other
        self.lblServices.text = serviceMay
        self.lblHashtags.text = hashtags
    }
    
    func setupStaticStaticText() {
        let font = PredefinedConstants.appFont(size: 12.0)
        let color = UIColor.lightGray
        
        if strUserType == WebServiceConstants.provider {
            self.lblServicesTypeTxt.text = MessageStringFile.typeOfServiceYouAreProviding()
            self.lblAdditionalServicesTxt.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.whatAreYouProviding(), stringToColor: " (50 " + "\(MessageStringFile.characters()))", font: PredefinedConstants.appFont(size: 12.0), color: color)
            self.lblAboutMeTxt.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.profileTitle(), stringToColor: " (500 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblOtherServicesTxt.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.otherServicesYouMayProvide(), stringToColor: " \(MessageStringFile.optional()) (50 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblServicesTxt.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.servicesYouMayRequire(), stringToColor: " \(MessageStringFile.optional()) (50 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblHashtagsTxt.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.hashtagswithHash(), stringToColor: " \(MessageStringFile.optional())", font: font, color: color)
        } else {
            self.lblServicesTypeTxt.text = MessageStringFile.typeOfServiceYouAreSeekingFor()
            self.lblAdditionalServicesTxt.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.whatAreYouSeeking(), stringToColor: " (50 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblAboutMeTxt.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.profileTitle(), stringToColor: " (500 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblOtherServicesTxt.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.otherServicesYouMayRequire(), stringToColor: " \(MessageStringFile.optional()) (50 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblServicesTxt.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.servicesYouMayProvide(), stringToColor: " \(MessageStringFile.optional()) (50 \(MessageStringFile.characters()))", font: font, color: color)
            self.lblHashtagsTxt.attributedText = HelperClass.createAttributedString(mainString: MessageStringFile.hashtagswithHash(), stringToColor: " \(MessageStringFile.optional())", font: font, color: color)
        }
        
        /*
        if strUserType == WebServiceConstants.provider {
            self.lblServicesTypeTxt.text = MessageStringFile.typeOfServiceYouAreProviding()
            self.lblAdditionalServicesTxt.text = MessageStringFile.whatAreYouProviding() + "(30 " + "\(MessageStringFile.characters()))"
            self.lblAboutMeTxt.text = MessageStringFile.moreAboutWhatYouProvide() + "(500 " + "\(MessageStringFile.characters()))"
            self.lblOtherServicesTxt.text = MessageStringFile.otherServicesYouMayProvide() + " " + MessageStringFile.optional() + "(50 " + "\(MessageStringFile.characters()))"
            self.lblServicesTxt.text = MessageStringFile.servicesYouMayRequire() + " " + MessageStringFile.optional() + "(50 " + "\(MessageStringFile.characters()))"
            self.lblHashtagsTxt.text = MessageStringFile.hashtagswithHash() + " " + MessageStringFile.optional()
        } else {
            self.lblServicesTypeTxt.text = MessageStringFile.typeOfServiceYouAreSeekingFor()
            self.lblAdditionalServicesTxt.text = MessageStringFile.whatAreYouSeeking() + "(30 " + "\(MessageStringFile.characters()))"
            self.lblAboutMeTxt.text = MessageStringFile.moreAboutWhatYouRequire() + "(500 " + "\(MessageStringFile.characters()))"
            self.lblOtherServicesTxt.text = MessageStringFile.otherServicesYouMayRequire() + " " + MessageStringFile.optional() + "(50 " + "\(MessageStringFile.characters()))"
            self.lblServicesTxt.text = MessageStringFile.servicesYouMayProvide() + " " + MessageStringFile.optional() + "(50 " + "\(MessageStringFile.characters()))"
            self.lblHashtagsTxt.text = MessageStringFile.hashtagswithHash() + " " + MessageStringFile.optional()
        }
        */
    }
    
    func getCombinedString(strTitle : String, strValue : String, setColor : UIColor, setFontSize : CGFloat) -> NSAttributedString {
        let RequestDateAttributedString = NSMutableAttributedString(string:strTitle)
        let attrs = [NSForegroundColorAttributeName : setColor,NSFontAttributeName : UIFont.systemFont(ofSize: setFontSize)]
        let gRequestDateString = NSMutableAttributedString(string:strValue, attributes:attrs)
        RequestDateAttributedString.append(gRequestDateString)
        return RequestDateAttributedString
    }
    
    func setupViewFrame() {
        
        self.lblServicesTypeTxt.frame.size.width = self.viewDetail.frame.size.width - 44.0
        self.lblServicesTypeTxt.sizeToFit()
        self.lblServicesType.frame.size.width = self.viewDetail.frame.size.width - 44.0
        self.lblServicesTypeTxt.sizeToFit()
        
        let lblWidth = self.viewDetail.frame.size.width - 16.0
        
        self.lblAdditionalServicesTxt.frame.size.width = lblWidth
        self.lblAdditionalServicesTxt.sizeToFit()
        self.lblAboutMeTxt.frame.size.width = lblWidth
        self.lblAboutMeTxt.sizeToFit()
        self.lblOtherServicesTxt.frame.size.width = lblWidth
        self.lblOtherServicesTxt.sizeToFit()
        self.lblServicesTxt.frame.size.width = lblWidth
        self.lblServicesTxt.sizeToFit()
        self.lblHashtagsTxt.frame.size.width = lblWidth
        self.lblHashtagsTxt.sizeToFit()
        
        self.lblAdditionalServices.frame.size.width = lblWidth
        self.lblAdditionalServices.sizeToFit()
        self.lblAboutMe.frame.size.width = lblWidth
        self.lblAboutMe.sizeToFit()
        self.lblOtherServices.frame.size.width = lblWidth
        self.lblOtherServices.sizeToFit()
        self.lblServices.frame.size.width = lblWidth
        self.lblServices.sizeToFit()
        self.lblHashtags.frame.size.width = lblWidth
        self.lblHashtags.sizeToFit()
        
        let joinPadding: CGFloat = 5.0
        let differencePadding: CGFloat = 15.0
        
        self.lblServicesType.frame.origin.y = self.lblServicesTypeTxt.frame.origin.y + self.lblServicesTypeTxt.frame.size.height + joinPadding
        
        self.lblAdditionalServicesTxt.frame.origin.y = self.lblServicesType.frame.origin.y + self.lblServicesType.frame.size.height + differencePadding
        self.lblAdditionalServices.frame.origin.y = self.lblAdditionalServicesTxt.frame.origin.y + self.lblAdditionalServicesTxt.frame.size.height + joinPadding
        
        self.lblAboutMeTxt.frame.origin.y = self.lblAdditionalServices.frame.origin.y + self.lblAdditionalServices.frame.size.height + differencePadding
        self.lblAboutMe.frame.origin.y = self.lblAboutMeTxt.frame.origin.y + self.lblAboutMeTxt.frame.size.height + joinPadding
        
        self.lblOtherServicesTxt.frame.origin.y = self.lblAboutMe.frame.origin.y + self.lblAboutMe.frame.size.height + differencePadding
        self.lblOtherServices.frame.origin.y = self.lblOtherServicesTxt.frame.origin.y + self.lblOtherServicesTxt.frame.size.height + joinPadding
        
        self.lblServicesTxt.frame.origin.y = self.lblOtherServices.frame.origin.y + self.lblOtherServices.frame.size.height + differencePadding
        self.lblServices.frame.origin.y = self.lblServicesTxt.frame.origin.y + self.lblServicesTxt.frame.size.height + joinPadding
        
        self.lblHashtagsTxt.frame.origin.y = self.lblServices.frame.origin.y + self.lblServices.frame.size.height + differencePadding
        self.lblHashtags.frame.origin.y = self.lblHashtagsTxt.frame.origin.y + self.lblHashtagsTxt.frame.size.height + joinPadding
        
        self.viewDetail.frame.size.height = self.lblHashtags.frame.origin.y + self.lblHashtags.frame.size.height + differencePadding - joinPadding
        
        self.viewMobileNumber.frame.origin.y = self.viewDetail.frame.origin.y + self.viewDetail.frame.size.height + 10.0
        self.lblShowMyNo.frame.size.width = (self.viewMobileNumber.frame.size.width * 0.5) - 5.0
        self.lblShowMyNo.sizeToFit()
        
        self.lblMobileNo.frame.size.width = (self.viewMobileNumber.frame.size.width * 0.5) - 5.0
        self.lblMobileNo.sizeToFit()

        let warningLabelY = self.lblMobileNo.frame.size.height > self.lblShowMyNo.frame.size.height ? self.lblMobileNo.frame.size.height : self.lblShowMyNo.frame.size.height
        
        self.lblShowPhoneWarning.frame.origin.y = warningLabelY + 15.0
        self.lblShowPhoneWarning.frame.size.width = lblWidth
        self.lblShowPhoneWarning.sizeToFit()
        
        self.lblRefuseAll.frame.origin.y = self.lblShowPhoneWarning.frame.origin.y + self.lblShowPhoneWarning.frame.size.height + 5.0
        self.lblRefuseAll.frame.size.width = self.viewMobileNumber.frame.size.width - 60.0
        self.lblRefuseAll.sizeToFit()
        
        self.switchRefuse.frame.origin.y = self.lblShowPhoneWarning.frame.origin.y + self.lblShowPhoneWarning.frame.size.height + 5.0
        
        let height = self.lblRefuseAll.frame.size.height > self.switchRefuse.frame.size.height ? self.lblRefuseAll.frame.size.height : self.switchRefuse.frame.size.height
        
        self.viewMobileNumber.frame.size.height = self.lblRefuseAll.frame.origin.y + height + 10.0
        
        self.viewLanguage.frame.origin.y = self.viewMobileNumber.frame.origin.y + self.viewMobileNumber.frame.size.height + 10.0
        self.lblLanguagesTxt.frame.size.width = lblWidth
        self.lblLanguagesTxt.sizeToFit()
        self.lblLanguages.frame.size.width = lblWidth
        self.lblLanguages.sizeToFit()
        self.viewLanguage.frame.size.height = self.lblLanguages.frame.origin.y + self.lblLanguages.frame.size.height + 10.0
        
        self.viewImages.frame.origin.y = self.viewLanguage.frame.origin.y + self.viewLanguage.frame.size.height + 10.0
        self.svView.contentSize = CGSize(width: 0.0, height: self.viewImages.frame.origin.y + self.viewImages.frame.size.height + 50)
        /*
        //SpecificServices
        lblSpecificServices.frame.origin.y = lblSpecificServicesText.frame.origin.y + lblSpecificServicesText.frame.size.height + 5
        viewSpecificServices.frame.size.height = lblSpecificServices.frame.origin.y + lblSpecificServices.frame.size.height + 10
        if let vw = viewSpecificServices.viewWithTag(100) {
            vw.center.y = viewSpecificServices.center.y
        }
        //OtherServices
        viewOtherServices.frame.origin.y = viewSpecificServices.frame.origin.y + viewSpecificServices.frame.size.height
        lblOtherServices.frame.origin.y = lblOtherServicesTxt.frame.origin.y + lblOtherServicesTxt.frame.size.height + 5
        viewOtherServices.frame.size.height = lblOtherServices.frame.origin.y + lblOtherServices.frame.size.height + 10
        if let vw = viewOtherServices.viewWithTag(101) {
            vw.frame.origin.y = (viewOtherServices.frame.size.height * 0.5) - (vw.frame.size.height * 0.5)
        }
        //ServicesRequire
        viewServicesRequire.frame.origin.y = viewOtherServices.frame.origin.y + viewOtherServices.frame.size.height
        lblServicesRequire.frame.origin.y = lblServicesRequireTxt.frame.origin.y + lblServicesRequireTxt.frame.size.height + 5
        viewServicesRequire.frame.size.height = lblServicesRequire.frame.origin.y + lblServicesRequire.frame.size.height + 10
        if let vw = viewServicesRequire.viewWithTag(102) {
            vw.frame.origin.y = (viewServicesRequire.frame.size.height * 0.5) - (vw.frame.size.height * 0.5)
        }
        viewAboutMe.frame.origin.y = viewServicesRequire.frame.origin.y + viewServicesRequire.frame.size.height
        lblAboutMe.frame.origin.y = lblAboutMeTxt.frame.origin.y + lblAboutMeTxt.frame.size.height + 5
        
        lblHashtagsTxt.frame.origin.y = lblAboutMe.frame.origin.y + lblAboutMe.frame.size.height + 10
        lblHashtags.frame.origin.y = lblHashtagsTxt.frame.origin.y + lblHashtagsTxt.frame.size.height + 5
        lblLanguagesTxt.frame.origin.y = lblHashtags.frame.origin.y + lblHashtags.frame.size.height + 10
        lblLanguages.frame.origin.y = lblLanguagesTxt.frame.origin.y + lblLanguagesTxt.frame.size.height + 5
        viewAboutMe.frame.size.height = lblLanguages.frame.origin.y + lblLanguages.frame.size.height + 10
        if let vw = viewAboutMe.viewWithTag(103) {
            vw.frame.origin.y = (viewAboutMe.frame.size.height * 0.5) - (vw.frame.size.height * 0.5)
        }
        //Upload Image
        lblUploadPictures.frame.origin.y = viewAboutMe.frame.origin.y + viewAboutMe.frame.size.height + 10
        btnProfile2.frame.origin.y = lblUploadPictures.frame.origin.y + lblUploadPictures.frame.size.height + 10
        btnProfile3.frame.origin.y = lblUploadPictures.frame.origin.y + lblUploadPictures.frame.size.height + 10
        
        viewDetail.frame.size.height = btnProfile3.frame.origin.y + btnProfile3.frame.size.height + 10
        btnDeleteProfile2.frame.origin.y = btnProfile2.frame.origin.y
        btnDeleteProfile3.frame.origin.y = btnProfile3.frame.origin.y
        
        svView.contentSize = CGSize(width: 0.0, height: viewDetail.frame.origin.y + viewDetail.frame.size.height + 50)
 */
    }
    
    func setNavigation() {
//        self.navigationController?.navigationBar.isTranslucent = false;
//        self.navigationController?.navigationBar.tintColor = UIColor.white
//        self.navigationController?.navigationBar.barTintColor = PredefinedConstants.navigationColor
//        self.navigationController?.navigationBar.barStyle = UIBarStyle.blackTranslucent
//        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
//        self.navigationController!.navigationBar.titleTextAttributes = titleDict as? [String : AnyObject]
        self.title = ClassesHeader.editProfile()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    
    func openImagePicker(profileImagePickerType: ProfileImagePickerType) {
        self.view.endEditing(true)
        
        self.profileImagePickerType = profileImagePickerType
        
        let alert: UIAlertController = UIAlertController(title: MessageStringFile.chooseImage(), message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: MessageStringFile.camera(), style: UIAlertActionStyle.default)  {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: MessageStringFile.gallery(), style: UIAlertActionStyle.default)  {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: MessageStringFile.cancel(), style: UIAlertActionStyle.cancel)  {
            UIAlertAction in
        }

        imagePicker?.delegate = self
        imagePicker?.allowsEditing = true
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)

        if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(alert, animated: true, completion: nil)
        } else {
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfName {
            let validCharacterSet = NSCharacterSet(charactersIn: ValidatorClasses.NameAcceptableCharacter).inverted
            let filter = string.components(separatedBy: validCharacterSet)
            if filter.count == 1 {
                let newLength = (textField.text?.characters.count)! + string.characters.count - range.length
                return (newLength > 120) ? false : true
            } else {
                return false
            }
        }
        return true
    }
    
    // MARK: - Button Action

    @IBAction func btnDeleteProfile2(_ sender: Any) {
        
        let actionSheetController = UIAlertController(title: MessageStringFile.deleteConfirmation(), message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: MessageStringFile.cancel(), style: .cancel) { action -> Void in
            
        }
        
        let saveActionButton = UIAlertAction(title: MessageStringFile.doneText(), style: .default) { action -> Void in
            if AppVariables.getString(forKey: WebServiceConstants.image2).hm_Length > 0 {
                self.deleteImage(imageName: WebServiceConstants.image2)
            } else {
                self.btnProfile2.setImage(UIImage(named: "add_icon"), for: UIControlState.normal)
                self.flagProfile2 = false
                self.btnDeleteProfile2.isHidden = true
            }
        }
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(saveActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteProfile3(_ sender: Any) {
        
        let actionSheetController = UIAlertController(title: MessageStringFile.deleteConfirmation(), message: nil, preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: MessageStringFile.cancel(), style: .cancel) { action -> Void in
            
        }
        
        let saveActionButton = UIAlertAction(title: MessageStringFile.doneText(), style: .default) { action -> Void in
            if AppVariables.getString(forKey: WebServiceConstants.image3).hm_Length > 0 {
                self.deleteImage(imageName: WebServiceConstants.image3)
            } else {
                self.btnProfile3.setImage(UIImage(named: "add_icon"), for: UIControlState.normal)
                self.flagProfile3 = false
                self.btnDeleteProfile3.isHidden = true
            }
        }
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(saveActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
        
    }
    
    @IBAction func btnProfile1(_ sender: Any) {
        self.openImagePicker(profileImagePickerType: ProfileImagePickerType.profile1)
    }
    
    @IBAction func btnProfile2(_ sender: Any) {
        self.openImagePicker(profileImagePickerType: ProfileImagePickerType.profile2)
    }
    
    @IBAction func btnProfile3(_ sender: Any) {
        self.openImagePicker(profileImagePickerType: ProfileImagePickerType.profile3)
    }
    
    @IBAction func btnProvider(_ sender: Any) {
        /*
        strUserType = WebServiceConstants.provider
        self.urgentRequirement = WebServiceConstants.no
        self.setviewAccToUrgentReq()
        
        let lblWidth = self.viewDetail.frame.size.width - 44.0
        let specificServices = MessageStringFile.specificServicesOrSkillsThatYouProvide() + MessageStringFile.colonSymbol()
        let otherServices = MessageStringFile.otherServicesOrSkillsThatYouCanProvide() + MessageStringFile.colonSymbol()

        lblSpecificServicesText.text = specificServices
        lblSpecificServicesText.frame.size.width = lblWidth
        lblSpecificServicesText.sizeToFit()
        
        lblOtherServicesTxt.text = otherServices
        lblOtherServicesTxt.frame.size.width = lblWidth
        lblOtherServicesTxt.sizeToFit()
        lblServicesRequireTxt.text = MessageStringFile.servicesOrSkillsThatYouMayProvide() + MessageStringFile.colonSymbol()

        lblServicesRequireTxt.frame.size.width = lblWidth
        lblServicesRequireTxt.sizeToFit()
        
        self.lblServicesRequire.text = AppVariables.servicesProvide(arr: self.arrServicesProvide, dict: nil).str
        self.lblServicesRequire.frame.size.width = lblWidth
        self.lblServicesRequire.sizeToFit()
        
        self.setupViewFrame()
 */
        if self.strUserType == WebServiceConstants.provider {
            return
        }
        
        
        self.updateUserType(userType: WebServiceConstants.provider, urgentRequirement: self.urgentRequirement)
    }
    
    @IBAction func btnSeeker(_ sender: Any) {
        /*
        strUserType = WebServiceConstants.seeker
        self.setviewAccToUrgentReq()
        
        let lblWidth = self.viewDetail.frame.size.width - 44.0
        
        let specificServices = MessageStringFile.specificServicesOrSkillsThatYouAreSeeking() + MessageStringFile.colonSymbol()
        let otherServices = MessageStringFile.otherServicesOrSkillsThatYouMaySeekFor() + MessageStringFile.colonSymbol()

        lblSpecificServicesText.text = specificServices
        lblSpecificServicesText.frame.size.width = lblWidth
        lblSpecificServicesText.sizeToFit()
        
        lblOtherServicesTxt.text = otherServices
        lblOtherServicesTxt.frame.size.width = lblWidth
        lblOtherServicesTxt.sizeToFit()
        lblServicesRequireTxt.text = MessageStringFile.servicesOrSkillsThatYouMayRequire() + MessageStringFile.colonSymbol()
        lblServicesRequireTxt.frame.size.width = lblWidth
        lblServicesRequireTxt.sizeToFit()
        
        self.lblServicesRequire.text = AppVariables.servicesRequired(arr: self.arrServicesRequire, dict: nil).str
        self.lblServicesRequire.frame.size.width = lblWidth
        self.lblServicesRequire.sizeToFit()
        
        
        self.setupViewFrame()
     */
        if self.strUserType == WebServiceConstants.seeker {
            return
        }
        self.updateUserType(userType: WebServiceConstants.seeker, urgentRequirement: self.urgentRequirement)
    }
    
    func switchUser() {
        let user_type = strUserType.lowercased()
        if user_type == WebServiceConstants.provider.lowercased() {
            self.lblProvider.icon = UIImage(named: "correct_ic")
            self.lblProvider.text = MessageStringFile.provider()
            self.lblProvider.iconPadding = 2
            self.lblProvider.iconPosition = ( .left, .top )
            self.lblSeeker.icon = nil
            self.lblSeeker.text = MessageStringFile.seeker()
        } else {
            self.lblSeeker.icon = UIImage(named: "correct_ic")
            self.lblSeeker.text = MessageStringFile.seeker()
            self.lblSeeker.iconPadding = 2
            self.lblSeeker.iconPosition = ( .left, .top )
            self.lblProvider.icon = nil
            self.lblProvider.text = MessageStringFile.provider()
        }
    }
    
    @IBAction func switchRefuse(_ sender: Any) {
    }
    
    @IBAction func btnCancelDatePicker(_ sender: Any) {
        self.tfDOB.resignFirstResponder()
    }
    
    @IBAction func btnDoneDatePicker(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let date = self.datePicker.date
        
        let str = dateFormatter.string(from: date)
        tfDOB.text = str
        
        self.tfDOB.resignFirstResponder()
    }
    
    @IBAction func btnUrgentRequirementYes(_ sender: Any) {
        if self.urgentRequirement == WebServiceConstants.yes {
            return
        }
        self.updateUserType(userType: self.strUserType, urgentRequirement: WebServiceConstants.yes)
    }
    
    @IBAction func btnUrgentRequirementNo(_ sender: Any) {
        if self.urgentRequirement == WebServiceConstants.no {
            return
        }
        self.updateUserType(userType: self.strUserType, urgentRequirement: WebServiceConstants.no)
    }
    
    @IBAction func btnBarSave(_ sender: Any) {
        
        let arrValid = checkValidation()
        if arrValid.count == 0 {
            if HelperClass.isInternetAvailable {
                
                self.showSaveLoader(status: true)
                
                var images: [String: UIImage] = [:]
                
                if flagProfile1 {
                    if let img = btnProfile1.currentImage {
                        images[WebServiceConstants.image1] = img
                    }
                }
                if flagProfile2 {
                    if let img = btnProfile2.currentImage {
                        images[WebServiceConstants.image2] = img
                    }
                }
                if flagProfile3 {
                    if let img = btnProfile3.currentImage {
                        images[WebServiceConstants.image3] = img
                    }
                }
                
                var aboutMe = ""
                if lblAboutMe.text! != MessageStringFile.notAvailable() {
                    aboutMe = lblAboutMe.text!
                }
                
                var hashtags = ""
                if lblHashtags.text! != MessageStringFile.notAvailable() {
                    hashtags = lblHashtags.text!
                }
                
//                let param = [WebServiceConstants.name: tfName.text!, WebServiceConstants.dateOfBirth: tfDOB.text!, WebServiceConstants.user_type: strUserType, WebServiceConstants.description: aboutMe, WebServiceConstants.services: arrSpecificServices.hmJsonString(), WebServiceConstants.otherService: arrOtherServices.hmJsonString(), WebServiceConstants.serviceRequirement: arrServicesRequire.hmJsonString(), WebServiceConstants.serviceProvide: self.arrServicesProvide.hmJsonString(), WebServiceConstants.languageKnown: self.arrLanguages.hmJsonString(), WebServiceConstants.language: MessageStringFile.appLanguage(), WebServiceConstants.hashtags: hashtags, WebServiceConstants.urgentRequirement: self.urgentRequirement, WebServiceConstants.city: "", WebServiceConstants.state: "", WebServiceConstants.country: ""]
                
                let param = [WebServiceConstants.name: tfName.text!, WebServiceConstants.dateOfBirth: tfDOB.text!, WebServiceConstants.user_type: strUserType, WebServiceConstants.description: aboutMe, WebServiceConstants.languageKnown: self.arrLanguages.hmJsonString(), WebServiceConstants.language: MessageStringFile.appLanguage(), WebServiceConstants.hashtags: hashtags, WebServiceConstants.urgentRequirement: self.urgentRequirement, WebServiceConstants.city: "", WebServiceConstants.state: "", WebServiceConstants.country: ""]
                
                print("param >>>>>> \(param)")
                
                
                HMWebService.createRequest(forImageAndGetResponse: WebServiceLinks.updateProfile, methodType: HM_HTTPMethod.POST, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: param, andImageNameAsKeyAndImageAsItsValue: images, onCompletion: { (dictResponse, error, theReply) in
                    
                    print("theReply >>>>>> \(String(describing: theReply))")
                    print("error >>>>>> \(String(describing: error))")
                    print("dictResponse >>>>>> \(String(describing: dictResponse))")
                    
                    self.showSaveLoader(status: false)
                    if dictResponse!.count > 0 {
                        let JSON: NSDictionary = dictResponse! as NSDictionary
                        var msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                        if msg == "" {
                            msg = MessageStringFile.serverError()
                        }
                        
                        if JSON.hmGetInt(forKey: WebServiceConstants.success) == 1 {
                            //let dictUserInfo = JSON.hmGetNSDictionary(forKey: WebServiceConstants.userInfo)
                            let dictUserInfo = JSON.hmGetNSDictionary(forKey: WebServiceConstants.result)
                            AppVariables.setDictUserDetail(dictUserInfo)
                            //_ = self.navigationController?.popViewController(animated: true)
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
    
    func checkValidation() -> NSMutableArray {
        let arrValid = NSMutableArray()
        
        if ValidatorClasses.trimString(tempString: tfName.text!).characters.count == 0 {
            arrValid.add(MessageStringFile.vName())
        }
        
        if ValidatorClasses.trimString(tempString: tfDOB.text!).characters.count == 0 {
            arrValid.add(MessageStringFile.vDateOfBirth())
        }
        /*
        if self.arrSpecificServices.count == 0 {
            let userType = strUserType.lowercased()
            if userType == WebServiceConstants.provider {
                arrValid.add(MessageStringFile.vSpecificServicesOrSkillsThatYouProvide())
            } else {
                arrValid.add(MessageStringFile.vSpecificServicesOrSkillsThatYouAreSeeking())
            }
        }
        */
        
        return arrValid
    }
    
    func showSaveLoader(status: Bool) {
        if status {
            self.aviIndicator.color = UIColor.white
            self.navigationItem.setRightBarButton(UIBarButtonItem(customView: self.aviIndicator), animated: true)
            self.viewDetail.isUserInteractionEnabled = false
            self.viewProfileImage.isUserInteractionEnabled = false
            self.viewName.isUserInteractionEnabled = false
        } else {
            self.viewDetail.isUserInteractionEnabled = true
            self.viewProfileImage.isUserInteractionEnabled = true
            self.viewName.isUserInteractionEnabled = true
            self.navigationItem.setRightBarButton(self.btnBarSave, animated: true)
        }
    }
    
    func updateUserType(userType: String, urgentRequirement: String) {
        if HelperClass.isInternetAvailable {
            let params = [WebServiceConstants.user_type: userType, WebServiceConstants.urgentRequirement: urgentRequirement]
            self.showUserTypeLoader(status: true)
            HMWebService.createRequestAndGetResponse(WebServiceLinks.updateUserType, methodType: HM_HTTPMethod.POST, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                
                self.showUserTypeLoader(status: false)
                print("theReply >>>>>> \(String(describing: theReply))")
                print("error >>>>>> \(String(describing: error))")
                print("dictResponse >>>>>> \(String(describing: dictResponse))")
                
                if dictResponse!.count > 0 {
                    let JSON: NSDictionary = dictResponse! as NSDictionary
                    var msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                    if msg == "" {
                        msg = MessageStringFile.serverError()
                    }
                    
                    if JSON.hmGetInt(forKey: WebServiceConstants.success) == 1 {
                        let result = JSON.hmGetNSDictionary(forKey: WebServiceConstants.result)
                        if result.count > 0 {
                            AppVariables.setDictUserDetail(result)
                            self.strUserType = userType
                            self.urgentRequirement = urgentRequirement
                            self.setupViewData()
                        }
                        
//                        self.setviewAccToUrgentReq()
//                        self.switchUser()
//                        self.setupViewFrame()
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
    
    func showUserTypeLoader(status: Bool) {
        if status {
            self.viewName.isUserInteractionEnabled = false
            self.aviIndicatorUserType.isHidden = false
        } else {
            self.viewName.isUserInteractionEnabled = true
            self.aviIndicatorUserType.isHidden = true
        }
    }
    
    func deleteImage(imageName: String) {
        if HelperClass.isInternetAvailable {
            let param = [WebServiceConstants.image: imageName]
            
            if imageName == WebServiceConstants.image2 {
                self.aviIndicatorDelete2.frame = self.btnDeleteProfile2.frame
                self.btnDeleteProfile2.alpha = 0.0
                self.viewDetail.addSubview(self.aviIndicatorDelete2)
            } else if imageName == WebServiceConstants.image3 {
                self.aviIndicatorDelete3.frame = self.btnDeleteProfile3.frame
                self.btnDeleteProfile3.alpha = 0.0
                self.viewDetail.addSubview(self.aviIndicatorDelete3)
            }
            
            HMWebService.createRequestAndGetResponse(WebServiceLinks.deleteImage, methodType: HM_HTTPMethod.POST, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: param, onCompletion: { (dictResponse, error, theReply) in
                
                print("theReply >>>>>> \(String(describing: theReply))")
                print("error >>>>>> \(String(describing: error))")
                print("dictResponse >>>>>> \(String(describing: dictResponse))")
                
                if imageName == WebServiceConstants.image2 {
                    self.aviIndicatorDelete2.removeFromSuperview()
                    self.btnDeleteProfile2.alpha = 1.0
                } else if imageName == WebServiceConstants.image3 {
                    self.aviIndicatorDelete3.removeFromSuperview()
                    self.btnDeleteProfile3.alpha = 1.0
                }
                
                if dictResponse!.count > 0 {
                    let JSON: NSDictionary = dictResponse! as NSDictionary
                    var msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                    if msg == "" {
                        msg = MessageStringFile.serverError()
                    }
                    
                    if JSON.hmGetInt(forKey: WebServiceConstants.success) == 1 {
                        AppVariables.updateDictUserDetail(forKey: imageName, value: "")
                        if imageName == WebServiceConstants.image2 {
                            self.btnProfile2.setImage(UIImage(named: "add_icon"), for: UIControlState.normal)
                            self.btnDeleteProfile2.isHidden = true
                            self.flagProfile2 = false
                        } else if imageName == WebServiceConstants.image3 {
                            self.btnProfile3.setImage(UIImage(named: "add_icon"), for: UIControlState.normal)
                            self.btnDeleteProfile3.isHidden = true
                            self.flagProfile3 = false
                        }
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
    
    func setviewAccToUrgentReq() {
        self.viewUrgentRequirement.isHidden = false
        if urgentRequirement.lowercased() == WebServiceConstants.yes {
            btnUrgentRequirementYes.titleLabel?.font = PredefinedConstants.appBoldFont(size: 9.0)
            btnUrgentRequirementNo.titleLabel?.font = PredefinedConstants.appFont(size: 9.0)
        } else {
            btnUrgentRequirementYes.titleLabel?.font = PredefinedConstants.appFont(size: 9.0)
            btnUrgentRequirementNo.titleLabel?.font = PredefinedConstants.appBoldFont(size: 9.0)
        }
        /*
        //let dictResponse = AppVariables.getDictUserDetail()
        let user_type = strUserType.lowercased()
        //self.imgProviderOrSeeker.alpha = 0.0
        if user_type == WebServiceConstants.provider.lowercased() {
            //self.imgProviderOrSeeker.frame.origin.x = self.lblProvider.frame.origin.x - self.imgProviderOrSeeker.frame.size.width
            //self.viewUrgentRequirement.isHidden = true
            //self.lblProvider.attributedText = HelperClass.textWithImage(image: UIImage(named: "correct_ic"), str: MessageStringFile.provider())
            //self.lblSeeker.attributedText = nil
            //self.lblSeeker.text = MessageStringFile.seeker()
            self.viewUrgentRequirement.isHidden = true
            self.lblProvider.icon = UIImage(named: "correct_ic")
            self.lblProvider.text = MessageStringFile.provider()
            self.lblProvider.iconPadding = 2
            self. .iconPosition = ( .left, .top )
            self.lblSeeker.icon = nil
            self.lblSeeker.text = MessageStringFile.seeker()
        } else {
            //self.lblSeeker.attributedText = HelperClass.textWithImage(image: UIImage(named: "correct_ic"), str: MessageStringFile.seeker())
            //self.lblProvider.attributedText = nil
            //self.lblProvider.text = MessageStringFile.provider()
            
            self.viewUrgentRequirement.isHidden = false
            
            self.lblSeeker.icon = UIImage(named: "correct_ic")
            self.lblSeeker.text = MessageStringFile.seeker()
            self.lblSeeker.iconPadding = 2
            self.lblSeeker.iconPosition = ( .left, .top )
            self.lblProvider.icon = nil
            self.lblProvider.text = MessageStringFile.provider()
            
            
            if urgentRequirement.lowercased() == WebServiceConstants.yes {
                btnUrgentRequirementYes.titleLabel?.font = PredefinedConstants.appBoldFont(size: 10.0)
                btnUrgentRequirementNo.titleLabel?.font = PredefinedConstants.appFont(size: 10.0)
            } else {
                btnUrgentRequirementYes.titleLabel?.font = PredefinedConstants.appFont(size: 10.0)
                btnUrgentRequirementNo.titleLabel?.font = PredefinedConstants.appBoldFont(size: 10.0)
            }
        }
        */
//        UIView.animate(withDuration: 0.5) {
//            self.imgProviderOrSeeker.alpha = 1.0
//        }
    }
    
    //MARK: Image Picker Delegate & DataSource
    func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker!.sourceType = UIImagePickerControllerSourceType.camera
            self .present(imagePicker!, animated: true, completion: nil)
        }  else  {
            openGallary()
        }
    }
    
    func openGallary() {
        imagePicker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(imagePicker!, animated: true, completion: nil)
        } else  {
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var newImage: UIImage
        if let possibleImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            newImage = possibleImage
        }else {
            return
        }
        
        if profileImagePickerType == .profile1 {
            btnProfile1.setImage(newImage, for: UIControlState.normal)
            flagProfile1 = true
            btnProfile1.circleView(UIColor.clear, borderWidth: 0.0)
            btnProfile1.setTitle(nil, for: UIControlState.normal)
        } else if profileImagePickerType == .profile2 {
            btnProfile2.setImage(newImage, for: UIControlState.normal)
            flagProfile2 = true
            btnProfile2.setTitle(nil, for: UIControlState.normal)
            btnDeleteProfile2.isHidden = false
        }  else if profileImagePickerType == .profile3 {
            btnProfile3.setImage(newImage, for: UIControlState.normal)
            flagProfile3 = true
            btnDeleteProfile3.isHidden = false
            btnProfile3.setTitle(nil, for: UIControlState.normal)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imageOnLabel() {
        /*
         NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
         attachment.image = [UIImage imageNamed:@"MyIcon.png"];
         
         NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
         
         NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:@"My label text"];
         [myString appendAttributedString:attachmentString];
         
         myLabel.attributedText = myString;
         
         
         NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
         attachment.image = [UIImage imageNamed:@"orderOnPhoneIcon"];
         CGFloat offsetY = -5.0;
         attachment.bounds = CGRectMake(0, offsetY, attachment.image.size.width, attachment.image.size.height);
         NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
         NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:@""];
         [myString appendAttributedString:attachmentString];
         NSMutableAttributedString *myString1= [[NSMutableAttributedString alloc] initWithString:mobileString];
         [myString appendAttributedString:myString1];
         self.mobileLabel.textAlignment=NSTextAlignmentRight;
         self.mobileLabel.attributedText=myString;
         
         */
        //correct_ic
        /*
        let attachment = NSTextAttachment()
        attachment.image = UIImage(named: "correct_ic")
        attachment.bounds = CGRect(x: 0.0, y: -5.0, width: attachment.image!.size.width, height: attachment.image!.size.height)
        
        let attachmentString = NSAttributedString(attachment: attachment)
        
        //let myString = NSMutableAttributedString(string: MessageStringFile.provider())
        //myString.append(attachmentString)
        
        let myString = NSMutableAttributedString(attributedString: attachmentString)
        myString.append(NSAttributedString(string: MessageStringFile.provider()))
        
        lblProvider.attributedText = myString
        */
    }
    
    //MARK: Selection Delegate
    
    func selectedData(selectionType: SelectionType, fromClass: FromClass, arrSelected: NSArray) {
        /*
        let lblWidth = self.viewDetail.frame.size.width - 44.0
        if selectionType == .specificServices {
            self.arrSpecificServices = arrSelected.mutableCopy() as! NSMutableArray
            self.lblSpecificServices.text = AppVariables.services(arr: self.arrSpecificServices, dict: nil).str
            self.lblSpecificServices.frame.size.width = lblWidth
            self.lblSpecificServices.sizeToFit()
        } else if selectionType == .otherServices {
            self.arrOtherServices = arrSelected.mutableCopy() as! NSMutableArray
            self.lblOtherServices.text = AppVariables.otherServices(arr: self.arrOtherServices, dict: nil).str
            self.lblOtherServices.frame.size.width = lblWidth
            self.lblOtherServices.sizeToFit()
        } else if selectionType == .requiredServices {
            self.arrServicesRequire = arrSelected.mutableCopy() as! NSMutableArray
            self.lblServicesRequire.text = AppVariables.servicesRequired(arr: self.arrServicesRequire, dict: nil).str
            self.lblServicesRequire.frame.size.width = lblWidth
            self.lblServicesRequire.sizeToFit()
        } else if selectionType == .provideServices {
            self.arrServicesProvide = arrSelected.mutableCopy() as! NSMutableArray
            self.lblServicesRequire.text = AppVariables.servicesProvide(arr: self.arrServicesProvide, dict: nil).str
            self.lblServicesRequire.frame.size.width = lblWidth
            self.lblServicesRequire.sizeToFit()
        }

        self.setupViewFrame()
 */
    }
    
    func selectionDidCancel() {
        
    }
    
    //MARK: Personal Info Delegate
    
    func personalInfoSelectedData(aboutMe: String, hashtags: String, languages: NSArray) {
        let lblWidth = self.viewDetail.frame.size.width - 44.0
        
        var aboutMeTxt = aboutMe
        if aboutMeTxt.hm_Length == 0 {
            aboutMeTxt = MessageStringFile.notAvailable()
        }
        self.lblAboutMe.text = aboutMeTxt
        self.lblAboutMe.frame.size.width = lblWidth
        self.lblAboutMe.sizeToFit()
        
        var hashtagsTxt = hashtags
        if hashtagsTxt.hm_Length == 0 {
            hashtagsTxt = MessageStringFile.notAvailable()
        }
        self.lblHashtags.text = hashtagsTxt
        self.lblHashtags.frame.size.width = lblWidth
        self.lblHashtags.sizeToFit()
        
        self.arrLanguages = languages.mutableCopy() as! NSMutableArray
        self.lblLanguages.text = AppVariables.languages(arr: self.arrLanguages, dict: nil).str
        self.lblLanguages.frame.size.width = lblWidth
        self.lblLanguages.sizeToFit()
        self.setupViewFrame()
        
    }
    
    func personalInfoSelectionDidCancel() {
        
    }
    
    //MARK: PopUp
    
    func clickOnPopUpLeftButton() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func clickOnPopUpRightButton() {
        
    }
    
    //MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueEditProfilePersonalInfo" {
            let vc = segue.destination as! PersonalInfoViewController
            vc.strUserType = self.strUserType
            vc.dictPrevious = self.dictService
            /*
            vc.arrLanguages = self.arrLanguages.mutableCopy() as! NSMutableArray
            if self.lblHashtags.text != MessageStringFile.notAvailable() {
                if let text = self.lblHashtags.text {
                    vc.strHashtags = text
                }
            }
            if self.lblAboutMe.text != MessageStringFile.notAvailable() {
                if let text = self.lblAboutMe.text {
                    vc.strMoreAboutMe = text
                }
            }
            */
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }

}
