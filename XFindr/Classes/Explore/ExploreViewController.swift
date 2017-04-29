//
//  ExploreViewController.swift
//  XFindr
//
//  Created by Rajat on 4/12/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit
import MapKit

class ExploreViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, HMLocationManagerDelegate {

    @IBOutlet var viewMap: UIView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var imgSelectAddress: UIImageView!
    @IBOutlet var lblExploreHere: UILabel!
    @IBOutlet var viewSearch: UIView!
    @IBOutlet var tfSearch: UITextField!
    
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    
    @IBOutlet var viewContent: UIView!
    @IBOutlet var cvUsers: UICollectionView!
    
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var btnGridView: UIButton!
    @IBOutlet var btnListView: UIButton!
    @IBOutlet var btnSetting: UIButton!
    @IBOutlet var lblHeader: UILabel!
    
    let gridFlowLayout = HomeGridFlowLayout()
    let listFlowLayout = HomeListFlowLayout()
    var listOrGrid = true // false for list and true for grid
    
    var arrUsers = NSMutableArray()
    var searchCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0.0, 0.0)
    
    var page: Int = 1
    var isPageRefresing = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        
        self.cvUsers.delegate = self
        self.cvUsers.dataSource = self
        self.tfSearch.delegate = self
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.backgroundColor = self.viewHeader.backgroundColor
        self.cvUsers.addSubview(refreshControl)
        self.cvUsers.alwaysBounceVertical = true
        
        let tapOnExploreHere = UITapGestureRecognizer(target: self, action: #selector(clickOnExploreHere(_:)))
        tapOnExploreHere.numberOfTapsRequired = 1
        self.lblExploreHere.isUserInteractionEnabled = true
        self.lblExploreHere.addGestureRecognizer(tapOnExploreHere)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.lblHeader.text = ClassesHeader.explore()
        //self.setupViewInitially()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        HMLocationManager.setupHMLocationManagerDelegate(delegate: nil)
        self.resetView()
    }
    
    func refresh(_ sender: UIRefreshControl) {
        HMUtilities.hmDelay(delay: 1.0, hmCompletion: {
            sender.endRefreshing()
            self.callListingWebServiceInitialy()
        })
    }
    
    func setupViewInitially() {
        
        HMUtilities.hmDefaultMainQueue {
            self.resetView()
            if !self.viewMap.isDescendant(of: self.view) {
                self.viewMap.frame = CGRect(x: 0.0, y: self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.view.addSubview(self.viewMap)
            }
            self.mapView.frame = self.viewMap.bounds
            self.tfSearch.placeholder = MessageStringFile.enterACityOrAnAddress()
            self.lblExploreHere.text = MessageStringFile.exploreHere()
            self.imgSelectAddress.center = self.mapView.center
            //self.imgSelectAddress.backgroundColor = UIColor.red
            //        self.imgSelectAddress.frame.origin.y = self.mapView.center.y - self.imgSelectAddress.frame.size.height
            //self.imgSelectAddress.frame.origin.y = ((self.mapView.frame.origin.y + self.mapView.frame.size.height) * 0.5) - (self.imgSelectAddress.frame.size.height * 0.5)
            self.imgSelectAddress.frame.origin.y = self.mapView.center.y - (self.imgSelectAddress.frame.size.height * 3 / 4)
            self.lblExploreHere.frame.origin.y = self.imgSelectAddress.frame.origin.y
            self.lblExploreHere.center.x = self.imgSelectAddress.center.x
            self.lblExploreHere.circleView(UIColor.clear, borderWidth: 0.0)
            HMLocationManager.setupHMLocationManagerDelegate(delegate: self)
            self.centerMapToUserLocation(animation: false)
        }
    }
    
    func resetView() {
        self.viewHeader.frame.origin.y = 0.0
        self.lblHeader.alpha = 1.0
        if self.arrUsers.count > 0 {
            self.arrUsers.removeAllObjects()
        }
        
        self.cvUsers.reloadData()
        listOrGrid = true
        cvUsers.collectionViewLayout = gridFlowLayout
        btnListView.setImage(UIImage(named: "list_icon")?.hmMaskWith(color: UIColor.black), for: UIControlState.normal)
        btnGridView.setImage(UIImage(named: "grid_icon"), for: UIControlState.normal)
        
        btnListView.alpha = 0.0
        btnGridView.alpha = 0.0
        btnSetting.alpha = 0.0
        
        if self.viewContent.isDescendant(of: self.view) {
            self.viewContent.removeFromSuperview()
        }
        
        if self.viewMap.isDescendant(of: self.view) {
            self.viewMap.removeFromSuperview()
        }
        
        
        
//        if !self.viewMap.isDescendant(of: self.viewMap) {
//            self.viewMap.frame = CGRect(x: 0.0, y: 64.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//            self.view.addSubview(self.viewMap)
//        }
    }
    
    func centerMapToUserLocation(animation: Bool) {
        let userLocation = HMLocationManager.getUserLatLong()
        if userLocation.latitude != 0.0 && userLocation.longitude != 0.0 {
            let regionRadius: CLLocationDistance = 1000
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(userLocation, regionRadius * 2.0, regionRadius * 2.0)
            //HMUtilities.hmDefaultMainQueue {
                self.mapView.setRegion(coordinateRegion, animated: animation)
            //}
        }
        
        //let center = self.mapSelect.centerCoordinate
    }
    
    func clickOnExploreHere(_ sender: UITapGestureRecognizer) {
        searchCoordinate = self.mapView.centerCoordinate
        
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
    }
    
    @IBAction func btnCurrentLocation(_ sender: Any) {
        tfSearch.resignFirstResponder()
        self.centerMapToUserLocation(animation: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Map Delegates
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        self.setupFrameWhenMapSwipe(true)
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.setupFrameWhenMapSwipe(false)
    }
    
    func hmLocationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func setupFrameWhenMapSwipe(_ status: Bool) {
        if status {
            UIView.animate(withDuration: 0.4, animations: {
                self.lblExploreHere.frame.size.width = 0.0
                //self.lblExploreHere.frame.size.height = 0.0
                //self.lblExploreHere.frame.origin.y = self.imgSelectAddress.frame.origin.y + (35.0 * 0.5)
                self.lblExploreHere.center.x = self.imgSelectAddress.center.x
                self.lblExploreHere.circleView(UIColor.clear, borderWidth: 0.0)
                self.lblExploreHere.alpha = 0.5
            })
        } else {
            //self.lblExploreHere.text = MessageStringFile.exploreHere()
            UIView.animate(withDuration: 0.4, animations: {
                self.lblExploreHere.frame.size.width = 200.0
                //self.lblExploreHere.frame.size.height = 35.0
                //self.lblExploreHere.frame.origin.y = self.imgSelectAddress.frame.origin.y
                self.lblExploreHere.center.x = self.imgSelectAddress.center.x
                self.lblExploreHere.circleView(UIColor.clear, borderWidth: 0.0)
                self.lblExploreHere.alpha = 1.0
            })
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
        
        print("dict >>>>> \(dict)")
        print("myId >>>>> \(myId)")
        print("listUserId >>>>> \(listUserId)")
        
        
        // for list
        //cell.lblService.isHidden = true
        
        
        var distanceHeight: CGFloat = 0.0
        
        if listUserId == myId {
            cell.imgOnlineStatus.isHidden = true
            //cell.lblService.text = "My Profile"
            if let btnEdit = cell.btnEdit {
                btnEdit.isHidden = false
            }
            if let btnEdit = cell.btnEdit {
                btnEdit.setCornerRadiousAndBorder(UIColor.white, borderWidth: 1.0, cornerRadius: 1.0)
            }
            
            //            if let lblService = cell.lblService {
            //                lblService.isHidden = false
            //            }
            
            
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
            //            if let lblService = cell.lblService {
            //                lblService.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.service)
            //            }
            
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
            //let arr = dict.hmGetNSArray(forKey: WebServiceConstants.services)
            //lblSpecialService.text = arr.componentsJoined(by: ", ")
            
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
            //            let arr = dict.hmGetNSArray(forKey: WebServiceConstants.otherService)
            //            lblOther.text = arr.componentsJoined(by: ", ")
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
            //            let arr = dict.hmGetNSArray(forKey: WebServiceConstants.serviceRequirement)
            //            lblRequirement.text = arr.componentsJoined(by: ", ")
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
        //performSegue(withIdentifier: "segueSetting", sender: nil)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingViewController") as! SettingViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
                    
                    self.viewContent.frame.origin.y = self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height
                    if self.aviIndicator.isDescendant(of: self.view) {
                        self.viewContent.frame.size.height = self.view.frame.size.height - 30.0 - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                    } else {
                        self.viewContent.frame.size.height = self.view.frame.size.height - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                    }
                    
                }
            }
        }
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
            self.viewContent.frame.origin.y = self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height
            if self.page == 1 {
                self.viewContent.frame.size.height = self.view.frame.size.height - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                self.viewContent.addSubview(self.aviIndicator)
                self.aviIndicator.center = self.viewContent.center
            } else {
                self.viewContent.frame.size.height = self.view.frame.size.height - 30.0 - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                self.view.addSubview(self.aviIndicator)
                self.aviIndicator.center.x = self.cvUsers.center.x
                self.aviIndicator.frame.origin.y = self.cvUsers.frame.size.height + 5.0
            }

            var lat = searchCoordinate.latitude
            var lng = searchCoordinate.longitude
            
            if lat == 0.0 {
                lat = -89.3985283
            }
            
            if lng == 0.0 {
                lng = 40.6331249
            }
            
            let params = [WebServiceConstants.userId: AppVariables.getUserId(), WebServiceConstants.page: "\(self.page)", WebServiceConstants.long: "\(lng)", WebServiceConstants.lat: "\(lat)", WebServiceConstants.language: MessageStringFile.appLanguage()]
            print("WebServiceLinks.nearByUser >>>>> \(WebServiceLinks.nearByUser)")
            print("params >>>>> \(params)")
            
            HMWebService.createRequestAndGetResponse(WebServiceLinks.nearByUser, methodType: HM_HTTPMethod.GET, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                
                
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

}
