//
//  SettingViewController.swift
//  XFindr
//
//  Created by Rajat on 4/12/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SettingCellDelegate {

    @IBOutlet var tblView: UITableView!
    
    var arrAccount: [SettingItems] = []
    var arrPreference: [SettingItems] = []
    var arrAbout: [SettingItems] = []
    var arrReset: [SettingItems] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblView.delegate = self
        tblView.dataSource = self
        // Do any additional setup after loading the view.
        //tblView.reloadData()
        
        setNavigation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tblView.alpha = 0.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        setNavigation()
        setupArrays()
        tblView.reloadData()
        
        UIView.animate(withDuration: 0.3) { 
            self.tblView.alpha = 1.0
        }
        
        /*
        tblView.beginUpdates()
        tblView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
        tblView.reloadSections(IndexSet(integer: 1), with: UITableViewRowAnimation.automatic)
        tblView.reloadSections(IndexSet(integer: 2), with: UITableViewRowAnimation.automatic)
        tblView.reloadSections(IndexSet(integer: 3), with: UITableViewRowAnimation.automatic)
        tblView.endUpdates()
        */
        
    }
    
    func setNavigation() {
        self.title = ClassesHeader.settings()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func setupArrays() {
        arrAccount = [SettingItems(cellType: SettingCellType.typeDetailWithData, title: MessageStringFile.email(), isLoading: false, data: AppVariables.getEmail(), serverKey: ""), SettingItems(cellType: SettingCellType.typeDetailWithData, title: MessageStringFile.mobileNumber(), isLoading: false, data: AppVariables.getMobileNumber(), serverKey: ""), SettingItems(cellType: SettingCellType.typeDetail, title: MessageStringFile.changePassword(), isLoading: false, serverKey: ""), SettingItems(cellType: SettingCellType.typeDetail, title: MessageStringFile.notifications(), isLoading: false, serverKey: "")]
        
        arrPreference = [SettingItems(cellType: SettingCellType.typeSwitch, title: MessageStringFile.showMyDistance(), isLoading: false, switchStatus: AppVariables.getBool(forKey: WebServiceConstants.distance), serverKey:  WebServiceConstants.distance), SettingItems(cellType: SettingCellType.typeButton, title: MessageStringFile.unitSystem(), isLoading: false, data: AppVariables.getString(forKey: WebServiceConstants.unitSystem), serverKey: WebServiceConstants.unitSystem), SettingItems(cellType: SettingCellType.typeSwitch, title: MessageStringFile.sound(), isLoading: false, switchStatus: AppVariables.getBool(forKey: WebServiceConstants.soundStatus), serverKey: WebServiceConstants.soundStatus), SettingItems(cellType: SettingCellType.typeSwitch, title: MessageStringFile.pushNotification(), isLoading: false, switchStatus: AppVariables.getBool(forKey: WebServiceConstants.notificationStatus), serverKey: WebServiceConstants.notificationStatus), SettingItems(cellType: SettingCellType.typeSwitch, title: MessageStringFile.showMyGuestbook(), isLoading: false, switchStatus: AppVariables.getBool(forKey: WebServiceConstants.guestStatus), serverKey: WebServiceConstants.guestStatus), SettingItems(cellType: SettingCellType.typeButton, title: MessageStringFile.applicationLanguage(), isLoading: false, data: MessageStringFile.languages(), serverKey: "")]
        
        //, SettingItems(cellType: SettingCellType.typeSwitch, title: MessageStringFile.beFollowed(), isLoading: false, switchStatus: AppVariables.getBool(forKey: WebServiceConstants.followedStatus))
        
        arrAbout = [SettingItems(cellType: SettingCellType.typeDetail, title: MessageStringFile.support(), isLoading: false, serverKey: ""), SettingItems(cellType: SettingCellType.typeDetail, title: MessageStringFile.termsOfServices(), isLoading: false, serverKey: ""), SettingItems(cellType: SettingCellType.typeDetail, title: MessageStringFile.privacyPolicy(), isLoading: false, serverKey: "")]
        
        arrReset = [SettingItems(cellType: SettingCellType.typeDetail, title: MessageStringFile.unblockAll(), isLoading: false, serverKey: ""), SettingItems(cellType: SettingCellType.typeDetail, title: MessageStringFile.deleteProfile(), isLoading: false, serverKey: ""), SettingItems(cellType: SettingCellType.typeDetail, title: MessageStringFile.logout(), isLoading: false, serverKey: "")]
        
    }
    
    func logoutFromApp() {
        XFindrUserDefaults.setUserLoginStatus(status: nil)
        AppVariables.setDictUserDetail(nil)
        if AppVariables.isUserLoginWithFacebook() {
            HMFacebookLogin.hmLogoutFromFacebook()
        }
        let _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arrAccount.count
        } else if section == 1 {
            return arrPreference.count
        } else if section == 2 {
            return arrAbout.count
        } else if section == 3 {
            return arrReset.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var arr: [SettingItems] = []
        if indexPath.section == 0 {
            arr = arrAccount
        } else if indexPath.section == 1 {
            arr = arrPreference
        } else if indexPath.section == 2 {
            arr = arrAbout
        } else if indexPath.section == 3 {
            arr = arrReset
        }
        
        if arr.count > 0 {
            var reusedIdentifier = "SettingDetailDataCell"
            
            let settingItem = arr[indexPath.row]
            if settingItem.cellType == .typeDetailWithData {
                reusedIdentifier = "SettingDetailDataCell"
            } else if settingItem.cellType == .typeDetail {
                reusedIdentifier = "SettingDetailCell"
            } else if settingItem.cellType == .typeButton {
                reusedIdentifier = "SettingButtonCell"
            } else if settingItem.cellType == .typeSwitch {
                reusedIdentifier = "SettingSwitchCell"
            }
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reusedIdentifier) as! SettingCell
            cell.delegate = self
            cell.indexPath = indexPath
            cell.lblTitle.text = settingItem.title
            
            if let lblDivider = cell.lblDivider {
                if arr.count - 1 == indexPath.row {
                    lblDivider.isHidden = true
                } else {
                    lblDivider.isHidden = false
                }
            }
            
            if settingItem.cellType == .typeDetailWithData {
                if let lblData = cell.lblData, let data = settingItem.data {
                    lblData.text = data
                }
            } else if settingItem.cellType == .typeButton {
                if let button1 = cell.button1, let button2 = cell.button2, let aviIndicator = cell.aviIndicator {
                    button1.circleView(UIColor.clear, borderWidth: 0.0)
                    button2.circleView(UIColor.clear, borderWidth: 0.0)
                    if settingItem.title == MessageStringFile.unitSystem() {
                        button1.setTitle(UnitSystem.miles.rawValue.hm_UppercaseFirst, for: UIControlState.normal)
                        button2.setTitle(UnitSystem.metric.rawValue.hm_UppercaseFirst, for: UIControlState.normal)
                        
                        var unitSystem = UnitSystem.miles.rawValue
                        if let data = settingItem.data {
                            unitSystem = data
                        }
                        
                        if unitSystem == UnitSystem.metric.rawValue {
                            button2.backgroundColor = PredefinedConstants.navigationColor
                            button2.titleLabel?.textColor = UIColor.white
                            button1.backgroundColor = PredefinedConstants.settingButtonBackgroundColor
                            button1.titleLabel?.textColor = PredefinedConstants.settingButtonTextColor
                        } else {
                            button1.backgroundColor = PredefinedConstants.navigationColor
                            button1.titleLabel?.textColor = UIColor.white
                            button2.backgroundColor = PredefinedConstants.settingButtonBackgroundColor
                            button2.titleLabel?.textColor = PredefinedConstants.settingButtonTextColor
                        }
                    } else if settingItem.title == MessageStringFile.applicationLanguage() {
                        button1.setTitle(MessageStringFile.english().hm_UppercaseFirst, for: UIControlState.normal)
                        button2.setTitle(MessageStringFile.french().hm_UppercaseFirst, for: UIControlState.normal)
                        
                        if MessageStringFile.applicationLanguage() == AppLanguage.fr.rawValue {
                            button2.backgroundColor = PredefinedConstants.navigationColor
                            button2.titleLabel?.textColor = UIColor.white
                            button1.backgroundColor = PredefinedConstants.settingButtonBackgroundColor
                            button1.titleLabel?.textColor = PredefinedConstants.settingButtonTextColor
                        } else {
                            button1.backgroundColor = PredefinedConstants.navigationColor
                            button1.titleLabel?.textColor = UIColor.white
                            button2.backgroundColor = PredefinedConstants.settingButtonBackgroundColor
                            button2.titleLabel?.textColor = PredefinedConstants.settingButtonTextColor
                        }
                    }
                    
                    
                    
                    if settingItem.isLoading {
                        button1.isHidden = true
                        button2.isHidden = true
                        aviIndicator.isHidden = false
                    } else {
                        button1.isHidden = false
                        button2.isHidden = false
                        aviIndicator.isHidden = true
                    }
                }
            } else if settingItem.cellType == .typeSwitch {
                if let swithcValue = cell.swithcValue, let switchStatus = settingItem.switchStatus, let aviIndicator = cell.aviIndicator {
                    if switchStatus {
                        swithcValue.setOn(true, animated: false)
                    } else {
                        swithcValue.setOn(false, animated: false)
                    }
                    
                    if settingItem.isLoading {
                        swithcValue.isHidden = true
                        aviIndicator.isHidden = false
                    } else {
                        swithcValue.isHidden = false
                        aviIndicator.isHidden = true
                    }
                }
            }
            
            if let imgArrow = cell.imgArrow {
                imgArrow.image = UIImage(named: "ic_right_arrow")?.hmMaskWith(color: PredefinedConstants.dividerLineColor)
            }
            
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "DefaultCell")
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x:0, y: 0, width: tableView.frame.size.width, height: 40))
        var headerString = ""
        
        if section == 0 {
            headerString = MessageStringFile.account()
        } else if section == 1 {
            headerString = MessageStringFile.preference()
        } else if section == 2 {
            headerString = MessageStringFile.about()
        } else if section == 3 {
            headerString = MessageStringFile.reset()
        }
        
        let lbl = UILabel(frame: CGRect(x: 8, y: 10, width: tableView.frame.size.width - 16, height: 30)) as UILabel
        lbl.font = PredefinedConstants.appFont(size: 15.0)
        lbl.center.y = headerView.center.y
        lbl.textColor = PredefinedConstants.navigationColor
        lbl.text  = headerString
        lbl.backgroundColor = UIColor.clear
        
        headerView.addSubview(lbl)
        
        headerView.backgroundColor = self.view.backgroundColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var arr: [SettingItems] = []
        if indexPath.section == 0 {
            arr = arrAccount
        } else if indexPath.section == 1 {
            arr = arrPreference
        } else if indexPath.section == 2 {
            arr = arrAbout
        } else if indexPath.section == 3 {
            arr = arrReset
        }
        
        if arr.count > 0 {
            
            let settingItem = arr[indexPath.row]
            let title = settingItem.title
            if title == MessageStringFile.logout() {
                self.logoutFromApp()
            } else if title == MessageStringFile.changePassword() {
                performSegue(withIdentifier: "segueChangePassword", sender: nil)
            }
        }
    }
    
    // MARK: Cell Delegates
    
    func didClickOnSwitch(indexPath: IndexPath) {
        self.callWebservice(indexPath: indexPath, index: nil)
    }
    
    func didClickOnButton(indexPath: IndexPath, index: Int) {
        self.callWebservice(indexPath: indexPath, index: index)
    }
    
    //MARK: Call Webservice
    
    func callWebservice(indexPath: IndexPath, index: Int?) {
        if HelperClass.isInternetAvailable {
            var arr: [SettingItems] = []
            if indexPath.section == 0 {
                arr = arrAccount
            } else if indexPath.section == 1 {
                arr = arrPreference
            } else if indexPath.section == 2 {
                arr = arrAbout
            } else if indexPath.section == 3 {
                arr = arrReset
            }
            
            let settingItem = arr[indexPath.row]
            
            if settingItem.title == MessageStringFile.applicationLanguage() {
                return
            }
            
            var value: String = "false"
            
            if let i = index {
                if settingItem.serverKey == WebServiceConstants.unitSystem {
                    if i == 1 {
                        value = UnitSystem.miles.rawValue
                    } else {
                        value = UnitSystem.metric.rawValue
                    }
                } else {
                    return
                }
                
                if let aaa = settingItem.data {
                    if value == aaa {
                        return
                    }
                }
            } else {
                if let aaa = settingItem.switchStatus {
                    if aaa == true {
                        value = "false"
                    } else {
                        value = "true"
                    }
                }
            }
            
            settingItem.isLoading = true
            
            if indexPath.section == 0 {
                arrAccount = arr
            } else if indexPath.section == 1 {
                arrPreference = arr
            } else if indexPath.section == 2 {
                arrAbout = arr
            } else if indexPath.section == 3 {
                arrReset = arr
            }
            
            self.tblView.beginUpdates()
            self.tblView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            self.tblView.endUpdates()
            
            let key = settingItem.serverKey
            
            if key == "" {
                return
            }
            
            let params = [key: value]
            print("params >>>> \(params)")
            HMWebService.createRequestAndGetResponse(WebServiceLinks.setting, methodType: HM_HTTPMethod.POST, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: params, onCompletion: { (dictResponse, error, theReply) in
                print("theReply >>>> \(String(describing: theReply))")
                if dictResponse!.count > 0 {
                    let JSON: NSDictionary = dictResponse! as NSDictionary
                    var msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                    if msg == "" {
                        msg = MessageStringFile.serverError()
                    }
                    if JSON.hmGetInt(forKey: WebServiceConstants.success) == 1 {
                        settingItem.isLoading = false
                        if settingItem.switchStatus != nil {
                            if value == "false" {
                                settingItem.switchStatus = false
                                AppVariables.updateDictUserDetail(forKey: key, value: false)
                            } else if value == "true" {
                                settingItem.switchStatus = true
                                AppVariables.updateDictUserDetail(forKey: key, value: true)
                            }
                        } else if settingItem.data != nil {
                            settingItem.data = value
                            AppVariables.updateDictUserDetail(forKey: key, value: value)
                        }
                    } else {
                        self.showAlert(firstLblTitle: msg, secondLblTitle: "")
                    }
                } else {
                    self.showAlert(firstLblTitle: MessageStringFile.serverError(), secondLblTitle: "")
                }
                self.tblView.beginUpdates()
                self.tblView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                self.tblView.endUpdates()
            })
        } else {
            self.showAlert(firstLblTitle: MessageStringFile.networkReachability(), secondLblTitle: "")
        }
    }
    
    func showAlert(firstLblTitle: String, secondLblTitle: String){
        PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: firstLblTitle, secondLblTitle: secondLblTitle)
        PopUpView.sharedInstance.delegate = nil
    }
    
    //MARK: Segue
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
}

class SettingItems: NSObject {
    var cellType: SettingCellType = .typeDetail
    var title: String = ""
    var serverKey: String = ""
    var isLoading: Bool = false
    var data: String? = nil
    var switchStatus: Bool? = nil
    
    init(cellType: SettingCellType, title: String, isLoading: Bool, serverKey: String) {
        self.cellType = cellType
        self.title = title
        self.isLoading = isLoading
        self.serverKey = serverKey
    }
    
    init(cellType: SettingCellType, title: String, isLoading: Bool, data: String?, serverKey: String) {
        self.cellType = cellType
        self.title = title
        self.isLoading = isLoading
        self.data = data
        self.serverKey = serverKey
    }
    
    init(cellType: SettingCellType, title: String, isLoading: Bool, switchStatus: Bool?, serverKey: String) {
        self.cellType = cellType
        self.title = title
        self.isLoading = isLoading
        self.switchStatus = switchStatus
        self.serverKey = serverKey
    }
    
    init(cellType: SettingCellType, title: String, isLoading: Bool, data: String?, switchStatus: Bool?, serverKey: String) {
        self.cellType = cellType
        self.title = title
        self.isLoading = isLoading
        self.data = data
        self.switchStatus = switchStatus
        self.serverKey = serverKey
    }
}
