//
//  FavoriteViewController.swift
//  XFindr
//
//  Created by Rajat on 3/28/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class FavoriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var cvFavorite: UICollectionView!
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    @IBOutlet var viewContent: UIView!
    @IBOutlet var viewHeader: UIView!
    @IBOutlet var lblHeader: UILabel!
    
    let gridFlowLayout = HomeGridFlowLayout()
    var arrUsers = NSMutableArray()
    var page: Int = 1
    var isPageRefresing = false
    var callingWebservice = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        cvFavorite.delegate = self
        cvFavorite.dataSource = self
        
        cvFavorite.collectionViewLayout = gridFlowLayout
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.backgroundColor = self.viewHeader.backgroundColor
        self.cvFavorite.addSubview(refreshControl)
        self.cvFavorite.alwaysBounceVertical = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        self.lblHeader.text = ClassesHeader.favorites()
        //self.viewContent.frame = CGRect(x: 0.0, y: self.viewHeader.frame.size.height, width: self.view.frame.size.width, height: self.view.frame.size.height - self.viewHeader.frame.size.height)
        self.callListingWebServiceInitialy()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    func refresh(_ sender: UIRefreshControl) {
        HMUtilities.hmDelay(delay: 1.0, hmCompletion: {
            sender.endRefreshing()
            self.callListingWebServiceInitialy()
        })
    }
    
    func resetView() {
        if arrUsers.count > 0 {
            arrUsers.removeAllObjects()
        }
        self.cvFavorite.reloadData()
        self.page = 1
        self.isPageRefresing = false
    }
    
    //MARK:- WebServices
    
    func callListingWebServiceInitialy() {
        if self.callingWebservice {
            return
        }
        if arrUsers.count > 0 {
            arrUsers.removeAllObjects()
        }
        self.cvFavorite.reloadData()
        self.page = 1
        self.isPageRefresing = false
        self.callListingWebservice()
    }
    
    func callListingWebservice() {
        if HelperClass.isInternetAvailable {
            
            if self.callingWebservice {
                return
            }
            
            self.cvFavorite.backgroundView = nil
            if self.page == 1 {
                self.viewContent.frame.size.height = self.view.frame.size.height
                self.viewContent.addSubview(self.aviIndicator)
                self.aviIndicator.center = self.view.center
            } else {
                self.viewContent.frame.size.height = self.view.frame.size.height - 30.0
                self.viewContent.addSubview(self.aviIndicator)
                self.aviIndicator.center.x = self.cvFavorite.center.x
                self.aviIndicator.frame.origin.y = self.cvFavorite.frame.size.height + 5.0
            }
            
            
            let params = [ WebServiceConstants.page: "\(self.page)"]
            print("WebServiceLinks.favouriteUserList >>>>> \(WebServiceLinks.favouriteUserList)")
            print("params >>>>> \(params)")
            callingWebservice = true
            
            HMWebService.createRequestAndGetResponse(WebServiceLinks.favouriteUserList, methodType: HM_HTTPMethod.GET, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                
                print("theReply >>>>> \(String(describing: theReply))")
                print("dictResponse >>>>> \(String(describing: dictResponse))")
                self.callingWebservice = false
                self.viewContent.frame.size.height = (self.view.frame.size.height - self.viewHeader.frame.size.height)
                self.aviIndicator.removeFromSuperview()
                
                var msg = MessageStringFile.serverError()
                var success = 10
                if dictResponse != nil {
                    let JSON = dictResponse! as NSDictionary
                    success = JSON.hmGetInt(forKey: WebServiceConstants.success)
                    msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
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
                        self.cvFavorite.reloadData()
                        self.cvFavorite.backgroundView = nil
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
                        self.cvFavorite.displayBackgroundText(text: msg, fontStyle: "Helvetica", fontSize: 15.0)
                    } else {
                        self.cvFavorite.backgroundView = nil
                    }
                }
            })
        } else {
            if self.arrUsers.count == 0 {
                self.cvFavorite.displayBackgroundText(text: MessageStringFile.networkReachability(), fontStyle: "Helvetica", fontSize: 15.0)
            }
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
        
        let reuseIdentifier = "FavoriteCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FavoriteCell
        let dict = self.arrUsers.hmNSDictionary(atIndex: indexPath.row)
        
        let user_type = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.user_type)
        if user_type == WebServiceConstants.userSelf {
            cell.imgOnlineStatus.isHidden = true
            cell.lblName.text = MessageStringFile.myProfile()
        } else {
            cell.imgOnlineStatus.isHidden = false
            cell.lblName.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.service)
        }
        
        //cell.aviIndicator.center = cell.imgUser.center
        
        let presence_status = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.presence_status).lowercased()
        
        if presence_status == WebServiceConstants.online {
            cell.imgOnlineStatus.backgroundColor = UIColor.green
        } else {
            cell.imgOnlineStatus.backgroundColor = PredefinedConstants.grayTextColor
        }
        cell.imgOnlineStatus.circleView(UIColor.clear, borderWidth: 0.0)
        
        var image = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.favourite_name)
        if image == "" {
            let arr = dict.hmGetNSArray(forKey: WebServiceConstants.favourite_name)
            if arr.count > 0 {
                image = arr.hmString(atIndex: 0)
            }
        }
        
        if image == "" {
            image = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.favourite_image)
        }
        
        if image != "" {
            let strUrl = WebServiceLinks.userImageUrl() + image
            cell.imgUser.sd_setImage(with: URL(string: strUrl), placeholderImage: UIImage(), options: SDWebImageOptions.retryFailed)
        } else {
            cell.imgUser.image = nil
        }
        
        if let lblName = cell.lblName {
            let name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.favourite_name)
            
            if name == "" {
                lblName.text = MessageStringFile.notAvailable()
            } else {
                lblName.text = name
            }
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
        //let dict = self.arrUsers.hmNSDictionary(atIndex: indexPath.row)
        //performSegue(withIdentifier: "segueProfile", sender: dict)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        /*
        if scrollView == self.cvFavorite {
            if self.cvFavorite.contentSize.height > self.view.frame.size.height + 150 {
                var headerOrigin: CGFloat = -(scrollView.contentOffset.y * 0.5)
                var alpha: CGFloat = 0.0
                if headerOrigin <= -44 {
                    headerOrigin = -44.0
                } else if headerOrigin > 0 {
                    headerOrigin = 0.0
                }
                alpha = CGFloat(22.0 / fabsf(Float(headerOrigin))) - 1.0
                
                if self.viewHeader.frame.origin.y != headerOrigin {
                    self.viewHeader.frame.origin.y = headerOrigin
                    self.lblHeader.alpha = alpha
                    self.viewContent.frame.origin.y = self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height
                    if self.aviIndicator.isDescendant(of: self.view) {
                        self.viewContent.frame.size.height = self.view.frame.size.height - 30.0 - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                    } else {
                        self.viewContent.frame.size.height = self.view.frame.size.height - (self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height)
                    }
                    
                }
            }
        }
*/
    }
    
}


