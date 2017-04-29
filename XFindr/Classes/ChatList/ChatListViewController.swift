//
//  ChatListViewController.swift
//  XFindr
//
//  Created by Rajat on 3/27/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tblUsers: UITableView!
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    @IBOutlet var viewStatusBar: UIView!
    var segmentedControl: HMSegmentedControl!
    
    var arrUsers = NSMutableArray()
    var page: Int = 1
    var isPageRefresing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblUsers.delegate = self
        tblUsers.dataSource = self
        //HMUtilities.hmDefaultMainQueue {
            self.setupSegmentControl()
        //}
     
        callListingWebServiceInitialy()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        refreshControl.backgroundColor = viewStatusBar.backgroundColor
        self.tblUsers.addSubview(refreshControl)
        self.tblUsers.alwaysBounceVertical = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh(_ sender: UIRefreshControl) {
        HMUtilities.hmDelay(delay: 1.0, hmCompletion: {
            sender.endRefreshing()
            self.callListingWebServiceInitialy()
        })
    }
    
    func callListingWebServiceInitialy() {
        if arrUsers.count > 0 {
            arrUsers.removeAllObjects()
        }
        self.tblUsers.reloadData()
        self.page = 1
        self.isPageRefresing = false
        self.callListingWebservice()
    }
    
    func callListingWebservice() {
        if HelperClass.isInternetAvailable {
            self.tblUsers.backgroundView = nil
            
            self.segmentedControl.isUserInteractionEnabled = false
            
            if self.page == 1 {
                self.tblUsers.backgroundView = self.aviIndicator
                self.aviIndicator.center = self.tblUsers.center
            } else {
                let uiview = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tblUsers.frame.size.width, height: 30))
                self.aviIndicator.center = uiview.center
                uiview.addSubview(self.aviIndicator)
                self.tblUsers.tableFooterView = uiview
            }
            
            let params = [WebServiceConstants._id: AppVariables.getUserId(), WebServiceConstants.page: "\(self.page)"]
            
            HMWebService.createRequestAndGetResponse(WebServiceLinks.userList, methodType: HM_HTTPMethod.GET, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                print("dictResponse >>>>> \(String(describing: dictResponse))")
                print("theReply >>>>> \(String(describing: theReply))")
                
                if self.page == 1 {
                    self.tblUsers.backgroundView = nil
                } else {
                    self.tblUsers.tableFooterView = nil
                }
                self.segmentedControl.isUserInteractionEnabled = true
                
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
                            let arrResult = JSON.hmGetNSMutableArray(forKey: WebServiceConstants.result).mutableCopy() as! NSMutableArray
                            
                            for i in 0 ..< arrResult.count {
                                let dict = arrResult.hmNSMutableDictionary(atIndex: i)
                                let otherUserId = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants._id)
                                let chatData = HMDatabase.getLastMessageFromDatabasePrivateChatTableWith(AppVariables.getChatUserIdNameAndImage().userId, otherUserId: otherUserId)
                                dict.hmSet(object: chatData, forKey: "chatData")
                                arrResult.replaceObject(at: i, with: dict)
                            }
                            
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
                            self.tblUsers.reloadData()
                            self.tblUsers.backgroundView = nil
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
                        self.tblUsers.displayBackgroundText(text: msg, fontStyle: "Helvetica", fontSize: 15.0)
                    } else {
                        self.tblUsers.backgroundView = nil
                    }
                }
                
            })
            
            
            /*
            HMUtilities.hmDelay(delay: 3.0, hmCompletion: {
                
                self.segmentedControl.isUserInteractionEnabled = true
                let arrTmp = NSMutableArray()
                for i in 0 ..< self.page * 20 {
                    arrTmp.add("\(i)")
                }
                self.isPageRefresing = false
                self.arrUsers = arrTmp.mutableCopy() as! NSMutableArray
                self.tblUsers.reloadData()
                let range = NSMakeRange(0,  self.tblUsers.numberOfSections - 1)
                 self.tblUsers.reloadSections(NSIndexSet(indexesIn: range) as IndexSet, with: .automatic)
            })
            */
        } else {
            self.tblUsers.displayBackgroundText(text: MessageStringFile.networkReachability(), fontStyle: "Helvetica", fontSize: 15.0)
        }
    }
    
    func setupSegmentControl() {
        segmentedControl = HMSegmentedControl(sectionTitles: ["All", "Unreades", "Favorites"])
        segmentedControl.autoresizingMask = [.flexibleWidth, .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        segmentedControl.frame = CGRect(x: 0.0, y: 20.0, width: self.view.frame.size.width, height: 44.0)
        segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0.0, 10.0, 0.0, 10.0)
        segmentedControl.selectionStyle = HMSegmentedControlSelectionStyle.fullWidthStripe
        segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocation.down
        segmentedControl.selectionIndicatorHeight = 2
        segmentedControl.isVerticalDividerEnabled = false
        segmentedControl.selectionIndicatorColor = UIColor.white
        segmentedControl.backgroundColor = viewStatusBar.backgroundColor
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.selectedTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        segmentedControl.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white.withAlphaComponent(0.7)]
        segmentedControl.addTarget(self, action: #selector(self.segmentChanged(_:)), for: UIControlEvents.valueChanged)
        self.view.addSubview(segmentedControl)
        //self.tblUsers.tableHeaderView = self.segmentedControl
    }
    
    func segmentChanged(_ sender: HMSegmentedControl) {
        let index = sender.selectedSegmentIndex

        if index == 0 {
            
        } else if index == 1 {
            
        } else {
            
        }
        
        callListingWebServiceInitialy()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return arrUsers.count
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 1
        return arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListCell
        cell.imgUser.circleView(UIColor.clear, borderWidth: 0.0)
        cell.imgStatus.circleView(UIColor.clear, borderWidth: 0.0)
        
        let dict = self.arrUsers.hmNSDictionary(atIndex: indexPath.row)
        
        let presence_status = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.presence_status).lowercased()
        if presence_status == WebServiceConstants.online {
            cell.imgStatus.backgroundColor = UIColor.green
        } else {
            cell.imgStatus.backgroundColor = PredefinedConstants.grayTextColor
        }
        
        cell.lblName.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name)
        
        let chatData = dict.hmGetNSDictionary(forKey: "chatData")
        cell.lblLastMessage.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: chatData, strObject: hmDB.showMessage)
        
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
        
        if let imgArrow = cell.imgArrow {
            imgArrow.image = UIImage(named: "ic_right_arrow")?.hmMaskWith(color: UIColor.black)
        }
        
        cell.selectionStyle = .none
        if indexPath.row == (arrUsers.count - 1)  {
            if !self.isPageRefresing {
                if self.arrUsers.count % 20 == 0 {
                    self.isPageRefresing = true
                    self.page += 1
                    self.callListingWebservice()
                }
            }
        }
        /*
        if indexPath.section == (arrUsers.count - 1)  {
            if !self.isPageRefresing {
                if self.arrUsers.count % 20 == 0 {
                    self.isPageRefresing = true
                    self.page += 1
                    self.callListingWebservice()
                }
            }
        }
        */
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dict = self.arrUsers.hmNSDictionary(atIndex: indexPath.row)
        let otherUserId = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants._id)
        let otherUserName = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name)
        
        var otherUserImage = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.images)
        if otherUserImage == "" {
            let arr = dict.hmGetNSArray(forKey: WebServiceConstants.images)
            if arr.count > 0 {
                otherUserImage = arr.hmString(atIndex: 0)
            }
        }
        
        if otherUserImage == "" {
            otherUserImage = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.image1)
        }
        
        if otherUserImage == "" {
            otherUserImage = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.image2)
        }
        
        if otherUserImage == "" {
            otherUserImage = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.image3)
        }
        
        AppVariables.setDictChat(otherUserId: otherUserId, otherUserName: otherUserName, otherUserImage: otherUserImage)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HMChatViewController")
        self.navigationController?.pushViewController(vc!, animated: true)
//        self.present(vc!, animated: true) { 
//            
//        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            
        }
    }
    /*
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let vw = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.tblUsers.frame.size.width, height: 10.0))
        vw.backgroundColor = UIColor.clear
        return vw
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    */
}
