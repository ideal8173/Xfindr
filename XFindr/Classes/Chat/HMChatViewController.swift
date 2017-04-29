//
//  HMChatViewController.swift
//  XFindr
//
//  Created by Honey Maheshwari on 4/19/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class HMChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, HMInputViewDelegate, HMSocketDelegate, HMChatImageCellDelegate {

    @IBOutlet var viewHeader: UIView!
    @IBOutlet var imgUser: UIImageView!
    @IBOutlet var lblName: SMIconLabel!
    @IBOutlet var lblStatus: SMIconLabel!
    @IBOutlet var btnReport: UIButton!
    var tblChat: UITableView!
    var messageInputView: HMInputView!
    /*
    var viewUserDetails: UIView!
    var imgUser: UIImageView!
    var lblName: UILabel!
    var lblStatus: UILabel!
    var btnBack: UIBarButtonItem!
    var btnReport: UIButton!
    */
    
    var keyboardDismissTapGesture: UITapGestureRecognizer!
    
    var arrMessages = NSMutableArray()
    
    var hmReloadState: HMReloadStatus = .reload
    var imagePicker: UIImagePickerController? = UIImagePickerController()
    var showLoadEarlierMsgButton = false
    
    var timerTyping: Timer?
    var isUserTyping: HMUserTyping!
    let tableY: CGFloat = 64.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupChatTableView()
        self.view.addSubview(tblChat)
        
        self.messageInputView = HMInputView(appearance: HMInputViewAppearance.default)
        self.messageInputView.hmDelegate = self
        self.view.addSubview(self.messageInputView)
        
        isUserTyping = HMUserTyping.notTyping
        self.setNavigation()
        //self.addRightBarView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        imagePicker = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addOrRemoveKeyboardNotification(true)
        keyboardDismissTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        HMSocket.setupDelegate(inViewController: self)
        isUserTyping = HMUserTyping.notTyping
    }

    override func viewDidAppear(_ animated: Bool) {
        if hmReloadState == HMReloadStatus.reload {
            // get messages from datbase
            self.arrMessages = NSMutableArray()
            self.loadearliermessages()
        }
        hmReloadState = HMReloadStatus.reload
        self.setNavigation()
        //self.addRightBarView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.addOrRemoveKeyboardNotification(false)
        if hmReloadState == HMReloadStatus.reload {
            HMSocket.removeDelegate()
            AppVariables.removeChatData()
        }
    }
    
    func setNavigation() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    /*
    func addRightBarView() {
        self.navigationItem.leftBarButtonItems = nil
        self.navigationItem.rightBarButtonItems = nil
        viewUserDetails = nil
        lblName = nil
        lblStatus = nil
        imgUser = nil
        
        viewUserDetails = UIView()
        lblName = UILabel()
        lblStatus = UILabel()
        imgUser = UIImageView()
        
        if PredefinedConstants.screenWidth == 320 {
            self.viewUserDetails.frame = CGRect(x: 0, y: 20.0, width:  self.view.frame.size.width - 50, height: 44.0)
        } else if PredefinedConstants.screenWidth == 375 {
            self.viewUserDetails.frame = CGRect(x: 0, y: 20.0, width: self.view.frame.size.width, height: 44.0)
        } else {
            self.viewUserDetails.frame = CGRect(x: 0, y: 20.0, width: self.view.frame.size.width + 30, height: 44.0)
        }
        self.viewUserDetails.backgroundColor = UIColor.clear
        self.imgUser.frame = CGRect(x: 55.0, y: 2.5, width: 40.0, height: 40.0)
        self.imgUser.layer.cornerRadius = self.imgUser.frame.size.height / 2
        self.imgUser.layer.masksToBounds = true
        self.imgUser.layer.borderColor = UIColor.white.cgColor
        self.imgUser.layer.borderWidth = 0.7
        self.viewUserDetails.addSubview(self.imgUser)
        self.lblName.frame = CGRect(x: self.imgUser.frame.origin.x + self.imgUser.frame.size.width + 5, y: 0.0, width: self.view.frame.size.width - 100, height: 25.0)
        self.lblName.backgroundColor = UIColor.clear
        self.lblName.font = UIFont.boldSystemFont(ofSize: 16.0)
        self.lblName.textColor = UIColor.white
        self.lblName.text = AppVariables.getCurrentChatUserData().otherUserName
        self.lblStatus.frame = CGRect(x:self.imgUser.frame.origin.x + self.imgUser.frame.size.width + 5, y: 25.0, width: self.view.frame.size.width - 100, height: 20)
        self.lblStatus.backgroundColor = UIColor.clear
        self.lblStatus.font = UIFont.systemFont(ofSize: 14.0)
        self.lblStatus.textColor = UIColor.white
        //self.lblStatus.text = "Online"
        self.viewUserDetails.addSubview(self.lblName)
        self.viewUserDetails.addSubview(self.lblStatus)
        //self.viewUserDetails.backgroundColor = UIColor.redColor()
        
        self.btnBack = UIBarButtonItem(image: UIImage(named: "backChat"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnBack(_ :)))
        self.btnBack.imageInsets = UIEdgeInsetsMake(0.0, -7.0, 0.0, 0.0)
        
//backChat
        
        ///
        let rightNavBarButton = UIBarButtonItem(customView: self.viewUserDetails)
        let rightReport = UIBarButtonItem(customView: btnReport)
        self.navigationItem.setLeftBarButton(self.btnBack, animated: true)
        self.navigationItem.setRightBarButtonItems([rightNavBarButton, rightReport], animated: true)
        //self.navigationItem.titleView = self.viewUserDetails
        
        //BackIcon
        
    }
    
    */
    
    func loadearliermessages() {
        
        var time = HMDateTime.getCurrentTimeInSeconds()
        let count = self.arrMessages.count
        if count > 0 {
            let msg = self.arrMessages.object(at: 0) as! HMMessage
            time = msg.timeInSeconds
        }

        let currentData = AppVariables.getCurrentChatUserData()
        let otherId = currentData.otherUserId
        let arrNewMsg = HMDatabase.getChatDataFromPrivateChatTableWithPagination(currentData.userId, otherUserId: otherId, time: time).mutableCopy() as! NSMutableArray
        
        if arrNewMsg.count % hmDB.pageCount == 0 && arrNewMsg.count > 0 {
            showLoadEarlierMsgButton = true
        } else {
            showLoadEarlierMsgButton = false
        }
        
        let arrNewAddedMessages = arrNewMsg.mutableCopy() as! NSMutableArray
        
        for i in 0 ..< self.arrMessages.count {
            arrNewAddedMessages.add(self.arrMessages.object(at: i))
        }
        
        self.arrMessages = arrNewAddedMessages.mutableCopy() as! NSMutableArray
        
        if count == 0 {
            self.reloadChatTable()
            self.scrollToBottom(false)
        } else {
            var currentOffset = tblChat.contentOffset
            let contentSizeBeforeInsert = tblChat.contentSize
            self.reloadChatTable()
            let contentSizeAfterInsert = tblChat.contentSize
            let deltaHeight = contentSizeAfterInsert.height - contentSizeBeforeInsert.height - 70
            currentOffset.y = max(deltaHeight, 0)
            tblChat.setContentOffset(currentOffset, animated: false)
        }
    }
    
    func reloadChatTable() {
        self.tblChat.reloadData()
    }
    
    func getStatusBarExtraHeight() -> CGFloat {
        if UIApplication.shared.statusBarFrame.size.height > 20 {
            return 20.0
        }
        return 0.0
    }
    
    // MARK: - Setup

    func setupChatTableView() {

        tblChat = UITableView(frame: CGRect(x: 0.0, y: self.tableY, width: self.view.frame.size.width, height: self.view.frame.size.height - HMChatConstants.defaultInputViewHeight - self.tableY))
        tblChat.delegate = self
        tblChat.dataSource = self
        tblChat.separatorStyle = .none
        //tblChat!.allowsSelection = false
        tblChat!.allowsSelection = true
        //tblChat!.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, HMChatConstants.DefaultInputViewHeight, 0)
    }
    
    //MARK: - Keyboard
    
    func addOrRemoveKeyboardNotification(_ status: Bool) {
        if status == true {
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillToggle(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillToggle(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillToggle(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        } else {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
    }
    
    func keyboardWillToggle(_ notification: Notification) {
        if notification.name == NSNotification.Name.UIKeyboardWillShow {
            keyboardDismissTapGesture.cancelsTouchesInView = true;
            self.view.addGestureRecognizer(keyboardDismissTapGesture)
        } else if notification.name == NSNotification.Name.UIKeyboardWillHide {
            self.view.removeGestureRecognizer(keyboardDismissTapGesture)
        } else if notification.name == NSNotification.Name.UIKeyboardWillChangeFrame {
            if let userInfo = (notification as NSNotification).userInfo {
                let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue
                let keyFrame = (userInfo[UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
                let keyboradOriginY = min(keyFrame!.origin.y, ScreenSize.height)
                let inputBarHeight = messageInputView.frame.height

                UIView.animate(withDuration: duration!, animations: {
                    self.tblChat.frame = CGRect(x: 0, y: self.tableY, width: ScreenSize.width, height: keyboradOriginY - inputBarHeight - self.tableY)
                    self.messageInputView.frame.origin.y = keyboradOriginY - inputBarHeight
                    if self.isLastRowVisible() == true {
                        self.scrollToBottom(true)
                    }
                }, completion: { (finished) in
                    if finished {
                        if self.messageInputView.inputTextView.isFirstResponder {
                        }
                    }
                })
            }
        }
    }
    
    func hideKeyboard() {
        messageInputView.hmResignFirstResponder()
    }
    
    // MARK: - Image Picker
    
    func askForImageOperation() {
        
        let alert:UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        let cameraAction = UIAlertAction(title: MessageStringFile.camera(), style: UIAlertActionStyle.default)  {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: MessageStringFile.gallery(), style: UIAlertActionStyle.default)  {
            UIAlertAction in
            self.openGallary(false)
        }
        let cancelAction = UIAlertAction(title: MessageStringFile.cancel(), style: UIAlertActionStyle.cancel)  {
            UIAlertAction in
        }
        
        alert.addAction(cancelAction)
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openCamera() {
        if imagePicker == nil {
            imagePicker = UIImagePickerController()
        }
        imagePicker?.delegate = self
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker?.mediaTypes = [kUTTypeImage as String]
            imagePicker!.sourceType = UIImagePickerControllerSourceType.camera
            hmReloadState = HMReloadStatus.imagePicker
            self.present(imagePicker!, animated: true, completion: nil)
        }  else  {
            openGallary(false)
        }
        
    }
    
    func openGallary(_ isVideo: Bool) {
        if imagePicker == nil {
            imagePicker = UIImagePickerController()
        }
        imagePicker?.delegate = self
        if isVideo {
            imagePicker?.allowsEditing = true
            imagePicker?.mediaTypes = [kUTTypeMovie as String]
        } else {
            imagePicker?.allowsEditing = false
            imagePicker?.mediaTypes = [kUTTypeImage as String]
        }
        imagePicker!.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if UIDevice.current.userInterfaceIdiom == .phone {
            hmReloadState = HMReloadStatus.imagePicker
            self.present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    // MARK: - Image Picker Delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        print("info >>>>> \(info)")
        
        if let mediaType = info[UIImagePickerControllerMediaType] as? String {
            print("mediaType >>>> \(mediaType)")
            if mediaType == kUTTypeImage as String {
                var newImage: UIImage? = nil
                if let possibleImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                    newImage = possibleImage
                } else if let possibleImage = info[UIImagePickerControllerEditedImage] as? UIImage {
                    newImage = possibleImage
                }
                if let image = newImage {
                    if let imageName = HMDocumentDirectory.hmSaveImage(image: image) {
                        self.addNewImageMessage(imageName, imageServerName: nil, message: nil, byMe: true)
                    }
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Utilities
    
    func scrollToBottom(_ animated: Bool) {
        if self.arrMessages.count > 0 {
            let numberOfSections: Int = self.tblChat.numberOfSections
            if numberOfSections > 0 {
                let numberOfRows: Int = self.tblChat.numberOfRows(inSection: numberOfSections - 1)
                if numberOfRows > 0 {
                    self.tblChat.scrollToRow(at: IndexPath(row: numberOfRows - 1, section: numberOfSections - 1), at: UITableViewScrollPosition.bottom, animated: animated)
                }
            }
        }
        
    }
    
    func isLastRowVisible() -> Bool {
        if self.arrMessages.count > 0 {
            let numberOfSections: Int = self.tblChat.numberOfSections
            if numberOfSections > 0 {
                let numberOfRows: Int = self.tblChat.numberOfRows(inSection: numberOfSections - 1)
                if numberOfRows > 0 {
                    if let visibleRows: [IndexPath] = self.tblChat.indexPathsForVisibleRows {
                        for index in visibleRows {
                            if (index as NSIndexPath).section == (numberOfSections - 1) {
                                if (index as NSIndexPath).row == (numberOfRows - 1) {
                                    return true
                                }
                            }
                        }
                    }
                }
            }
        }
        return false
    }
    
    func checkForPreviousDate(_ indexPath: IndexPath) -> Bool {
        let message = self.arrMessages.object(at: (indexPath as NSIndexPath).row) as! HMMessage
        var showDate = true
        if (indexPath as NSIndexPath).row > 0 {
            let previousMessage = self.arrMessages.object(at: (indexPath as NSIndexPath).row - 1) as? HMMessage
            if previousMessage != nil {
                if HMDateTime.convertTimeIntervalToLocalDateString(message.timeInSeconds) == HMDateTime.convertTimeIntervalToLocalDateString(previousMessage!.timeInSeconds) {
                    showDate = false
                }
            }
        }
        return showDate
    }
    
    func updateMessageStatusWithoutAnimatingCell(_ messageId: Int, messageStatus: Int) {
        let status = HMDatabase.updateStatusForMessage(messageId, messageStatus: messageStatus)
        if status == true {
            if let indexPath: IndexPath = self.getIndexPathFrom(messageId) {
                if (self.arrMessages.object(at: indexPath.row) as! HMMessage).messageUniqueId == messageId {
                    let message = self.arrMessages.object(at: indexPath.row) as! HMMessage
                    message.messageStatus = messageStatus
                    let tempMessages = self.arrMessages.mutableCopy() as! NSMutableArray
                    tempMessages.replaceObject(at: indexPath.row, with: message)
                    self.arrMessages = tempMessages.mutableCopy() as! NSMutableArray
                    self.reloadSingleCellInChatTable(indexPath, animated: false)
                    /*
                    HMUtilities.hmDefaultMainQueue {
                        self.tblChat.beginUpdates()
                        self.tblChat.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
                        self.tblChat.endUpdates()
                    }
                    */
                } else {
                    self.reloadChatTable()
                }
            } else {
                self.reloadChatTable()
            }
        }
    }

    
    func reloadSingleCellInChatTable(_ indexPath: IndexPath, animated: Bool) {
        var animation = UITableViewRowAnimation.none
        if animated == true {
            animation = UITableViewRowAnimation.automatic
        }
        HMUtilities.hmDefaultMainQueue {
            self.tblChat.beginUpdates()
            self.tblChat.reloadRows(at: [indexPath], with: animation)
            self.tblChat.endUpdates()
        }
    }
    
    func getIndexPathFrom(_ messageId: Int) -> IndexPath? {
        var indxPath: IndexPath? = nil
        for i in 0 ..< arrMessages.count {
            let tempMsg = self.arrMessages.object(at: i) as! HMMessage
            if tempMsg.messageUniqueId == messageId {
                indxPath = IndexPath(row: i, section: 0)
                break
            }
        }
        return indxPath
    }
    
    func insertNewMessageInTableAndArray(msg: HMMessage) {
        let arr = self.arrMessages.mutableCopy() as! NSMutableArray
        arr.add(msg)
        self.arrMessages = arr.mutableCopy() as! NSMutableArray
        
        var updating = false
        let numberOfSections: Int? = tblChat.numberOfSections
        if numberOfSections != nil {
            if numberOfSections! > 0 {
                let numberOfRows: Int? = tblChat.numberOfRows(inSection: numberOfSections! - 1)
                if numberOfRows != nil {
                    //row = numberOfRows!
                    
                    updating = true
                    
                    HMUtilities.hmDefaultMainQueue {
                        let indexPath = IndexPath(row: numberOfRows!, section: numberOfSections! - 1)
                        self.tblChat.beginUpdates()
                        self.tblChat.insertRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                        self.tblChat.endUpdates()
                        
                        HMUtilities.hmDelay(delay: 0.25, hmCompletion: {
                            self.scrollToBottom(true)
                        })
                    }
                }
            }
        }
        
        if updating == false {
            self.reloadChatTable()
            self.scrollToBottom(true)
        }
        
    }
    
    func replaceObjectInChatMessageaArray(withObject msg: HMMessage, shouldReloadCell reload: Bool, withAnimation animated: Bool, updateDatabase: Bool, indexPath: IndexPath? = nil) {
        if updateDatabase {
            let _ = HMDatabase.updateStatusForMediaMessage(msg.messageUniqueId, messageStatus: msg.messageStatus, localName: msg.mediaLocalName, serverName: msg.mediaServerName)
        }
        
        if let indxPath = indexPath {
            let arrTemp = self.arrMessages.mutableCopy() as! NSMutableArray
            arrTemp.replaceObject(at: indxPath.row, with: msg)
            self.arrMessages = arrTemp.mutableCopy() as! NSMutableArray
            if reload == true {
                self.reloadSingleCellInChatTable(indxPath, animated: animated)
            }
        } else {
            if let indxPath: IndexPath = self.getIndexPathFrom(msg.messageUniqueId) {
                let arrTemp = self.arrMessages.mutableCopy() as! NSMutableArray
                arrTemp.replaceObject(at: indxPath.row, with: msg)
                self.arrMessages = arrTemp.mutableCopy() as! NSMutableArray
                if reload == true {
                    self.reloadSingleCellInChatTable(indxPath, animated: animated)
                }
            }
        }
    }
    
    //MARK: - HMInputView Delegate
    
    func hmInputViewShouldBeginEditing() {
        
    }
    
    func hmInputViewShouldEndEditing() {
        
    }
    
    func hmTextViewResignFirstResponder() {
        HMUtilities.hmDefaultMainQueue {
            self.messageInputView.frame.origin.y = ScreenSize.height - self.messageInputView.frame.size.height
            self.tblChat.frame = CGRect(x: 0, y: self.tableY, width: ScreenSize.width, height: self.messageInputView.frame.origin.y - self.tableY)
        }
    }
    
    func hmInputViewShouldUpdateHeight(_ desiredHeight: CGFloat) {
        var origin = messageInputView.frame
        origin.origin.y = origin.origin.y + origin.size.height - desiredHeight
        origin.size.height = desiredHeight
        self.messageInputView.frame = origin
        self.tblChat.frame = CGRect(x: 0, y: self.tableY, width: ScreenSize.width, height: self.messageInputView.frame.origin.y - self.tableY)
        if self.isLastRowVisible() == true {
            self.scrollToBottom(true)
        }
        
        
        if isUserTyping == HMUserTyping.notTyping || isUserTyping == HMUserTyping.failedToSend && messageInputView.inputTextView.text.hm_Length > 0 {
            let data = AppVariables.getCurrentChatUserData()
            let status = HMSocket.hmSendStartPrivateTyping(to_id: data.otherUserId, to_name: data.otherUserName)
            if status == true {
                isUserTyping = HMUserTyping.send
            } else {
                isUserTyping = HMUserTyping.failedToSend
            }
        } else {
            isUserTyping = HMUserTyping.failedToSend
        }
        
        if timerTyping != nil {
            timerTyping?.invalidate()
        }
        
        timerTyping = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.userEndedTyping), userInfo: nil, repeats: false)
        
    }
    
    func hmInputViewDidPressSendButton(_ text: String) {
        self.addNewSendMessage(text, byMe: true)
    }
    
    func hmInputViewDidPressLeftButton() {
        
    }
    
    func hmInputViewDidPressCameraButton() {
        self.askForImageOperation()
    }
    
    //MARK: - Table View Delegate, Table View DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMessages.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message = self.arrMessages.object(at: (indexPath as NSIndexPath).row) as! HMMessage
        if message.messageType == HMChatMessageType.text {
            return HMChatMessageCell.getCellHeight(message, showDateLabel: self.checkForPreviousDate(indexPath))
        } else if message.messageType == HMChatMessageType.image || message.messageType == HMChatMessageType.location{
            return HMChatImageCell.getCellHeight(message, showDateLabel: self.checkForPreviousDate(indexPath))
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let message = self.arrMessages.object(at: (indexPath as NSIndexPath).row) as? HMMessage {
            let dateStatus = self.checkForPreviousDate(indexPath)
            if message.messageType == HMChatMessageType.text {
                let cell = HMChatMessageCell(reuseIdentifier: HMChatConstants.chatMessageCellIndentifier, message: message, showDateLabel: dateStatus)
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                
                if message.messageStatus == HMChatMessageStatus.waitingToSend {
                    var textMessage = ""
                    if message.message != nil {
                        textMessage = message.message!
                    }
                    self.sendTextMessageToServer(messageId: message.messageUniqueId, message: textMessage)
                }
                return cell
            } else if message.messageType == HMChatMessageType.image || message.messageType == HMChatMessageType.location {
                let cell = HMChatImageCell(reuseIdentifier: HMChatConstants.chatImageCellIndentifier, message: message, showDateLabel: dateStatus)
                cell.delegate = self
                cell.indexPath = indexPath
                
                if let localImageName = message.mediaLocalName {
                    cell.messageImage?.image = HMDocumentDirectory.hmGetImage(forName: localImageName)
                } else if let serverImageName = message.mediaServerName {
                    print("serverImageName >>>>> \(serverImageName)")
                }
                
                if message.messageStatus == HMChatMessageStatus.upload {
                    if let localImageName = message.mediaLocalName {
                        if let image = cell.messageImage?.image {
                            self.uploadImageToServer(image: image, message: message)
                        } else if let image = HMDocumentDirectory.hmGetImage(forName: localImageName) {
                            self.uploadImageToServer(image: image, message: message)
                        }
                    }
                } else if message.messageStatus == HMChatMessageStatus.uploading {
                    
                } else if message.messageStatus == HMChatMessageStatus.uploaded {
                    if let fileName = message.mediaServerName {
                        var text = ""
                        if message.message != nil {
                            text = message.message!
                        }
                        self.sendImageMessageToServer(messageId: message.messageUniqueId, message: text, fileName: fileName)
                    }
                } else if message.messageStatus == HMChatMessageStatus.sendingToServer {
                    
                } else if message.messageStatus == HMChatMessageStatus.errorWhileUploading || message.messageStatus == HMChatMessageStatus.errorWhileSendingMedia {
                    
                } else if message.messageStatus == HMChatMessageStatus.download {
                    
                } else if message.messageStatus == HMChatMessageStatus.downloading {
                    
                } else if message.messageStatus == HMChatMessageStatus.errorWhileDownloading || message.messageStatus == HMChatMessageStatus.errorWhileSaving {
                    
                }
                
                cell.backgroundColor = UIColor.clear
                cell.selectionStyle = UITableViewCellSelectionStyle.none
                return cell
            }
        }
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath >>>> \(indexPath)")
    }
    
    //MARK: Cell Delegates
    
    func didPressUploadDownloadButton(indexPath: IndexPath) {
        if let message = self.arrMessages.object(at: (indexPath as NSIndexPath).row) as? HMMessage {
            if message.messageStatus == HMChatMessageStatus.waitingToUpload {
                let newMsg = message
                newMsg.messageStatus = HMChatMessageStatus.upload
                self.replaceObjectInChatMessageaArray(withObject: newMsg, shouldReloadCell: true, withAnimation: true, updateDatabase: true, indexPath: indexPath)
            } else if message.messageStatus == HMChatMessageStatus.uploading {
                let newMsg = message
                AppVariables.cancelUploadDownloadTask(messageUniqueId: newMsg.messageUniqueId)
                newMsg.messageStatus = HMChatMessageStatus.waitingToUpload
                self.replaceObjectInChatMessageaArray(withObject: newMsg, shouldReloadCell: true, withAnimation: true, updateDatabase: true, indexPath: indexPath)
            } else if message.messageStatus == HMChatMessageStatus.waitingToDownload {
                let newMsg = message
                newMsg.messageStatus = HMChatMessageStatus.download
                self.replaceObjectInChatMessageaArray(withObject: newMsg, shouldReloadCell: true, withAnimation: true, updateDatabase: true, indexPath: indexPath)
            } else if message.messageStatus == HMChatMessageStatus.downloading {
                let newMsg = message
                AppVariables.cancelUploadDownloadTask(messageUniqueId: newMsg.messageUniqueId)
                newMsg.messageStatus = HMChatMessageStatus.waitingToDownload
                self.replaceObjectInChatMessageaArray(withObject: newMsg, shouldReloadCell: true, withAnimation: true, updateDatabase: true, indexPath: indexPath)
            }
        }
    }
    
    //MARK: HMSocketDelegate
    
    func hmDidReceiveNewMessage(message: HMMessage) {
        self.insertNewMessageInTableAndArray(msg: message)
    }
    
    func hmUserIsTyping(dictData: NSDictionary) {
        
    }
    
    func hmUserStopedTyping(dictData: NSDictionary) {
        
    }
    
    //MARK: - SendData
    
    func sendTextMessageToServer(messageId: Int, message: String) {
        let data = AppVariables.getCurrentChatUserData()
        let otherId = data.otherUserId
        let otherName = data.otherUserName
        self.updateMessageStatusWithoutAnimatingCell(messageId, messageStatus: HMChatMessageStatus.sending)
        HMSocket.hmSendPrivateChatMessage(to_id: otherId, to_name: otherName, message: message, msg_type: HMChatMessageType.text, file_name: nil, lat: nil, lng: nil) { (dictResponse) in
            var messageStatus = HMChatMessageStatus.errorWhileSendingTextMessage
            if let dict = dictResponse {
                if dict.hmGetInt(forKey: HMSocketConstants.success) == 1 {
                    messageStatus = HMChatMessageStatus.send
                }
            }
            self.updateMessageStatusWithoutAnimatingCell(messageId, messageStatus: messageStatus)
        }
    }
    
    func sendImageMessageToServer(messageId: Int, message: String, fileName: String) {
        let data = AppVariables.getCurrentChatUserData()
        let otherId = data.otherUserId
        let otherName = data.otherUserName
        self.updateMessageStatusWithoutAnimatingCell(messageId, messageStatus: HMChatMessageStatus.sendingToServer)
        HMSocket.hmSendPrivateChatMessage(to_id: otherId, to_name: otherName, message: message, msg_type: HMChatMessageType.image, file_name: fileName, lat: nil, lng: nil) { (dictResponse) in
            var messageStatus = HMChatMessageStatus.errorWhileSendingMedia
            if let dict = dictResponse {
                if dict.hmGetInt(forKey: HMSocketConstants.success) == 1 {
                    messageStatus = HMChatMessageStatus.send
                }
            }
            self.updateMessageStatusWithoutAnimatingCell(messageId, messageStatus: messageStatus)
        }
    }
    
    func userEndedTyping() {
        let data = AppVariables.getCurrentChatUserData()
        HMSocket.hmSendStopPrivateTyping(to_id: data.otherUserId, to_name: data.otherUserName)
    }
    
    func uploadImageToServer(image: UIImage, message: HMMessage) {
        let msg = message
        
        if HelperClass.isInternetAvailable {
            msg.messageStatus = HMChatMessageStatus.uploading
            self.replaceObjectInChatMessageaArray(withObject: msg, shouldReloadCell: true, withAnimation: true, updateDatabase: true)
            let upload = HMDownloadUpload(messageUniqueId: msg.messageUniqueId, urlString: HMSocketConstants.imageUploadUrl, download: false)
            AppVariables.appendNewUploadDownloadData(upload)
            
            HMDownloadUpload.uploadImageWithProgress(upload, header: [:], parameters: [:], img: image, imgServerParamName: HMSocketConstants.file, progress: { (progress) in
                print("Float(progress.fractionCompleted) >>>>> \(Float(progress.fractionCompleted))")
                AppVariables.updateProgressInUploadDownloadArray(messageUniqueId: msg.messageUniqueId, progress: Float(progress.fractionCompleted))
            }, completionHandler: { (dictResponse, error) in
                
                AppVariables.removeUploadDownloadData(messageUniqueId: msg.messageUniqueId)
                
                var newMsg: HMMessage? = nil
                if let indx: IndexPath = self.getIndexPathFrom(msg.messageUniqueId) {
                    newMsg = self.arrMessages.object(at: indx.row) as? HMMessage
                }
                print("dictResponse >>>> \(String(describing: dictResponse))")
                
                if dictResponse!.count > 0 {
                    if dictResponse!.hmGetInt(forKey: HMSocketConstants.success) == 1 {
                        let file_name = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dictResponse!, strObject: HMSocketConstants.file_name)
                        newMsg?.messageStatus = HMChatMessageStatus.uploaded
                        newMsg?.mediaServerName = file_name
                    } else {
                        newMsg?.messageStatus = HMChatMessageStatus.errorWhileUploading
                    }
                } else {
                    if error?.code == -999 {
                        print("cancelled")
                        newMsg?.messageStatus = HMChatMessageStatus.waitingToUpload
                    } else {
                        newMsg?.messageStatus = HMChatMessageStatus.errorWhileUploading
                    }
                }
                
                if let nwMsg = newMsg {
                    self.replaceObjectInChatMessageaArray(withObject: nwMsg, shouldReloadCell: true, withAnimation: true, updateDatabase: true)
                }
            })
        } else {
            msg.messageStatus = HMChatMessageStatus.errorWhileUploading
            self.replaceObjectInChatMessageaArray(withObject: msg, shouldReloadCell: true, withAnimation: true, updateDatabase: true)
        }
    }
    
    func downloadImageFromServer(serverImageName: String, message: HMMessage) {
        let imageUrlString = HMSocketConstants.imageDownloadUrl + serverImageName
        let msg = message
        if let _ = URL(string: imageUrlString) {
            if HelperClass.isInternetAvailable {
                msg.messageStatus = HMChatMessageStatus.downloading
                self.replaceObjectInChatMessageaArray(withObject: msg, shouldReloadCell: true, withAnimation: true, updateDatabase: true)
                let download = HMDownloadUpload(messageUniqueId: msg.messageUniqueId, urlString: imageUrlString, download: true)
                AppVariables.appendNewUploadDownloadData(download)
                
                HMDownloadUpload.downloadImage(download, progress: { (fractionUploaded) in
                    print("fractionCompleted) >>>>> \(fractionUploaded)")
                    AppVariables.updateProgressInUploadDownloadArray(messageUniqueId: msg.messageUniqueId, progress: fractionUploaded)
                }, completionHandler: { (image, error) in
                    
                    AppVariables.removeUploadDownloadData(messageUniqueId: msg.messageUniqueId)
                    
                    var messageStatus = HMChatMessageStatus.errorWhileDownloading
                    var localImageName: String?
                    if let img = image {
                        if let localName = HMDocumentDirectory.hmSaveImage(image: img) {
                            localImageName = localName
                            messageStatus = HMChatMessageStatus.downloaded
                        } else {
                            messageStatus = HMChatMessageStatus.errorWhileSaving
                        }
                    }
                    msg.messageStatus = messageStatus
                    msg.mediaLocalName = localImageName
                    self.replaceObjectInChatMessageaArray(withObject: msg, shouldReloadCell: true, withAnimation: true, updateDatabase: true)
                })
            } else {
                msg.messageStatus = HMChatMessageStatus.errorWhileDownloading
                self.replaceObjectInChatMessageaArray(withObject: msg, shouldReloadCell: true, withAnimation: true, updateDatabase: true)
            }
        } else {
            msg.messageStatus = HMChatMessageStatus.errorWhileDownloading
            self.replaceObjectInChatMessageaArray(withObject: msg, shouldReloadCell: true, withAnimation: true, updateDatabase: true)
        }
    }
    
    // MARK: - Add Messages
    
    func addNewSendMessage(_ message: String, byMe: Bool) {
        messageInputView.clearText(false)
        
        var messageStatus = HMChatMessageStatus.received
        if byMe == true {
            messageStatus = HMChatMessageStatus.waitingToSend
        }
        
        let currentDetail = AppVariables.getCurrentChatUserData()
        
        let otherId = currentDetail.otherUserId
        let otherName = currentDetail.otherUserName
        
        let data = HMDatabase.insertTextMessage(currentDetail.userId, userName: currentDetail.userName, userImage: currentDetail.userImage, otherUserId: otherId, otherUserName: otherName, otherUserImage: currentDetail.otherUserImage, isUserSelf: byMe, messageStatus: messageStatus, readUnreadStatus: HMReadUnreadState.readed, message: message, timeInSec: nil)
        
        if data.messageAdded == true {
            self.insertNewMessageInTableAndArray(msg: data.textMessage!)
        }
    }
    
    func addNewImageMessage(_ imageLocalName: String?, imageServerName: String?, message: String?, byMe: Bool) {
        var messageStatus = HMChatMessageStatus.waitingToDownload
        if byMe == true {
            messageStatus = HMChatMessageStatus.waitingToUpload
        }
        
        let currentDetail = AppVariables.getCurrentChatUserData()
        
        let data = HMDatabase.insertImageMessage(currentDetail.userId, userName: currentDetail.userName, userImage: currentDetail.userImage, otherUserId: currentDetail.otherUserId, otherUserName: currentDetail.otherUserName, otherUserImage: currentDetail.otherUserImage, isUserSelf: byMe, messageStatus: messageStatus, readUnreadStatus: HMReadUnreadState.readed, message: message, imageLocalName: imageLocalName, imageServerName: imageServerName, timeInSec: nil)
        if data.messageAdded == true {
            self.insertNewMessageInTableAndArray(msg: data.imageMessage!)
        }
    }
    
    // MARK: - Button Action
    
    @IBAction func btnBack(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnReport(_ sender: Any) {
    }
    
}
