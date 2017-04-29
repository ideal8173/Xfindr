//
//  HomeViewController.swift
//  XFindr
//
//  Created by Rajat on 3/23/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, PopUpViewDelegate {

    @IBOutlet var viewContent: UIView!
    @IBOutlet var cvUsers: UICollectionView!
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var btnGridView: UIButton!
    @IBOutlet var btnListView: UIButton!
    @IBOutlet var btnSetting: UIButton!
    @IBOutlet var lblHeader: UILabel!
    
    let gridFlowLayout = HomeGridFlowLayout()
    let listFlowLayout = HomeListFlowLayout()
    var listOrGrid = true // false for list and true for grid
    
    var arrUsers = NSMutableArray()
    
    var page: Int = 1
    var isPageRefresing = false
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cvUsers.delegate = self
        cvUsers.dataSource = self
        
        cvUsers.collectionViewLayout = gridFlowLayout
        btnListView.setImage(UIImage(named: "list_icon")?.hmMaskWith(color: UIColor.black), for: UIControlState.normal)
        btnGridView.setImage(UIImage(named: "grid_icon"), for: UIControlState.normal)
        
        self.callListingWebServiceInitialy()
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.backgroundColor = self.viewHeader.backgroundColor
        self.cvUsers.addSubview(refreshControl)
        self.cvUsers.alwaysBounceVertical = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.title = "Home"
        //self.tabBarController?.navigationItem.title = "Home"
        self.lblHeader.text = ClassesHeader.home()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBarController?.navigationItem.title = "Home"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    }
    
    func refresh(_ sender: UIRefreshControl) {
        HMUtilities.hmDelay(delay: 1.0, hmCompletion: {
            sender.endRefreshing()
            self.callListingWebServiceInitialy()
        })
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
    
    func callListingWebservice() {
        
        if HelperClass.isInternetAvailable {
            self.cvUsers.backgroundView = nil
//            self.cvUsers.frame.origin.y = self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height
//            if self.page == 1 {
//                self.cvUsers.frame.size.height = self.view.frame.size.height - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
//                self.view.addSubview(self.aviIndicator)
//                self.aviIndicator.center = self.view.center
//            } else {
//                self.cvUsers.frame.size.height = self.view.frame.size.height - 30.0 - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
//                self.view.addSubview(self.aviIndicator)
//                self.aviIndicator.center.x = self.cvUsers.center.x
//                self.aviIndicator.frame.origin.y = self.cvUsers.frame.size.height + 5.0
//            }
            
            self.viewContent.frame.origin.y = self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height
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
            
            /*
            for i in 0 ..< 19 {
                self.arrUsers.add("\(i)")
            }
            self.isPageRefresing = false
            self.cvUsers.reloadData()
            self.cvUsers.backgroundView = nil
            self.aviIndicator.removeFromSuperview()
            */
            
            let userLocation = HMLocationManager.getUserLatLong()
            var lat = userLocation.latitude
            var lng = userLocation.longitude
            
            if lat == 0.0 {
                lat = -89.3985283
            }
            
            if lng == 0.0 {
                lng = 40.6331249
            }
            
            let params = [WebServiceConstants.userId: AppVariables.getUserId(), WebServiceConstants.page: "\(self.page)", WebServiceConstants.long: "\(lng)", WebServiceConstants.lat: "\(lat)", WebServiceConstants.language: MessageStringFile.appLanguage()]
            print("WebServiceLinks.nearByUser >>>>> \(WebServiceLinks.nearByUser)")
            print("params >>>>> \(params)")
            
            HMWebService.createRequestAndGetResponse(WebServiceLinks.nearByUser, methodType: HM_HTTPMethod.GET, andHeaderDict: [:], andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                
                print("dictResponse >>>>> \(String(describing: dictResponse))")
                print("theReply >>>>> \(String(describing: theReply))")
                
                self.viewContent.frame.size.height = self.view.frame.size.height - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                self.aviIndicator.removeFromSuperview()
                
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
                var name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name)
                
                if listOrGrid {
                    name = AppVariables.services(arr: nil, dict: AppVariables.getDictUserDetail()).str
                }
                
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
            
            let staticOther = MessageStringFile.other() + MessageStringFile.colonSymbol()
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
        performSegue(withIdentifier: "segueProfile", sender: dict)
    }
    
    
    @IBAction func btnchangeCollection(_ sender: Any) {
        self.cvUsers.alpha = 0.0
        //.sorted()
        //let visibleCells = self.cvUsers.indexPathsForVisibleItems.sorted()
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
            
            /*
            if visibleCells.count > 0 {
                self.cvUsers.scrollToItem(at: visibleCells[0], at: UICollectionViewScrollPosition.centeredVertically, animated: false)
            }
 */
        }, completion: { (completed) in
        })
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
        performSegue(withIdentifier: "segueSetting", sender: nil)
    }
    
    /*
    var previousScrollViewYOffset: CGFloat = 0.0
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.cvUsers {
            var frame: CGRect = self.viewHeader.frame
            let size: CGFloat = frame.size.height - 21
            let framePercentageHidden: CGFloat = (20 - frame.origin.y) / (frame.size.height - 1)
            let scrollOffset: CGFloat = scrollView.contentOffset.y
            let scrollDiff: CGFloat = scrollOffset - previousScrollViewYOffset
            let scrollHeight: CGFloat = scrollView.frame.size.height
            let scrollContentSizeHeight: CGFloat = scrollView.contentSize.height + scrollView.contentInset.bottom
            //            if scrollOffset <= -scrollView.contentInset.top {
            //                frame.origin.y = 20
            //            }
            //            else if (scrollOffset + scrollHeight) >= scrollContentSizeHeight {
            //                frame.origin.y = -size
            //            }
            //            else {
            //                frame.origin.y = min(20, max(-size, frame.origin.y - scrollDiff))
            //            }
            
            if scrollOffset <= -scrollView.contentInset.top {
                frame.origin.y = 0
            }
            else if (scrollOffset + scrollHeight) >= scrollContentSizeHeight {
                frame.origin.y = -size
            }
            else {
                frame.origin.y = min(20, max(-size, frame.origin.y - scrollDiff))
            }
            
            self.viewHeader.frame = frame
            updateBarButtonItems((1 - framePercentageHidden))
            previousScrollViewYOffset = scrollOffset
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.stoppedScrolling()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.stoppedScrolling()
    }
    
    func stoppedScrolling() {
        let frame: CGRect = self.viewHeader.frame
        if frame.origin.y < 20 {
            //animateNavBar(to: -(frame.size.height - 21))
            animateNavBar(to: 0)
        }
    }
    
    func updateBarButtonItems(_ alpha: CGFloat) {
        self.btnGridView.alpha = alpha
        self.btnListView.alpha = alpha
        self.lblHeader.alpha = alpha
    }
    
    func animateNavBar(to y: CGFloat) {
        UIView.animate(withDuration: 0.2, animations: {() -> Void in
            var frame: CGRect = self.viewHeader.frame
            let alpha: CGFloat = (frame.origin.y >= y ? 0 : 1)
            frame.origin.y = y
            self.viewHeader.frame = frame
            self.updateBarButtonItems(alpha)
        })
    }
    */
    
    /*
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var frame: CGRect = self.viewHeader.frame
        let size: CGFloat = frame.size.height - 21
        if scrollView.panGestureRecognizer.translation(in: view).y < 0 {
            frame.origin.y = -size
        }
        else if scrollView.panGestureRecognizer.translation(in: view).y > 0 {
            frame.origin.y = 0
        }
        
        UIView.beginAnimations("toggleNavBar", context: nil)
        UIView.setAnimationDuration(0.2)
        self.viewHeader.frame = frame
        UIView.commitAnimations()
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        var frame: CGRect = self.viewHeader.frame
        frame.origin.y = 0
        self.viewHeader.frame = frame
    }
    */
    
    
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
                    //                self.cvUsers.frame.origin.y = headerOrigin + headerHeight
                    //                if self.aviIndicator.isDescendant(of: self.view) {
                    //                    self.cvUsers.frame.size.height = self.view.frame.size.height - 30.0 - (headerOrigin + headerHeight)
                    //                } else {
                    //                    self.cvUsers.frame.size.height = self.view.frame.size.height - (headerOrigin + headerHeight)
                    //                }
                    
                    self.viewContent.frame.origin.y = self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height
                    if self.aviIndicator.isDescendant(of: self.view) {
                        //self.viewContent.frame.size.height = self.view.frame.size.height - 30.0 - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                    } else {
                        self.viewContent.frame.size.height = self.view.frame.size.height - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                    }
                    
                }
            }
        }
        /*
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if(translation.y > 0) {
            // react to dragging down
            //print("react to dragging down")
        } else {
            // react to dragging up
            //print("react to dragging up")
        }
        */
        /*
        if (self.lastContentOffset > scrollView.contentOffset.y){
            
        } else if (self.lastContentOffset < scrollView.contentOffset.y) {
            
        }
        
        self.lastContentOffset = scrollView.contentOffset.y
        */
    }
    
    //MARK:- segue methods
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueProfile" {
            let vc = segue.destination as! ProfileViewController
            if let dict = sender as? NSDictionary {
                vc.dictPrevious = dict
            }
        }
    }
    
    //MARK:- PopUp
    
    func clickOnPopUpRightButton() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(vc, animated: true)
        PopUpView.sharedInstance.delegate = nil
    }
    
    func clickOnPopUpLeftButton() {
        
    }
    
}
