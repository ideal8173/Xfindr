//
//  ProfileViewController.swift
//  XFindr
//
//  Created by Anurag on 3/24/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var viewImage: UIView!
    @IBOutlet var imgProfileSelected: UIImageView!
    @IBOutlet var imgSelected: UIImageView!
    
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    @IBOutlet var aviFavourateIndicator: UIActivityIndicatorView!
    @IBOutlet var aviBlockIndicator: UIActivityIndicatorView!
    
    @IBOutlet var svView: UIScrollView!
    @IBOutlet var cvProfile: UICollectionView!
    
    @IBOutlet var btnBarEdit: UIBarButtonItem!
    @IBOutlet var btnEdit: UIButton!
    
    @IBOutlet var btnBarUserType: UIBarButtonItem!
    @IBOutlet var btnUserType: UIButton!
    
    @IBOutlet var viewName: UIView!
    @IBOutlet var viewProfileDetail: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblDistance: UILabel!

    @IBOutlet var viewWork: UIView!
    @IBOutlet var lblWork: UILabel!
    @IBOutlet var lblOther: UILabel!
    
    @IBOutlet var viewRequirement: UIView!
    @IBOutlet var lblRequirement: UILabel!
    
    @IBOutlet var viewAboutMe: UIView!
    @IBOutlet var lblStaticMoreAbout: UILabel!
    @IBOutlet var lblAboutMe: UILabel!
    
    @IBOutlet var viewHashtags: UIView!
    @IBOutlet var lblHashtagsTxt: UILabel!
    @IBOutlet var lblHashtags: UILabel!

    @IBOutlet var viewChatButton: UIView!
    @IBOutlet var btnStar: UIButton!
    @IBOutlet var btnChat: UIButton!
    @IBOutlet var btnActive: UIButton!
    
    @IBOutlet var viewGusetbook: UIView!
    @IBOutlet var lblGusetbookTxt: UILabel!
    @IBOutlet var btnExpandGusetbook: UIButton!
    // Variables
    
    @IBOutlet var tblGusetbook: UITableView!
    
    @IBOutlet var viewMoreGuestbook: UIView!
    @IBOutlet var btnMoreGuestbook: UIButton!
    @IBOutlet var btnReport: UIButton!
    
    var arrCollection = NSMutableArray()
    var dictPrevious = NSDictionary()
    var dictResponse = NSDictionary()
    var flagExpandGuestbook = true
    
    // MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.setDelegate()
        self.otherFunction()
        svView.contentSize = CGSize(width: 0, height: viewMoreGuestbook.frame.origin.y + viewMoreGuestbook.frame.size.height + 20)
        viewHeader.alpha = 0.0
        //self.svView.backgroundColor = UIColor.green
        self.btnEdit.circleView(UIColor.clear, borderWidth: 0.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.setNavigation()
        //print("dictPrevious >>>>> \(dictPrevious)")
        callDetailWebservice()
        /*
        cvProfile.backgroundColor = PredefinedConstants.navigationColor
        viewName.backgroundColor = PredefinedConstants.navigationColor
        viewWork.backgroundColor = PredefinedConstants.navigationColor
        viewRequirement.backgroundColor = PredefinedConstants.navigationColor
        viewAboutMe.backgroundColor = PredefinedConstants.navigationColor
        viewHashtags.backgroundColor = PredefinedConstants.navigationColor
        viewGusetbook.backgroundColor = PredefinedConstants.navigationColor
        tblGusetbook.backgroundColor = PredefinedConstants.navigationColor
        viewMoreGuestbook.backgroundColor = PredefinedConstants.navigationColor
        */
    }
    
    func callDetailWebservice() {
        let userId = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants._id)
        self.showLoader(status: true)
        if HelperClass.isInternetAvailable {
            HMWebService.createRequestAndGetResponse(WebServiceLinks.userDetail, methodType: HM_HTTPMethod.GET, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: [WebServiceConstants.userId: userId, WebServiceConstants.login_id: AppVariables.getUserId()], onCompletion: { (dictResponse, error, theReply) in
                
                self.showLoader(status: false)
                
                print("theReply >>>>>> \(String(describing: theReply))")
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
                        let dict = JSON.hmGetNSDictionary(forKey: WebServiceConstants.result)
                        self.dictResponse = dict
                        self.setupViewData()
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
    
    func showLoader(status: Bool) {
        if status {
            self.navigationItem.setRightBarButton(nil, animated: false)
            self.view.addSubview(self.aviIndicator)
            self.aviIndicator.center = self.view.center
            self.svView.alpha = 0.0
            self.viewImage.alpha = 0.0
            self.viewChatButton.alpha = 0.0
        } else {
            self.aviIndicator.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
                self.svView.alpha = 1.0
                self.viewImage.alpha = 1.0
                self.viewChatButton.alpha = 1.0
            })
        }
    }
    
    func showAlert(firstLblTitle: String, secondLblTitle: String){
        PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: firstLblTitle, secondLblTitle: secondLblTitle)
        PopUpView.sharedInstance.delegate = nil
    }
    
    // MARK:- Functions..
    
    func getImageStaticHeight() -> CGFloat {
        let collectionHeight = self.cvProfile.frame.size.width / 3.0
        let lblHeight: CGFloat = 50.0
        var padding: CGFloat = 0.0
        if !self.isUserSelf() {
            padding = 50.0
        }
        let imageHeight = self.view.frame.size.height - collectionHeight - lblHeight - padding
        return imageHeight
    }
    
    func setDelegate() {
        cvProfile.delegate = self
        cvProfile.dataSource = self
        svView.delegate = self
        tblGusetbook.delegate = self
        tblGusetbook.dataSource = self
    }
    
    func setNavigation() {
//        let status = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.user_type)
//        
//        if status == WebServiceConstants.userSelf {
//            self.title = "My Profile"
//            btnEdit.image = UIImage(named: "edit")
//            btnEdit.tintColor = UIColor.white
//        } else {
//            self.title = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.service)
//            btnEdit.image = UIImage(named: "report")
//            btnEdit.tintColor = UIColor.red
//        }
        self.title = ClassesHeader.profile()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func otherFunction() {

    }
    
    func isUserSelf() -> Bool {
        let myId = AppVariables.getUserId()
        let listUserId = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants._id)
        if listUserId == myId {
            return true
        }
        return false
    }
    
    let darkBlue = UIColor(hm_hexString: "#01263f")
    
    func setupViewData() {
        var height = self.cvProfile.frame.size.width / 3.0
        self.cvProfile.isScrollEnabled = false
        
        let arr = NSMutableArray()
        
        let profile1 = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.image1)
        let profile2 = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.image2)
        let profile3 = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.image3)
        
        if profile1 != "" {
            arr.add(profile1)
        }
        if profile2 != "" {
            arr.add(profile2)
        }
        if profile3 != "" {
            arr.add(profile3)
        }
        
        if arr.count < 2 {
            height = 0.0
        }
        
        let imageHeight = self.getImageStaticHeight()
        
        self.viewImage.frame.size.height = imageHeight
        
        self.cvProfile.frame.size.height = height
        self.cvProfile.frame.origin.y = imageHeight
        //self.svView.frame.origin.y = self.cvProfile.frame.origin.y + self.cvProfile.frame.size.height
        //self.svView.frame.size.height = self.scrollStaticHeight()
        
        viewProfileDetail.frame.origin.y = self.cvProfile.frame.origin.y + height + 5
        
        lblName.frame.size.width = self.viewName.frame.size.width - 58.0
        let name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.name)
        let year = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.age)
        let languageKnown = AppVariables.languages(arr: nil, dict: dictResponse).str
        
        var iSpeak = ""
        if languageKnown != "" && languageKnown != MessageStringFile.notAvailable() {
            iSpeak = MessageStringFile.iSpeak() + MessageStringFile.colonSymbol() + languageKnown
        }
        
        var full = name
        if year != "" {
            full = name + " " + year
        }
        
        if iSpeak != "" {
            full = full + ", " + iSpeak
        }
        
        let range = (full as NSString).range(of: iSpeak)
        let attributedString = NSMutableAttributedString(string: full)
//        attributedString.setAttributes([NSFontAttributeName: PredefinedConstants.appFont(size: 12),  NSForegroundColorAttributeName: PredefinedConstants.grayTextColor], range: range)
        attributedString.setAttributes([NSFontAttributeName: PredefinedConstants.appFont(size: 12),  NSForegroundColorAttributeName: UIColor.white], range: range)
        lblName.numberOfLines = 0
        lblName.attributedText = attributedString
        lblName.lineBreakMode = .byWordWrapping
        lblName.sizeToFit()
        
        if isUserSelf() {
            self.lblDistance.isHidden = true
            self.viewName.frame.size.height = lblName.frame.origin.y + lblName.frame.size.height + 10
        } else {
            self.lblDistance.isHidden = false
            self.lblDistance.frame.size.height = lblName.frame.origin.y + lblName.frame.size.height + 5
            
            let lat_long = dictResponse.hmGetNSArray(forKey: WebServiceConstants.lat_long)
            if lat_long.count > 1 {
                
            }
            self.viewName.frame.size.height = lblDistance.frame.origin.y + lblDistance.frame.size.height + 10
        }

        viewWork.frame.origin.y = viewName.frame.origin.y + viewName.frame.size.height
        lblWork.frame.size.width = self.viewWork.frame.size.width - 16.0
        let services = AppVariables.services(arr: nil, dict: dictResponse).str
        lblWork.numberOfLines = 0
        lblWork.text = services
        lblWork.lineBreakMode = .byWordWrapping
        lblWork.sizeToFit()
        
        let other = AppVariables.otherServices(arr: nil, dict: dictResponse).str
        lblOther.frame.size.width = self.viewWork.frame.size.width - 16.0
        lblOther.frame.origin.y = lblWork.frame.origin.y + lblWork.frame.size.height + 5
        let staticOther = MessageStringFile.other() + MessageStringFile.colonSymbol()
        let fullOther = staticOther + " " + other
        let range2 = (fullOther as NSString).range(of: staticOther)
        let attributedString2 = NSMutableAttributedString(string: fullOther)
        attributedString2.addAttribute(NSForegroundColorAttributeName, value: darkBlue , range: range2)
        lblOther.numberOfLines = 0
        lblOther.attributedText = attributedString2
        lblOther.lineBreakMode = .byWordWrapping
        lblOther.sizeToFit()
        viewWork.frame.size.height = lblOther.frame.origin.y + lblOther.frame.size.height + 10
        
        
        
        /*
        var requirement = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.serviceRequirement)
        if requirement == "" {
            let arr = dictResponse.hmGetNSArray(forKey: WebServiceConstants.serviceRequirement)
            if arr.count > 0 {
                requirement = arr.componentsJoined(by: ", ")
            }
        }
        
        */
        
        /*
        if user_type.lowercased() == WebServiceConstants.seeker {
            lblServicesRequireTxt.text = MessageStringFile.servicesOrSkillsThatYouMayProvide() + ":"
            
            let funcServPro = self.servicesProvide(arr: nil, dict: dictResponse)
            requirement = funcServPro.str
        } else {
            lblServicesRequireTxt.text = MessageStringFile.servicesOrSkillsThatYouMayRequire() + ":"
            let funcServReq = self.servicesRequired(arr: nil, dict: dictResponse)
            requirement = funcServReq.str
        }
        if requirement == "" {
            requirement = MessageStringFile.notAvailable()
        }
        */
        
        viewRequirement.frame.origin.y = viewWork.frame.origin.y + viewWork.frame.size.height
        lblRequirement.frame.size.width = self.viewRequirement.frame.size.width - 16.0
        var staticRequirement = MessageStringFile.requirement() + MessageStringFile.colonSymbol()
        var requirement = AppVariables.servicesRequired(arr: nil, dict: dictResponse).str
        let user_type = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.user_type).lowercased()
        if user_type == WebServiceConstants.provider.lowercased() {
            staticRequirement = MessageStringFile.provide() + MessageStringFile.colonSymbol()
            requirement = AppVariables.servicesProvide(arr: nil, dict: dictResponse).str
        }
        
        if requirement == "" {
            requirement = MessageStringFile.notAvailable()
        }
        
        let fullRequirement = staticRequirement + " " + requirement
        let range3 = (fullRequirement as NSString).range(of: staticRequirement)
        let attributedString3 = NSMutableAttributedString(string: fullRequirement)
        attributedString3.addAttribute(NSForegroundColorAttributeName, value:darkBlue , range: range3)
        lblRequirement.numberOfLines = 0
        lblRequirement.attributedText = attributedString3
        lblRequirement.lineBreakMode = .byWordWrapping
        lblRequirement.sizeToFit()
        viewRequirement.frame.size.height = lblRequirement.frame.origin.y + lblRequirement.frame.size.height + 10
        
        viewAboutMe.frame.origin.y = viewRequirement.frame.origin.y + viewRequirement.frame.size.height
        lblAboutMe.frame.size.width = self.viewAboutMe.frame.size.width - 16.0
        lblStaticMoreAbout.frame.size.width = self.viewAboutMe.frame.size.width - 16.0
        lblStaticMoreAbout.text = MessageStringFile.moreAboutMe() + MessageStringFile.colonSymbol()
        lblStaticMoreAbout.textColor = darkBlue
        let description = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.description)
        lblAboutMe.text = description
        lblAboutMe.lineBreakMode = .byWordWrapping
        lblAboutMe.sizeToFit()
        viewAboutMe.frame.size.height = lblAboutMe.frame.origin.y + lblAboutMe.frame.size.height + 10
        
        viewHashtags.frame.origin.y = viewAboutMe.frame.origin.y + viewAboutMe.frame.size.height
        lblHashtagsTxt.frame.size.width = self.viewHashtags.frame.size.width - 16.0
        lblHashtags.frame.size.width = self.viewHashtags.frame.size.width - 16.0
        lblHashtagsTxt.text = "#" + MessageStringFile.hashtags()
        lblHashtagsTxt.textColor = darkBlue
        var hashtags = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.hashtags)
        if hashtags == "" {
            let arr = dictResponse.hmGetNSArray(forKey: WebServiceConstants.hashtags)
            if arr.count > 0 {
                hashtags = arr.componentsJoined(by: "# ")
            }
        }
        lblHashtags.text = hashtags
        lblHashtags.lineBreakMode = .byWordWrapping
        lblHashtags.sizeToFit()
        viewHashtags.frame.size.height = lblHashtags.frame.origin.y + lblHashtags.frame.size.height + 10
        
        viewGusetbook.frame.origin.y = viewHashtags.frame.origin.y + viewHashtags.frame.size.height
        viewGusetbook.frame.size.height = self.getViewGusetbookHeight()
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        if flagExpandGuestbook {
            
        } else {
            //transform = CGAffineTransform.identity.rotated(by: CGFloat(M_PI))
            transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi))
        }
        
        self.btnExpandGusetbook.transform = transform
        
        tblGusetbook.frame.origin.y = viewGusetbook.frame.origin.y + viewGusetbook.frame.size.height
        tblGusetbook.frame.size.height = self.getGuestbookTableHeight()
        
        viewMoreGuestbook.frame.origin.y = tblGusetbook.frame.origin.y + tblGusetbook.frame.size.height
        viewMoreGuestbook.frame.size.height = self.showViewMoreGuestbookHeight()
        
        viewProfileDetail.frame.size.height = viewMoreGuestbook.frame.origin.y + viewMoreGuestbook.frame.size.height
        
        svView.contentSize = CGSize(width: 0.0, height: viewProfileDetail.frame.origin.y + viewProfileDetail.frame.size.height + 100)
        
        //let status = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants.user_type)
        /*
        viewProfileDetail.layer.shadowOpacity = 0.5
        viewProfileDetail.layer.shadowOffset = CGSize(width: 0, height: 0)
        viewProfileDetail.layer.shadowRadius = 1.0
        viewProfileDetail.layer.shadowColor = UIColor.black.cgColor
        */
        
        if profile1 != "" {
            if let url = URL(string: "\(WebServiceLinks.userImageUrl())\(profile1)") {
                imgProfileSelected.sd_setImage(with: url, placeholderImage: UIImage(), options: SDWebImageOptions.retryFailed)
            }
        }
        
        cvProfile.reloadData()
        /*
        
        
        lblStaticMoreAbout.frame.origin.y = lblOtherRequirement.frame.origin.y + lblOtherRequirement.frame.size.height + 10
        lblAboutMe.frame.origin.y = lblStaticMoreAbout.frame.origin.y + lblStaticMoreAbout.frame.size.height + 5
        lblAboutMe.numberOfLines = 0
        lblAboutMe.text = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."
        lblAboutMe.lineBreakMode = .byWordWrapping
        lblAboutMe.sizeToFit()
        viewProfileDetail.frame.size.height = lblAboutMe.frame.origin.y + lblAboutMe.frame.size.height + 5
        svView.contentSize = CGSize(width: 0, height: viewProfileDetail.frame.origin.y + viewProfileDetail.frame.size.height + 5)
        */
        
        if isUserSelf() {
            viewChatButton.isHidden = true
            btnReport.isHidden = true
            self.navigationItem.setRightBarButton(btnBarEdit, animated: false)
            self.svView.frame.size.height = self.viewChatButton.frame.origin.y + self.viewChatButton.frame.size.height
        } else {
            if user_type == WebServiceConstants.provider.lowercased() {
                btnUserType.setImage(UIImage(named: "provider_icon"), for: UIControlState.normal)
            } else {
                btnUserType.setImage(UIImage(named: "seeker_icon"), for: UIControlState.normal)
            }
            
            self.navigationItem.setRightBarButton(btnBarUserType, animated: false)
            btnReport.isHidden = false
            if AppVariables.getUserId() == "" {
                viewChatButton.isHidden = true
                self.svView.frame.size.height = self.viewChatButton.frame.origin.y + self.viewChatButton.frame.size.height
            } else {
                viewChatButton.isHidden = false
                self.svView.frame.size.height = self.viewChatButton.frame.origin.y
            }
        }
        
        HMUtilities.hmDelay(delay: 2.0) {
            self.setupNavigationButton()
        }
        
        // kamal set favourite and Unfavourite
        let strFavouriteStatus = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.favourite_status).lowercased()
        if strFavouriteStatus == WebServiceConstants.favourite {
            btnStar.setImage(UIImage(named: "favorite_icon_active"), for: UIControlState.normal)
            btnStar.setTitle(MessageStringFile.unFavourite(), for: .normal)
        } else {
            btnStar.setImage(UIImage(named: "favorite_icon"), for: UIControlState.normal)
            btnStar.setTitle(MessageStringFile.favourite(), for: .normal)
        }
        
        let strBlockStatus = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.block_status).lowercased()
        if strBlockStatus == WebServiceConstants.block {
            btnActive.setTitle(MessageStringFile.unBlock(), for: .normal)
        } else {
            btnActive.setTitle(MessageStringFile.block(), for: .normal)
        }
        
        btnMoreGuestbook.circleView(btnMoreGuestbook.titleLabel!.textColor!, borderWidth: 1.0)
        self.lblGusetbookTxt.text = MessageStringFile.guestbook()
    }
    
    func setupNavigationButton() {
        if isUserSelf() {
            viewChatButton.isHidden = true
            btnReport.isHidden = true
            self.navigationItem.setRightBarButton(btnBarEdit, animated: false)
            self.svView.frame.size.height = self.viewChatButton.frame.origin.y + self.viewChatButton.frame.size.height
        } else {
            let user_type = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.user_type).lowercased()
            if user_type == WebServiceConstants.provider.lowercased() {
                btnUserType.setImage(UIImage(named: "provider_icon"), for: UIControlState.normal)
            } else {
                btnUserType.setImage(UIImage(named: "seeker_icon"), for: UIControlState.normal)
            }
            
            self.navigationItem.setRightBarButton(btnBarUserType, animated: false)
            btnReport.isHidden = false
            if AppVariables.getUserId() == "" {
                viewChatButton.isHidden = true
                self.svView.frame.size.height = self.viewChatButton.frame.origin.y + self.viewChatButton.frame.size.height
            } else {
                viewChatButton.isHidden = false
                self.svView.frame.size.height = self.viewChatButton.frame.origin.y
            }
            
        }
    }
    
    func scrollStaticHeight() -> CGFloat {
        var height: CGFloat = 0.0
        if isUserSelf() {
            height = self.view.frame.size.height - (self.viewImage.frame.origin.y + self.viewImage.frame.size.height)
        } else {
            height = self.viewChatButton.frame.origin.y
        }
        return height
    }
    
    func getGuestbookTableHeight() -> CGFloat {
        if flagExpandGuestbook {
            return 0.0
        }
        let review_list = dictResponse.hmGetNSArray(forKey: WebServiceConstants.reviewList)
        var height: CGFloat = 0.0
        for i in 0 ..< review_list.count {
            let dict = review_list.hmNSDictionary(atIndex: i)
            let singleCellHeight = self.getSingleCellHeight(dict: dict)
            height += singleCellHeight
        }
        return height
    }
    
    func showViewMoreGuestbookHeight() -> CGFloat {
        if flagExpandGuestbook {
            return 0.0
        }
        let review_count = dictResponse.hmGetInt(forKey: WebServiceConstants.reviewCount)
        let review_list = dictResponse.hmGetNSArray(forKey: WebServiceConstants.reviewList)
        if review_count > review_list.count {
            return 50.0
        }
        return 0.0
    }
    
    func getViewGusetbookHeight() -> CGFloat {
        let review_count = dictResponse.hmGetInt(forKey: WebServiceConstants.reviewCount)
        let review_list = dictResponse.hmGetNSArray(forKey: WebServiceConstants.reviewList)
        if review_count > review_list.count {
            return 50.0
        }
        return 0.0
    }
    
    func getSingleCellHeight(dict: NSDictionary) -> CGFloat {
        let maxWidth = self.tblGusetbook.frame.size.width - 84.0
        let review = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.review)
        let font = PredefinedConstants.appFont(size: 14.0)
        let textHeight = HelperClass.hmGetTextSize(text: review, font: font, boundedBySize: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)).height
        
        let cellHeight: CGFloat = textHeight + 80.0
        return cellHeight
    }
    
    // MARK:- Collection View Delegate And DataSource Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionCell", for: indexPath)
        
        
        let arr = NSMutableArray()
        
        let profile1 = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.image1)
        let profile2 = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.image2)
        let profile3 = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse, strObject: WebServiceConstants.image3)
        
        if profile1 != "" {
            arr.add(profile1)
        }
        if profile2 != "" {
            arr.add(profile2)
        }
        if profile3 != "" {
            arr.add(profile3)
        }
        
        if let imgProfile = cell.contentView.viewWithTag(100) as? UIImageView {
            imgProfile.setCornerRadiousAndBorder(UIColor.clear, borderWidth: 0.0, cornerRadius: 2.0)
            let imgStr = arr.hmString(atIndex: indexPath.row)
            if let url = URL(string: "\(WebServiceLinks.userImageUrl())\(imgStr)") {
                imgProfile.sd_setImage(with: url, placeholderImage: UIImage(), options: SDWebImageOptions.retryFailed)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.collectionView(collectionView, cellForItemAt: indexPath)
        if let imgProfile = cell.contentView.viewWithTag(100) as? UIImageView {
            if let image = imgProfile.image {
                if image.size != CGSize.zero {
                    if let theAttributes = collectionView.layoutAttributesForItem(at: indexPath) {
                        let cellFrameInSuperview = collectionView.convert(theAttributes.frame, to: collectionView.superview)
                        self.svView.contentOffset = CGPoint.zero
                        imgSelected.image = image
                        imgSelected.frame = cellFrameInSuperview
                        self.svView.addSubview(self.imgSelected)
                        UIView.animate(withDuration: 0.3, animations: {
                            self.imgSelected.frame = self.viewImage.frame
                        }, completion: { (finished) in
                            UIView.animate(withDuration: 0.3, animations: {
                                self.imgProfileSelected.image = image
                                self.imgSelected.alpha = 0.0
                            }, completion: { (finished) in
                                self.imgSelected.removeFromSuperview()
                                self.imgSelected.alpha = 1.0
                            })
                        })
                        
                        /*
                        UIView.animate(withDuration: 0.3, animations: {
                            //self.imgSelected.center = self.viewImage.center
                        }, completion: { (finished) in
                            UIView.animate(withDuration: 0.3, animations: {
                                self.imgSelected.frame = self.viewImage.frame
                            }, completion: { (finished) in
                                UIView.animate(withDuration: 0.3, animations: {
                                    self.imgProfileSelected.image = image
                                    self.imgSelected.alpha = 0.0
                                }, completion: { (finished) in
                                    self.imgSelected.removeFromSuperview()
                                    self.imgSelected.alpha = 1.0
                                })
                            })
                        })
                        */
                    } else {
                        self.imgProfileSelected.image = image
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.cvProfile.frame.size.width / 3.0
        return  CGSize(width: width - 1, height: width - 2)
    }
    
    // MARK: Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let review_list = dictResponse.hmGetNSArray(forKey: WebServiceConstants.reviewList)
        return review_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileGuestbookCell") as! ProfileGuestbookCell
        let review_list = dictResponse.hmGetNSArray(forKey: WebServiceConstants.reviewList)
        let dict = review_list.hmNSDictionary(atIndex: indexPath.row)
        
        cell.lblName.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.by_name)
        let maxWidth = self.tblGusetbook.frame.size.width - 84.0
        let review = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.review)
        let font = PredefinedConstants.appFont(size: 14.0)
        let textHeight = HelperClass.hmGetTextSize(text: review, font: font, boundedBySize: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)).height
        
        cell.lblDescription.text = review
        cell.lblDescription.frame.size.height = textHeight
        
        cell.imgProfile.setCornerRadiousAndBorder(UIColor.clear, borderWidth: 0.0, cornerRadius: 2.0)
        
        let imgStr = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.by_image)
        if imgStr == "" {
            cell.imgProfile.image = nil
        } else {
            if let url = URL(string: "\(WebServiceLinks.userImageUrl())\(imgStr)") {
                cell.imgProfile.sd_setImage(with: url, placeholderImage: UIImage(), options: SDWebImageOptions.retryFailed)
            } else {
                cell.imgProfile.image = nil
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let review_list = dictResponse.hmGetNSArray(forKey: WebServiceConstants.reviewList)
        let dict = review_list.hmNSDictionary(atIndex: indexPath.row)
        return self.getSingleCellHeight(dict: dict)
    }
    
    // MARK:- ScrollView Delegate Method
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*
        let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
        if let ip = collectionProfile.indexPathForItem(at: center) {
            self.pageController.currentPage = ip.row
        }
        */
        
        /*
        
        if scrollView == self.svView {
            var imageY: CGFloat = -scrollView.contentOffset.y
            var imageHeight: CGFloat = 200
            var imageWidth: CGFloat = self.view.frame.size.width
            
            if imageY > 0 {
                imageHeight += imageY
                imageWidth += imageY
                imageY = 0
            } else if imageY < -(self.viewImage.frame.size.height - 64.0) {
                imageY = -(self.viewImage.frame.size.height - 64.0)
            }
            
            let alpha: CGFloat = fabs(imageY) / (self.viewImage.frame.size.height - 64.0)
            self.viewHeader.alpha = alpha
            self.viewImage.frame.origin.y = imageY
            self.viewImage.frame.size.height = imageHeight
            self.viewImage.frame.size.width = imageWidth
            self.svView.frame.origin.y = imageY + self.viewImage.frame.size.height
            self.svView.frame.size.height = self.view.frame.size.height - (imageY + self.viewImage.frame.size.height)
            
            
            //self.cvProfile.frame.origin.y = imageY + self.viewImage.frame.size.height
            //self.svView.frame.origin.y = self.cvProfile.frame.origin.y + self.cvProfile.frame.size.height
            //self.svView.frame.size.height = self.scrollStaticHeight() - imageY - 20
        }
 */
        
        if scrollView == self.svView {
            let offsetY = scrollView.contentOffset.y
            var imageY: CGFloat = -offsetY
            //let staticImageHeight: CGFloat = 250.0
            let staticImageHeight: CGFloat = self.getImageStaticHeight()
            
            if imageY > 0 {
                imageY = 0
            } else if imageY < -(staticImageHeight - 64.0) {
                imageY = -(staticImageHeight - 64.0)
            }
            
            let alpha: CGFloat = fabs(imageY) / (staticImageHeight - 64.0)
            self.viewHeader.alpha = alpha
            self.viewImage.frame.origin.y = imageY
            if offsetY > 0 {
                self.viewImage.frame.size.height = staticImageHeight
            } else {
                self.viewImage.frame.size.height = staticImageHeight - offsetY
            }
        }
    }
    
    // MARK:- Buttons Action
    
    @IBAction func btnEdit(_ sender: Any) {

        HMUtilities.hmMainQueue {
            self.performSegue(withIdentifier: "segueEditProfile", sender: nil)
        }
    }
    
    @IBAction func btnBarEdit(_ sender: Any) {
        HMUtilities.hmMainQueue {
            self.performSegue(withIdentifier: "segueEditProfile", sender: nil)
        }
    }
    
    /*
    @IBAction func btnLogout(_ sender: Any) {
        XFindrUserDefaults.setUserLoginStatus(status: nil)
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func btnSetting(_ sender: Any) {
        performSegue(withIdentifier: "segueSetting", sender: nil)
    }
    */
    
    @IBAction func btnStar(_ sender: Any) {
        
        if HelperClass.isInternetAvailable {
            
            var strImageName = ""
            var strTitle = ""
            var strType = ""
            if btnStar.currentTitle == MessageStringFile.unFavourite() {
                strImageName = "favorite_icon"
                strType = WebServiceConstants.unfavourite
                strTitle = MessageStringFile.favourite()
            } else {
                strImageName = "favorite_icon_active"
                strType = WebServiceConstants.favourite
                strTitle = MessageStringFile.unFavourite()
            }
            
            self.aviFavourateIndicator.isHidden = false
            self.viewChatButton.addSubview(self.aviFavourateIndicator)
            self.aviFavourateIndicator.center = self.btnStar.center
            self.aviFavourateIndicator.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
            
            HelperClass.startIgnoringInteractionEvent()
            
            UIView.animate(withDuration: 0.3, animations: {
                self.aviFavourateIndicator.transform = CGAffineTransform.identity
                self.btnStar.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
            }, completion: { (finished) in
                HelperClass.endIgnoringInteractionEvent()
                self.callFavouriteWebservice(strType: strType, strImageName: strImageName, strTitle: strTitle)
            })
        } else {
            self.showAlert(firstLblTitle: MessageStringFile.networkReachability(), secondLblTitle: "")
        }
        
        /*
        if btnStar.currentTitle == MessageStringFile.unFavourite() {
            self.callFavouriteWebservice(strType: WebServiceConstants.favourite, strImageName:"star_yellow", strTitle: MessageStringFile.favourite())
        } else {
            self.callFavouriteWebservice(strType: WebServiceConstants.unfavourite, strImageName:"favorite_icon", strTitle: MessageStringFile.unFavourite())
        }
        */
    }
    
    @IBAction func btnChat(_ sender: Any) {
    }
    
    @IBAction func btnActive(_ sender: Any) {
        
        var strType = ""
        var strTitle = ""
        var actionTitle = ""
        var message = ""
        if btnActive.currentTitle == MessageStringFile.block() {
            strType = WebServiceConstants.block
            strTitle = MessageStringFile.unBlock()
            actionTitle = MessageStringFile.block()
            message = MessageStringFile.blockConfirmation()
        } else {
            strType = WebServiceConstants.unBlock
            strTitle = MessageStringFile.block()
            actionTitle = MessageStringFile.unBlock()
            message = MessageStringFile.unBlockConfirmation()
        }
        
        let actionSheetController = UIAlertController(title: message, message: "", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: MessageStringFile.cancel(), style: .cancel) { action -> Void in
            
        }
        
        let saveActionButton = UIAlertAction(title: actionTitle, style: .default) { action -> Void in
            if HelperClass.isInternetAvailable {
                self.aviBlockIndicator.isHidden = false
                self.viewChatButton.addSubview(self.aviBlockIndicator)
                self.aviBlockIndicator.center = self.btnActive.center
                self.aviBlockIndicator.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
                HelperClass.startIgnoringInteractionEvent()
                UIView.animate(withDuration: 0.3, animations: {
                    self.aviBlockIndicator.transform = CGAffineTransform.identity
                    self.btnActive.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
                }, completion: { (finished) in
                    HelperClass.endIgnoringInteractionEvent()
                    self.callBlockWebservice(strType: strType, strTitle: strTitle)
                })
            } else {
                self.showAlert(firstLblTitle: MessageStringFile.networkReachability(), secondLblTitle: "")
            }
        }
        
        actionSheetController.addAction(cancelActionButton)
        actionSheetController.addAction(saveActionButton)
        
        //actionSheetController.view.tintColor
        self.present(actionSheetController, animated: true, completion: nil)
        
        /*
         alert.view.tintColor = UIColor.brown  // change text color of the buttons
         alert.view.backgroundColor = UIColor.cyan  // change background color
         alert.view.layer.cornerRadius = 25   // change corner radius
         */
    }
    
    @IBAction func btnReport(_ sender: Any) {
        
    }
    
    @IBAction func btnExpandGusetbook(_ sender: Any) {
        flagExpandGuestbook = !flagExpandGuestbook
        var transform: CGAffineTransform = CGAffineTransform.identity
        if flagExpandGuestbook {
            
        } else {
            //transform = CGAffineTransform.identity.rotated(by: CGFloat(M_PI))
            transform = CGAffineTransform.identity.rotated(by: CGFloat(Double.pi))
        }
        
        let tblHeight = self.getGuestbookTableHeight()
        let showViewMoreHeight = self.showViewMoreGuestbookHeight()
        tblGusetbook.reloadData()
        UIView.animate(withDuration: 0.5, animations: { 
            self.btnExpandGusetbook.transform = transform
            self.tblGusetbook.frame.origin.y = self.viewGusetbook.frame.origin.y + self.viewGusetbook.frame.size.height
            self.tblGusetbook.frame.size.height = tblHeight
            self.viewMoreGuestbook.frame.origin.y = self.tblGusetbook.frame.origin.y + self.tblGusetbook.frame.size.height
            self.viewMoreGuestbook.frame.size.height = showViewMoreHeight
            self.viewProfileDetail.frame.size.height = self.viewMoreGuestbook.frame.origin.y + self.viewMoreGuestbook.frame.size.height
            self.svView.contentSize = CGSize(width: 0.0, height: self.viewProfileDetail.frame.origin.y + self.viewProfileDetail.frame.size.height + 50)
        }) { (finished) in
            
        }
        
    }
    
    @IBAction func btnMoreGuestbook(_ sender: Any) {
    }
    
    //MARK:- Webservice
    
    func callFavouriteWebservice(strType: String, strImageName:String, strTitle: String) {
        let userId = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants._id)
        
        let params = [WebServiceConstants.userId: userId, WebServiceConstants.type: strType]
        print("WebServiceLinks.addFavouriteUser >>>>> \(WebServiceLinks.addFavouriteUser)")
        print("params >>>>> \(params)")
        
        HMWebService.createRequestAndGetResponse(WebServiceLinks.addFavouriteUser, methodType: HM_HTTPMethod.POST, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
            
            print("dictResponse >>>>> \(String(describing: dictResponse))")
            print("theReply >>>>> \(String(describing: theReply))")
            
            UIView.animate(withDuration: 0.3, animations: {
                self.aviFavourateIndicator.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
                self.btnStar.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                self.aviFavourateIndicator.removeFromSuperview()
            })
            
            var msg = MessageStringFile.serverError()
            var success = 10
            if dictResponse != nil {
                if dictResponse!.count > 0 {
                    let JSON = dictResponse! as NSDictionary
                    success = JSON.hmGetInt(forKey: WebServiceConstants.success)
                    msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                    if msg == "" {
                        msg = MessageStringFile.serverError()
                    }
                    if success == 1 {
                        self.btnStar.setImage(UIImage(named: strImageName), for: .normal)
                        self.btnStar.setTitle(strTitle, for: .normal)
                    } else{
                        self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                    }
                } else {
                    self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                }
            } else{
                self.showAlert(firstLblTitle: msg, secondLblTitle: "")
            }
        })
    }
    
    func callBlockWebservice(strType: String, strTitle: String) {
        
        let userId = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPrevious, strObject: WebServiceConstants._id)
        let params = [WebServiceConstants.userId: userId, WebServiceConstants.type: strType]
        print("WebServiceLinks.blockUser >>>>> \(WebServiceLinks.blockUser)")
        print("params >>>>> \(params)")
        
        HMWebService.createRequestAndGetResponse(WebServiceLinks.blockUser, methodType: HM_HTTPMethod.POST, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
            
            print("dictResponse >>>>> \(String(describing: dictResponse))")
            print("theReply >>>>> \(String(describing: theReply))")
            
            UIView.animate(withDuration: 0.3, animations: {
                self.aviBlockIndicator.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
                self.btnActive.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                self.aviBlockIndicator.removeFromSuperview()
            })
            
            var msg = MessageStringFile.serverError()
            var success = 10
            if dictResponse != nil {
                if dictResponse!.count > 0 {
                    let JSON = dictResponse! as NSDictionary
                    success = JSON.hmGetInt(forKey: WebServiceConstants.success)
                    msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                    if msg == "" {
                        msg = MessageStringFile.serverError()
                    }
                    if success == 1 {
                        self.btnActive.setTitle(strTitle, for: .normal)
                        self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                    } else{
                        self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                    }
                } else {
                    self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                }
            } else {
                self.showAlert(firstLblTitle: msg, secondLblTitle: "")
            }
        })
        
    }
    
    //MARK:- Segue Methods
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
}
