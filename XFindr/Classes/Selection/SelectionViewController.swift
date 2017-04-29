//
//  SelectionViewController.swift
//  XFindr
//
//  Created by Rajat on 4/6/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

protocol SelectionDelegate {
    func selectedData(selectionType: SelectionType, fromClass: FromClass, arrSelected: NSArray)
    func selectionDidCancel()
}

class SelectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    @IBOutlet var viewHeader: UIView!
    @IBOutlet var viewMaxCount: UIView!
    @IBOutlet var lblMaxCount: UILabel!
    @IBOutlet var viewSerch: UIView!
    @IBOutlet var tfSearch: UITextField!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var aviIndicator: UIActivityIndicatorView!
    @IBOutlet var btnRetry: UIButton!
    @IBOutlet var viewRetry: UIView!
    @IBOutlet var lblRetry: UILabel!
    
    @IBOutlet var btnBarCancel: UIBarButtonItem!
    @IBOutlet var btnBarSave: UIBarButtonItem!
    
    var selectionType: SelectionType = .language
    var fromClass: FromClass = .editProfile
    var delegate: SelectionDelegate?
    var arrData = NSMutableArray()
    var maxSelection: Int = 0
    //fileprivate var dictResponse = NSDictionary()
    var arrPreSelected = NSArray()
    fileprivate var arrFullData = NSArray()
    var shakeIndexPath: IndexPath? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tblView.delegate = self
        tblView.dataSource = self
        tfSearch.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.reloadAllViews()
        self.setNavigation()
        self.callWebservice()
    }
    
    func setNavigation() {
        if selectionType == .city {
            self.title = ClassesHeader.city()
        } else if selectionType == .language {
            self.title = ClassesHeader.languages()
        } else {
            self.title = ClassesHeader.services()
        }
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func tfSearchAction(_ sender: Any) {
//        let arrResult = dictResponse.hmGetNSMutableArray(forKey: WebServiceConstants.result)
//        for i in 0 ..< arrResult.count {
//            let dict = arrResult.hmNSMutableDictionary(atIndex: i)
//            dict.hmSet(object: 0, forKey: "status")
//            arrResult.replaceObject(at: i, with: dict)
//        }
//        self.arrData = arrResult.mutableCopy() as! NSMutableArray
//        self.tblView.reloadData()
        
        let search = ValidatorClasses.trimString(tempString: tfSearch.text!).lowercased()
        var arrSearch = NSMutableArray()
        if search.hm_Length > 0 {
            for i in 0 ..< self.arrFullData.count {
                let dict = self.arrFullData.hmNSDictionary(atIndex: i)
                let name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name).lowercased()
                if name.range(of: search) != nil {
                   arrSearch.add(dict)
                }
            }
        } else {
            arrSearch = self.arrFullData as! NSMutableArray
        }
        
        self.arrData = arrSearch.mutableCopy() as! NSMutableArray
        self.tblView.reloadData()
    }
    
    
    func callWebservice() {
        
        if HelperClass.isInternetAvailable {
            var webserviceStr = WebServiceLinks.languageList
            //if selectionType == .specificServices || selectionType == .otherServices || selectionType == .requiredServices || selectionType == .provideServices
            if selectionType == .services {
                webserviceStr = WebServiceLinks.serviceList
            } else if selectionType == .city {
                webserviceStr = WebServiceLinks.cityList
            }
            
            self.view.addSubview(self.aviIndicator)
            self.aviIndicator.center = self.view.center
            
            HMWebService.createRequestAndGetResponse(webserviceStr, methodType: HM_HTTPMethod.GET, andHeaderDict: AppVariables.getHeaderDictionary(), andParameterDict: [:], onCompletion: { (dictResponse, error, theReply) in
              
                var success: Int = 10
                print("theReply >>>>>> \(String(describing: theReply))")
                print("error >>>>>> \(String(describing: error))")
                print("dictResponse >>>>>> \(String(describing: dictResponse))")
                
                self.aviIndicator.removeFromSuperview()
                var msg = MessageStringFile.serverError()
                if dictResponse!.count > 0 {
                    
                    let JSON: NSDictionary = dictResponse! as NSDictionary
                    msg = HelperClass.checkObjectInDictionary(dictH: JSON, strObject: WebServiceConstants.msg)
                    if msg == "" {
                        msg = MessageStringFile.serverError()
                    }
                    success = JSON.hmGetInt(forKey: WebServiceConstants.success)
                    if success == 1 {
                        let arrResult = JSON.hmGetNSMutableArray(forKey: WebServiceConstants.result)
                        for i in 0 ..< arrResult.count {
                            let dict = arrResult.hmNSMutableDictionary(atIndex: i)
                            var name = ""
                            var status: Int = 0
                            
                            for j in 0 ..< self.arrPreSelected.count {
                                let dictPreSelected = self.arrPreSelected.hmNSDictionary(atIndex: j)
                                var preSelectedName = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPreSelected, strObject: WebServiceConstants._id)
                                name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants._id)
                                if preSelectedName.hm_Length == 0 {
                                    preSelectedName = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictPreSelected, strObject: WebServiceConstants.name)
                                    name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name)
                                }
                                
                                if name == preSelectedName {
                                    status = 1
                                }
                            }
                            
                            dict.hmSet(object: status, forKey: "status")
                            arrResult.replaceObject(at: i, with: dict)
                        }
                        self.arrData = arrResult.mutableCopy() as! NSMutableArray
                        self.arrFullData = arrResult
                        self.tblView.reloadData()
                        if self.arrData.count > 0 {
                            self.addSuccessViews()
                        } else {
                            success = 0
                        }
                    } else {

                    }
                } else {
                    
                }
                if success != 1 {
                    self.addErrorView(success: success, msg: msg)
                }
            })
        } else {
            self.addErrorView(success: 10, msg: MessageStringFile.networkReachability())
        }
    }
    
    func reloadAllViews() {
        viewMaxCount.removeFromSuperview()
        viewSerch.removeFromSuperview()
        tblView.removeFromSuperview()
        aviIndicator.removeFromSuperview()
        viewRetry.removeFromSuperview()
    }
    
    func addSuccessViews() {
        var maxViewHeight: CGFloat = 0.0
        var maxViewY: CGFloat = self.viewHeader.frame.size.height + 10.0
        if maxSelection > 0 {
            var msg = ""
            /*
            if selectionType == .specificServices {
                msg = MessageStringFile.specificServicesOrSkillsThatYouProvide()
            } else if selectionType == .otherServices {
                msg = MessageStringFile.otherServicesOrSkillsThatYouCanProvide()
            } else if selectionType == .requiredServices {
                msg = MessageStringFile.servicesOrSkillsThatYouMayRequire()
            } else if selectionType == .provideServices {
                msg = MessageStringFile.servicesOrSkillsThatYouMayProvide()
            } else if selectionType == .city {
                
            } else if selectionType == .language {
                msg = MessageStringFile.languages()
            }
            */
            
            if self.maxSelection < 1 {
                msg = ""
            } else {
                msg = "\(MessageStringFile.maximum().lowercased()) \(self.maxSelection)"
            }
            
            if msg != "" {
                self.viewMaxCount.frame = CGRect(x: 0.0, y: self.viewHeader.frame.origin.y + self.viewHeader.frame.size.height, width: self.view.frame.size.width, height: 50.0)
                self.view.addSubview(self.viewMaxCount)
                self.lblMaxCount.frame.size.width = self.viewMaxCount.frame.size.width - 16.0
                //+ " (\(MessageStringFile.maximum().lowercased()) \(Int(self.maxSelection)))"
                self.lblMaxCount.text = msg
                self.lblMaxCount.numberOfLines = 0
                self.lblMaxCount.lineBreakMode = .byWordWrapping
                self.lblMaxCount.sizeToFit()
                
                self.viewMaxCount.frame.size.height = self.lblMaxCount.frame.size.height + 20.0
                self.lblMaxCount.frame.origin.y = 10.0
                self.lblMaxCount.frame.origin.x = 8.0
                self.lblMaxCount.frame.size.width = self.viewMaxCount.frame.size.width - 16.0
                
                maxViewHeight = self.viewMaxCount.frame.size.height
                maxViewY = self.viewMaxCount.frame.origin.y
            }
        }
        
        var searchHeight: CGFloat = 0.0
        var searchY: CGFloat = maxViewY + maxViewHeight
        //if selectionType == .specificServices || selectionType == .otherServices || selectionType == .requiredServices || selectionType == .provideServices
        if selectionType == .services {
            tfSearch.placeholder = MessageStringFile.searchServices()
        } else if selectionType == .city {
            tfSearch.placeholder = MessageStringFile.searchCity()
        } else if selectionType == .language {
            tfSearch.placeholder = MessageStringFile.searchLanguage()
        }
        
        self.viewSerch.frame = CGRect(x: 8.0, y: maxViewY + maxViewHeight, width: self.view.frame.size.width - 16.0, height: self.viewSerch.frame.size.height)
        self.view.addSubview(self.viewSerch)
        searchHeight = self.viewSerch.frame.size.height
        searchY = self.viewSerch.frame.origin.y

        self.tblView.frame = CGRect(x: 8.0, y: searchY + searchHeight + 10, width: self.view.frame.size.width - 16.0, height: self.view.frame.size.height - (searchY + searchHeight + 20))
        self.view.addSubview(self.tblView)
    }
    
    func addErrorView(success: Int, msg: String) {
        
        var lblY: CGFloat = 5.0
        
        if success == 0 {
            lblY = 5.0
        } else {
            self.btnRetry.frame = CGRect(x: 0.0, y: 0.0, width: self.btnRetry.frame.size.width, height: self.btnRetry.frame.size.height)
            self.viewRetry.addSubview(self.btnRetry)
            self.btnRetry.center.x = self.viewRetry.center.x
            
            lblY += self.btnRetry.frame.size.height
        }
        
        self.viewRetry.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50)
        self.lblRetry.frame.size.width = self.viewRetry.frame.size.width - 16.0
        self.lblRetry.frame.origin.y = lblY
        self.lblRetry.frame.origin.x = 8.0
        self.lblRetry.text = msg
        self.lblRetry.numberOfLines = 0
        self.lblRetry.lineBreakMode = .byWordWrapping
        self.lblRetry.sizeToFit()
        self.lblRetry.frame.size.width = self.viewRetry.frame.size.width - 16.0
        self.viewRetry.frame.size.height = self.lblRetry.frame.origin.y + self.lblRetry.frame.size.height + 5.0
        
        self.view.addSubview(self.viewRetry)
        self.viewRetry.center = self.view.center
        
    }
    
    //MARK:TableviewDelegate/Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrData.count > 0 {
            return arrData.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell") as! SelectionCell
        let dict = self.arrData.hmNSMutableDictionary(atIndex: indexPath.row)
        cell.lblName.text = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants.name).hm_UppercaseEveryWord
        cell.imgCheckUncheck.circleView(UIColor.clear, borderWidth: 0.0)
        if dict.hmGetInt(forKey: "status") == 1 {
            cell.imgCheckUncheck.image = UIImage(named: "check_in_icon")
            cell.imgCheckUncheck.backgroundColor = UIColor.clear
        } else {
            cell.imgCheckUncheck.image = nil
            cell.imgCheckUncheck.backgroundColor = PredefinedConstants.uncheckColor
        }
        
        if let shakeIndexPath = self.shakeIndexPath {
            if shakeIndexPath == indexPath {
                HMUtilities.hmDelay(delay: 0.05, hmCompletion: {
                    cell.shake123(duration: 0.5)
                    self.lblMaxCount.textColor = UIColor.red
                    HMUtilities.hmDelay(delay: 0.5, hmCompletion: {
                        self.lblMaxCount.textColor = UIColor.black
                    })
                })
                self.shakeIndexPath = nil
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var shouldUpdate = false
        let arrTmp = self.arrData.mutableCopy() as! NSMutableArray
        let dict = self.arrData.hmNSMutableDictionary(atIndex: indexPath.row)
        
        if maxSelection == 1 {
            let arrSelected = NSMutableArray()
            let dictMutable = dict.mutableCopy() as! NSMutableDictionary
            dictMutable.hmReomoveObject(forKey: "status")
            arrSelected.add(dictMutable)
            delegate?.selectedData(selectionType: self.selectionType, fromClass: self.fromClass, arrSelected: arrSelected)
            self.dismissView()
        }
        
        if maxSelection != 0 {
            var checkCount: Int = 0
            for i in 0 ..< self.arrData.count {
                let dictCell = self.arrData.hmNSDictionary(atIndex: i)
                if dictCell.hmGetInt(forKey: "status") == 1 {
                    if HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants._id) == HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictCell, strObject: WebServiceConstants._id) {
                    } else {
                        checkCount += 1
                    }
                }
            }
            if checkCount < maxSelection {
                shouldUpdate = true
            }
        } else {
            shouldUpdate = true
        }
        
        if shouldUpdate {
            var status = dict.hmGetInt(forKey: "status")
            if status == 0 {
                status = 1
            } else {
                status = 0
            }
            dict.hmSet(object: status, forKey: "status")
            arrTmp.replaceObject(at: indexPath.row, with: dict)
            self.arrData = arrTmp.mutableCopy() as! NSMutableArray
            tblView.reloadData()
            
            let arrFullTmp = self.arrFullData.mutableCopy() as! NSMutableArray
            for i in 0 ..< arrFullTmp.count {
                let dictAA = arrFullTmp.hmNSDictionary(atIndex: i)
                if HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: WebServiceConstants._id) == HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictAA, strObject: WebServiceConstants._id) {
                    //dictAA.hmSet(object: status, forKey: "status")
                    arrFullTmp.replaceObject(at: i, with: dict)
                }
                
                self.arrFullData = arrFullTmp
            }
        } else {
            shakeIndexPath = indexPath
            tblView.reloadData()
        }
    }
    
    func showAlert(firstLblTitle: String, secondLblTitle: String){
        PopUpView.addPopUpAlertView("", leftBtnTitle: MessageStringFile.okText(), rightBtnTitle: "", firstLblTitle: firstLblTitle, secondLblTitle: secondLblTitle)
        PopUpView.sharedInstance.delegate = nil
    }
    
    class func openSelectionViewController(selectionType: SelectionType, fromClass: FromClass, maxSelection: Int, shouldConfirmDelegate status: Bool, inViewController vc: UIViewController, previouslySelectedData arrPreSelected: NSArray) {
        
        let selectionViewController = vc.storyboard?.instantiateViewController(withIdentifier: "SelectionViewController") as! SelectionViewController
        selectionViewController.selectionType = selectionType
        selectionViewController.fromClass = fromClass
        selectionViewController.maxSelection = maxSelection
        selectionViewController.arrPreSelected = arrPreSelected
        
        if status == true {
            if let ddd = vc as? SelectionDelegate {
                selectionViewController.delegate = ddd
            }
        }
        
        let animation = CATransition()
        animation.type = kCATransitionPush
        animation.subtype = kCATransitionFromTop
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        vc.navigationController?.view.layer.add(animation, forKey: "AnimationFromBottomToTop")
        vc.navigationController?.pushViewController(selectionViewController, animated: false)
        
    }
    
    func dismissView() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFromBottom
        self.navigationController?.view.layer.add(transition, forKey: nil)
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func btnBarCancel(_ sender: Any) {
        self.dismissView()
    }
    
    @IBAction func btnBarSave(_ sender: Any) {
        let arrSelected = NSMutableArray()
        for i in 0 ..< self.arrFullData.count {
            let dict = self.arrFullData.hmNSDictionary(atIndex: i)
            if dict.hmGetInt(forKey: "status") == 1 {
                let dictMutable = dict.mutableCopy() as! NSMutableDictionary
                dictMutable.hmReomoveObject(forKey: "status")
                arrSelected.add(dictMutable)
            }
        }
        
        delegate?.selectedData(selectionType: self.selectionType, fromClass: self.fromClass, arrSelected: arrSelected)
        self.dismissView()
    }
    
    @IBAction func btnRetry(_ sender: Any) {
        self.reloadAllViews()
        self.callWebservice()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
