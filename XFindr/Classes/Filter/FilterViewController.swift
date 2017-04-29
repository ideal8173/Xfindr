//
//  FilterViewController.swift
//  XFindr
//
//  Created by Rajat on 3/25/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, TagViewDelegate, SelectionDelegate,PopUpViewDelegate {
    
    @IBOutlet var cvUsers: UICollectionView!
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    
    @IBOutlet var viewCollectionContent: UIView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblHeader: UILabel!
    @IBOutlet var btnGridView: UIButton!
    @IBOutlet var btnListView: UIButton!
    @IBOutlet var btnSetting: UIButton!
    
    @IBOutlet var svFilter: UIScrollView!
    @IBOutlet var viewContent: UIView!
    @IBOutlet var imgProvider: UIImageView!
    @IBOutlet var imgSeeker: UIImageView!
    @IBOutlet var btnProvider: UIButton!
    @IBOutlet var lblProvider: UILabel!
    @IBOutlet var btnSeeker: UIButton!
    @IBOutlet var lblSeeker: UILabel!
    @IBOutlet var viewService: UIView!
    @IBOutlet var btnResetFilter: UIButton!
    @IBOutlet var btnSave: UIButton!
    @IBOutlet var tfKeyword: UITextField!
    @IBOutlet var lblKeyword: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var tfCity: UITextField!
    
    @IBOutlet var viewUrgentRequirement: UIView!
    @IBOutlet var lblUrgentRequirement: UILabel!
    @IBOutlet var btnUrgentRequirementNo: UIButton!
    @IBOutlet var btnUrgentRequirementYes: UIButton!
    
    let gridFlowLayout = HomeGridFlowLayout()
    let listFlowLayout = HomeListFlowLayout()
    let viewCloudTags = CloudTagView()
    var listOrGrid = true // false for list and true for grid
    var arrUsers = NSMutableArray()
    var arrServices = NSMutableArray()
    
    var page: Int = 1
    var isPageRefresing = false
    //var strUserType = WebServiceConstants.seeker
    var flagSeeker = true
    var flagProvider = true
    var urgentRequirement = WebServiceConstants.no
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tfKeyword.delegate = self
        tfCity.delegate = self
        cvUsers.delegate = self
        cvUsers.dataSource = self
        viewCloudTags.delegate = self
        cvUsers.collectionViewLayout = gridFlowLayout
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.backgroundColor = self.viewHeader.backgroundColor
        self.cvUsers.addSubview(refreshControl)
        self.cvUsers.alwaysBounceVertical = true
        
        btnSave.circleView(UIColor.clear, borderWidth: 0.0)
        viewService.setCornerRadiousAndBorder(PredefinedConstants.grayTextColor, borderWidth: 1.0, cornerRadius: 0.0)
        tfKeyword.setCornerRadiousAndBorder(PredefinedConstants.grayTextColor, borderWidth: 1.0, cornerRadius: 0.0)
        tfCity.setCornerRadiousAndBorder(PredefinedConstants.grayTextColor, borderWidth: 1.0, cornerRadius: 0.0)
        btnResetFilter.circleView(UIColor.clear, borderWidth: 0.0)
        
        let tapOnViewService = UITapGestureRecognizer(target: self, action: #selector(clickOnViewService(_:)))
        tapOnViewService.numberOfTapsRequired = 1
        self.viewService.isUserInteractionEnabled = true
        self.viewService.addGestureRecognizer(tapOnViewService)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //let keyword = "Keyword(s)"
        let keyword = MessageStringFile.keywords()
        let optional = MessageStringFile.optional()
        let full = keyword + " " + optional
        let range = (full as NSString).range(of: optional)
        let attributedString = NSMutableAttributedString(string: full)
        attributedString.addAttribute(NSForegroundColorAttributeName, value:PredefinedConstants.grayTextColor, range: range)
        attributedString.addAttribute(NSFontAttributeName, value:UIFont.systemFont(ofSize: 12.0), range: range)
        lblKeyword.attributedText = attributedString
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        //self.svFilter.removeFromSuperview()
        self.removeAllViews()
    }
    
    func removeAllViews() {
        self.svFilter.removeFromSuperview()
        self.viewCollectionContent.removeFromSuperview()
        self.aviIndicator.removeFromSuperview()
    }
    
    func resetFilterView() {
        
        self.viewHeader.frame.origin.y = 0.0
        
        if arrUsers.count > 0 {
            arrUsers.removeAllObjects()
        }
        if self.arrServices.count > 0 {
            self.arrServices.removeAllObjects()
        }
        self.cvUsers.reloadData()
        
        self.svFilter.frame = CGRect(x: 0.0, y: self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - self.viewHeader.frame.size.height)
        self.svFilter.contentOffset = CGPoint.zero
        self.svFilter.contentSize = CGSize(width: 0.0, height: self.viewContent.frame.origin.y + self.viewContent.frame.size.height + 100)
        
        if !self.svFilter.isDescendant(of: self.view) {
            self.view.addSubview(self.svFilter)
        }
        
        if self.viewCollectionContent.isDescendant(of: self.view) {
            self.viewCollectionContent.removeFromSuperview()
        }
        
        self.flagProvider = true
        self.flagSeeker = true
        self.imgSeeker.isHidden = false
        self.imgProvider.isHidden = false
        self.urgentRequirement = WebServiceConstants.no
        
        self.viewCloudTags.tags.removeAll()
        self.viewCloudTags.removeFromSuperview()
        self.viewCloudTags.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin, .flexibleLeftMargin, .flexibleRightMargin]
        self.viewCloudTags.frame = self.viewService.bounds
        self.viewService.addSubview(self.viewCloudTags)
        updateScrollFrame()
        
        tfCity.text = ""
        tfKeyword.text = ""
        tfKeyword.resignFirstResponder()
        tfCity.resignFirstResponder()
        
        self.btnGridView.alpha = 0.0
        self.btnListView.alpha = 0.0
        self.btnSetting.alpha = 0.0
        
        btnListView.setImage(UIImage(named: "list_icon")?.hmMaskWith(color: UIColor.black), for: UIControlState.normal)
        btnGridView.setImage(UIImage(named: "grid_icon"), for: UIControlState.normal)
        
        listOrGrid = true
        cvUsers.collectionViewLayout = gridFlowLayout
    }
    
    func refresh(_ sender: UIRefreshControl) {
        HMUtilities.hmDelay(delay: 1.0, hmCompletion: {
            sender.endRefreshing()
            self.callListingWebServiceInitialy()
        })
    }
    
    //MARK:- textField
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.frame.origin.y > 220 {
            svFilter.setContentOffset(CGPoint(x: 0, y: textField.frame.origin.y  - 200), animated: false)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK:- WebServices
    
    func callListingWebServiceInitialy() {
        if arrUsers.count > 0 {
            arrUsers.removeAllObjects()
        }
        self.cvUsers.reloadData()
        self.page = 1
        self.isPageRefresing = false
        self.callListingWebservice()
    }
    
    //MARK:- Collection View
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var reuseIdentifier = "HomeCellGrid"
        if !listOrGrid {
            // for list
            reuseIdentifier = "HomeCellList"
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeCell
        let dict = self.arrUsers.hmNSDictionary(atIndex: indexPath.row)
        
        let myId = AppVariables.getUserId()
        let listUserId = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants._id)
        
        // for list
        
        var distanceHeight: CGFloat = 0.0
        
        if listUserId == myId {
            cell.imgOnlineStatus.isHidden = true

            if let btnEdit = cell.btnEdit {
                btnEdit.isHidden = false
            }
            if let btnEdit = cell.btnEdit {
                btnEdit.setCornerRadiousAndBorder(UIColor.white, borderWidth: 1.0, cornerRadius: 1.0)
            }
            
            if let lblDistance = cell.lblDistance {
                lblDistance.isHidden = true
            }
            distanceHeight = 0.0
            
            if let lblName = cell.lblName {
                lblName.isHidden = false
                lblName.text = MessageStringFile.myProfile()
                
                if !listOrGrid {
                    if let lblSpecialService = cell.lblSpecialService {
                        lblName.frame.origin.x = lblSpecialService.frame.origin.x
                    }
                }
            }
            
        } else {
            cell.imgOnlineStatus.isHidden = false
            if let btnEdit = cell.btnEdit {
                btnEdit.isHidden = true
            }
            
            if let lblDistance = cell.lblDistance {
                lblDistance.isHidden = false
            }
            distanceHeight = 20.0
            if let lblName = cell.lblName {
                lblName.isHidden = false
                let name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name)
                
                if name == "" {
                    lblName.text = MessageStringFile.notAvailable()
                } else {
                    lblName.text = name
                }
                
                if !listOrGrid {
                    if let imgOnlineStatus = cell.imgOnlineStatus {
                        lblName.frame.origin.x = imgOnlineStatus.frame.origin.x + imgOnlineStatus.frame.size.width + 8
                    }
                }
            }
        }
        
        let presence_status = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.presence_status).lowercased()
        
        if presence_status == WebServiceConstants.online {
            cell.imgOnlineStatus.backgroundColor = UIColor.green
        } else {
            cell.imgOnlineStatus.backgroundColor = PredefinedConstants.grayTextColor
        }
        cell.imgOnlineStatus.circleView(UIColor.clear, borderWidth: 0.0)
        
        var image = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.images)
        if image == "" {
            let arr = dict.hmGetNSArray(forKey: WebServiceConstants.images)
            if arr.count > 0 {
                image = arr.hmString(atIndex: 0)
            }
        }
        
        if image == "" {
            image = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.image1)
        }
        
        if image == "" {
            image = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.image2)
        }
        
        if image == "" {
            image = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.image3)
        }
        
        if image != "" {
            let strUrl = WebServiceLinks.userImageUrl() + image
            cell.imgUser.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(), options: SDWebImageOptions.retryFailed)
        } else {
            cell.imgUser.image = nil
        }
        
        let user_type = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.user_type)
        
        if let imgSeekerOrProvider = cell.imgSeekerOrProvider {
            if user_type.lowercased() == WebServiceConstants.seeker {
                imgSeekerOrProvider.image = UIImage(named: "seeker_icon")
            } else {
                imgSeekerOrProvider.image = UIImage(named: "provider_icon")
            }
        }
        
        if let lblDistance = cell.lblDistance {
            lblDistance.text = "Distance: "
        }
        
        if let lblSpecialService = cell.lblSpecialService {
            
            lblSpecialService.frame.origin.y = 20.0 + distanceHeight
            if listUserId == myId {
                let services = AppVariables.services(arr: nil, dict: AppVariables.getDictUserDetail()).str
                lblSpecialService.text = services
            } else {
                let services = AppVariables.services(arr: nil, dict: dict).str
                lblSpecialService.text = services
            }
        }
        
        if let lblOther = cell.lblOther {
            lblOther.frame.origin.y = 40.0 + distanceHeight
            var other = ""
            
            if listUserId == myId {
                let services = AppVariables.otherServices(arr: nil, dict: AppVariables.getDictUserDetail()).str
                other = services
            } else {
                let services = AppVariables.otherServices(arr: nil, dict: dict).str
                other = services
            }
            
            let staticOther = MessageStringFile.other() + " :"
            let fullOther = staticOther + " " + other
            let range2 = (fullOther as NSString).range(of: staticOther)
            let attributedString2 = NSMutableAttributedString(string: fullOther)
            attributedString2.addAttribute(NSForegroundColorAttributeName, value: PredefinedConstants.navigationColor , range: range2)
            lblOther.attributedText = attributedString2
        }
        
        if let lblRequirement = cell.lblRequirement {
            lblRequirement.frame.origin.y = 60.0 + distanceHeight
            var requirement = ""
            
            if listUserId == myId {
                let services = AppVariables.servicesRequired(arr: nil, dict: AppVariables.getDictUserDetail()).str
                requirement = services
            } else {
                let services = AppVariables.servicesRequired(arr: nil, dict: dict).str
                requirement = services
            }
            
            let staticRequirement = MessageStringFile.requirement() + ":"
            let fullRequirement = staticRequirement + " " + requirement
            let range3 = (fullRequirement as NSString).range(of: staticRequirement)
            let attributedString3 = NSMutableAttributedString(string:fullRequirement)
            attributedString3.addAttribute(NSForegroundColorAttributeName, value: PredefinedConstants.navigationColor , range: range3)
            lblRequirement.attributedText = attributedString3
        }
        
        if let viewContainer = cell.viewContent {
            if distanceHeight == 0.0 {
                viewContainer.frame.size.height = 80.0
            } else {
                viewContainer.frame.size.height = 100.0
            }
            viewContainer.center.y = cell.imgUser.center.y
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == (arrUsers.count - 1)  {
            if !self.isPageRefresing {
                if self.arrUsers.count % 20 == 0 {
                    self.isPageRefresing = true
                    self.page += 1
                    self.callListingWebservice()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let dict = self.arrUsers.hmNSDictionary(atIndex: indexPath.row)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        vc.dictPrevious = dict
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnchangeCollection(_ sender: Any) {
        self.cvUsers.alpha = 0.0
        listOrGrid = !listOrGrid
        if !listOrGrid {
            self.cvUsers.collectionViewLayout.invalidateLayout()
            self.cvUsers.setCollectionViewLayout(self.listFlowLayout, animated: false)
            btnListView.setImage(UIImage(named: "list_icon"), for: UIControlState.normal)
            btnGridView.setImage(UIImage(named: "grid_icon")?.hmMaskWith(color: UIColor.black), for: UIControlState.normal)
        } else {
            self.cvUsers.collectionViewLayout.invalidateLayout()
            self.cvUsers.setCollectionViewLayout(self.gridFlowLayout, animated: false)
            btnListView.setImage(UIImage(named: "list_icon")?.hmMaskWith(color: UIColor.black), for: UIControlState.normal)
            btnGridView.setImage(UIImage(named: "grid_icon"), for: UIControlState.normal)
        }
        self.cvUsers.reloadData()
        
        UIView.animate(withDuration: 0.5, animations: {
            self.cvUsers.alpha = 1.0
        }, completion: { (completed) in
        })
    }
    
    //MARK:- Button Action
    
    @IBAction func btnProvider(_ sender: Any) {
        //strUserType = WebServiceConstants.provider
        flagProvider = !flagProvider
        if flagProvider {
            self.imgProvider.isHidden = false
        } else {
            self.imgProvider.isHidden = true
        }
    }
    
    @IBAction func btnSeeker(_ sender: Any) {
        flagSeeker = !flagSeeker
        //self.setviewAccToUrgentReq()
        
        if flagSeeker {
            self.viewUrgentRequirement.isHidden = false
            self.imgSeeker.isHidden = false
            self.urgentRequirement = WebServiceConstants.no
            self.viewUrgentRequirement.isHidden = false
            if urgentRequirement.lowercased() == WebServiceConstants.yes {
                btnUrgentRequirementYes.titleLabel?.font = PredefinedConstants.appBoldFont(size: 10.0)
                btnUrgentRequirementNo.titleLabel?.font = PredefinedConstants.appFont(size: 10.0)
            } else {
                btnUrgentRequirementYes.titleLabel?.font = PredefinedConstants.appFont(size: 10.0)
                btnUrgentRequirementNo.titleLabel?.font = PredefinedConstants.appBoldFont(size: 10.0)
            }
        } else {
            self.imgSeeker.isHidden = true
            self.viewUrgentRequirement.isHidden = true
        }
        
    }
    /*
     if !self.viewContent.isDescendant(of: self.view) {
     self.viewContent.frame = CGRect(x: 0.0, y: self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
     self.view.addSubview(self.viewContent)
     }
     self.viewContent.alpha = 0.0
     self.btnListView.alpha = 0.0
     self.btnGridView.alpha = 0.0
     self.btnSetting.alpha = 0.0
     self.viewContent.frame.origin.y = self.view.frame.size.height
     self.viewMap.alpha = 1.0
     UIView.animate(withDuration: 0.5, animations: {
     self.viewContent.alpha = 1.0
     self.viewContent.frame.origin.y = self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height
     self.viewMap.frame.origin.y = -self.view.frame.size.height
     self.viewMap.alpha = 0.0
     self.btnListView.alpha = 1.0
     self.btnGridView.alpha = 1.0
     self.btnSetting.alpha = 1.0
     }) { (finished) in
     self.viewMap.alpha = 1.0
     self.viewMap.removeFromSuperview()
     self.callListingWebServiceInitialy()
     }
     */
    
    @IBAction func btnSave(_ sender: Any) {
        
        if !self.viewCollectionContent.isDescendant(of: self.view) {
            self.viewCollectionContent.frame = CGRect(x: 0.0, y: self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - self.viewHeader.frame.size.height)
            self.view.addSubview(self.viewCollectionContent)
        }
        self.viewCollectionContent.alpha = 0.0
        self.btnListView.alpha = 0.0
        self.btnGridView.alpha = 0.0
        self.btnSetting.alpha = 0.0
        self.svFilter.alpha = 1.0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewCollectionContent.alpha = 1.0
            self.viewCollectionContent.frame.origin.y = self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height
            self.svFilter.frame.origin.y = -self.view.frame.size.height
            self.svFilter.alpha = 0.0
            self.btnListView.alpha = 1.0
            self.btnGridView.alpha = 1.0
            self.btnSetting.alpha = 1.0
        }) { (finished) in
            self.svFilter.alpha = 1.0
            self.svFilter.removeFromSuperview()
            self.callListingWebServiceInitialy()
        }
    }
    
    @IBAction func btnUrgentRequirementNo(_ sender: Any) {
        self.urgentRequirement = WebServiceConstants.no
        btnUrgentRequirementYes.titleLabel?.font = PredefinedConstants.appFont(size: 10.0)
        btnUrgentRequirementNo.titleLabel?.font = PredefinedConstants.appBoldFont(size: 10.0)
    }
    
    @IBAction func btnUrgentRequirementYes(_ sender: Any) {
        self.urgentRequirement = WebServiceConstants.yes
        btnUrgentRequirementYes.titleLabel?.font = PredefinedConstants.appBoldFont(size: 10.0)
        btnUrgentRequirementNo.titleLabel?.font = PredefinedConstants.appFont(size: 10.0)
    }
    
    @IBAction func btnResetFilter(_ sender: Any) {
        resetFilterView()
    }
    
    
    @IBAction func btnGridView(_ sender: Any) {
        if listOrGrid {
            return
        }
        self.btnchangeCollection(btnGridView)
    }
    
    @IBAction func btnListView(_ sender: Any) {
        if !listOrGrid {
            return
        }
        self.btnchangeCollection(btnListView)
    }
    
    @IBAction func btnSetting(_ sender: Any) {

        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func clickOnViewService(_ sender: UITapGestureRecognizer) {
        //SelectionViewController.openSelectionViewController(selectionType: SelectionType.specificServices, fromClass: FromClass.filter, maxSelection: 3, shouldConfirmDelegate: true, inViewController: self, previouslySelectedData: self.arrServices)
    }
    
    // MARK: Methods for Cloud tag view
    
    func tagDismissed(_ tag: TagView) {
        let arrTmp = self.arrServices.mutableCopy() as! NSMutableArray
        if arrTmp.count > 0 {
            for i in 0 ..< arrTmp.count {
                let dict = arrTmp.hmNSDictionary(atIndex: i)
                let name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name).lowercased()
                if name == tag.text.lowercased() {
                    arrTmp.removeObject(at: i)
                    break
                }
            }
        }
        self.arrServices = arrTmp.mutableCopy() as! NSMutableArray
        self.setupCloud()
    }
    
    func tagTouched(_ tag: TagView) {

    }
    
    //MARK: Selection Delegate
    
    func selectedData(selectionType: SelectionType, fromClass: FromClass, arrSelected: NSArray) {
//        if selectionType == .specificServices {
//            self.arrServices = arrSelected.mutableCopy() as! NSMutableArray
//            self.setupCloud()
//        }
    }
    
    func selectionDidCancel() {
        
    }
    
    func setupCloud() {
        viewCloudTags.tags.removeAll()
        viewCloudTags.tags = []
        for i in 0 ..< self.arrServices.count {
            let dict = self.arrServices.hmNSDictionary(atIndex: i)
            let name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name).hm_UppercaseEveryWord
            if name.hm_Length > 0 {
                let btnNew = TagView(text: name)
                btnNew.backgroundColor = PredefinedConstants.navigationColor
                btnNew.tintColor = UIColor.white
                viewCloudTags.tags.append(btnNew)
            }
        }
        updateScrollFrame()
    }
    
    func updateScrollFrame() {
        if viewCloudTags.frame.size.height < 40.0 {
            viewCloudTags.frame.size.height = 40.0
        }
        viewService.frame.size.height = viewCloudTags.frame.size.height
        lblKeyword.frame.origin.y = viewService.frame.origin.y + viewService.frame.size.height + 15.0
        tfKeyword.frame.origin.y = lblKeyword.frame.origin.y + lblKeyword.frame.size.height + 10.0
        lblCity.frame.origin.y = tfKeyword.frame.origin.y + tfKeyword.frame.size.height + 15.0
        tfCity.frame.origin.y = lblCity.frame.origin.y + lblCity.frame.size.height + 10.0
        btnResetFilter.frame.origin.y = tfCity.frame.origin.y + tfCity.frame.size.height + 15.0
        btnSave.frame.origin.y = btnResetFilter.frame.origin.y + btnResetFilter.frame.size.height + 20.0
        
        self.viewContent.frame.size.height = self.btnSave.frame.origin.y + self.btnSave.frame.size.height + 20
        
        self.svFilter.contentSize = CGSize(width: 0.0, height: self.viewContent.frame.origin.y + self.viewContent.frame.size.height + 100)
    }
    
    
    //MARK:- Webservices
    
    func callListingWebservice() {
        
        if HelperClass.isInternetAvailable {
            
            //  pageno,user_id,long,lat
            // user_type(seeker,provider,both),urgent_requirement,services,hastag,city
            //self.strUserType
            
            var strUserType = WebServiceConstants.both
            
            if self.flagProvider && self.flagSeeker {
                strUserType = WebServiceConstants.both
            } else if self.flagSeeker {
                strUserType = WebServiceConstants.seeker
            } else if self.flagProvider {
                strUserType = WebServiceConstants.provider
            }
            
            let userLocation = HMLocationManager.getUserLatLong()
            var lat = userLocation.latitude
            var lng = userLocation.longitude
            
            if lat == 0.0 {
                lat = -89.3985283
            }
            
            if lng == 0.0 {
                lng = 40.6331249
            }

            if self.page == 1 {
                self.viewContent.frame.size.height = self.view.frame.size.height - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                self.view.addSubview(self.aviIndicator)
                self.aviIndicator.center = self.view.center
            } else {
                self.viewContent.frame.size.height = self.view.frame.size.height - 30.0 - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                self.view.addSubview(self.aviIndicator)
                self.aviIndicator.center.x = self.cvUsers.center.x
                self.aviIndicator.frame.origin.y = self.cvUsers.frame.size.height + 5.0
            }
            
            
            let params = [WebServiceConstants.userId: AppVariables.getUserId(), WebServiceConstants.page: "\(self.page)", WebServiceConstants.long: "\(lng)", WebServiceConstants.lat: "\(lat)", WebServiceConstants.user_type: strUserType, WebServiceConstants.urgentRequirement: self.urgentRequirement, WebServiceConstants.services: self.arrServices.hmJsonString(), WebServiceConstants.hashtags: self.tfKeyword.text!, WebServiceConstants.city: self.tfCity.text!, WebServiceConstants.language: MessageStringFile.appLanguage()]
            
            
            print("WebServiceLinks.nearByUser >>>>> \(WebServiceLinks.nearByUser)")
            print("params >>>>> \(params)")
            
            HMWebService.createRequestAndGetResponse(WebServiceLinks.nearByUser, methodType: HM_HTTPMethod.GET, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                
                print("dictResponse >>>>> \(String(describing: dictResponse))")
                print("theReply >>>>> \(String(describing: theReply))")
                
                
                self.viewContent.frame.size.height = self.view.frame.size.height - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                self.aviIndicator.removeFromSuperview()
                //self.viewContent.frame.size.height = self.view.frame.size.height - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                //self.aviIndicator.removeFromSuperview()
                
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
                            let arrResult = JSON.hmGetNSArray(forKey: WebServiceConstants.result)
                            if self.page == 1 {
                                self.arrUsers = arrResult.mutableCopy() as! NSMutableArray
                            } else {
                                let arrTmp = self.arrUsers.mutableCopy() as! NSMutableArray
                                for i in 0 ..< arrResult.count {
                                    let dict = arrResult.hmNSMutableDictionary(atIndex: i)
                                    arrTmp.add(dict)
                                }
                                self.arrUsers = arrTmp.mutableCopy() as! NSMutableArray
                            }
                            
                            self.isPageRefresing = false
                            self.cvUsers.reloadData()
                            self.cvUsers.backgroundView = nil
                            
                            
                            if AppVariables.showCompleteProfilePopup() {
                                PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.noText(), rightBtnTitle: MessageStringFile.yesText(), firstLblTitle: MessageStringFile.pleaseCompleteYourProfile(), secondLblTitle: "")
                                PopUpView.sharedInstance.delegate = self
                            }
                        }
                    }
                }
                
                if success != 1 {
                    if success == 10 {
                        if self.page > 1 {
                            self.page -= 1;
                        }
                        self.isPageRefresing = false
                    } else {
                        self.isPageRefresing = true
                    }
                    
                    if self.arrUsers.count == 0 {
                        self.cvUsers.displayBackgroundText(text: msg, fontStyle: "Helvetica", fontSize: 15.0)
                    } else {
                        self.cvUsers.backgroundView = nil
                    }
                }
            })
        } else {
            self.cvUsers.displayBackgroundText(text: MessageStringFile.networkReachability(), fontStyle: "Helvetica", fontSize: 15.0)
        }
    }
    
    
    
    func showAlert(firstLblTitle: String, secondLblTitle: String){
        PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: firstLblTitle, secondLblTitle: secondLblTitle)
        PopUpView.sharedInstance.delegate = nil
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.cvUsers {
            if self.cvUsers.contentSize.height > self.view.frame.size.height + 150 {
                var headerOrigin: CGFloat = -(scrollView.contentOffset.y * 0.5)
                var alpha: CGFloat = 0.0
                if headerOrigin <= -44 {
                    headerOrigin = -44.0
                } else if headerOrigin > 0 {
                    headerOrigin = 0.0
                }
                alpha = CGFloat(22.0 / fabsf(Float(headerOrigin))) - 1.0
                
                if self.viewHeader.frame.origin.y != headerOrigin {
                    self.btnGridView.alpha = alpha
                    self.btnListView.alpha = alpha
                    self.lblHeader.alpha = alpha
                    self.btnSetting.alpha = alpha
                    self.viewHeader.frame.origin.y = headerOrigin
                    
                    self.viewCollectionContent.frame.origin.y = self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height
                    if self.aviIndicator.isDescendant(of: self.view) {
                        self.viewCollectionContent.frame.size.height = self.view.frame.size.height - 30.0 - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                    } else {
                        self.viewCollectionContent.frame.size.height = self.view.frame.size.height - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                    }
                    
                }
            }
        }
    }
    
    func clickOnPopUpRightButton() {
        
    }
    
    func clickOnPopUpLeftButton() {
        
    }
    
}
