//
//  HMChatImageCell.swift
//  XFindr
//
//  Created by Honey Maheshwari on 4/22/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

protocol HMChatImageCellDelegate {
    func didPressUploadDownloadButton(indexPath: IndexPath)
}

class HMChatImageCell: UITableViewCell {

    var bubbleView: UIView!
    var messageLabel: UILabel? = nil
    var viewDate: UIView!
    var dateLabel: UILabel!
    var timeLabel: UILabel!
    var durationLabel: UILabel!
    var spinnerView: JTMaterialSpinner!
    var messageImage: UIImageView? = nil
    var uploadDownloadButton: UIButton?
    var delegate: HMChatImageCellDelegate?
    var indexPath: IndexPath!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    convenience init(reuseIdentifier: String, message: HMMessage, showDateLabel: Bool) {
        self.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        
        let timeString = HMDateTime.converTimeIntervalToLocalTimeString(message.timeInSeconds)
        var dateLabelY: CGFloat = 0.0
        if showDateLabel == true {
            dateLabelY = HMChatConstants.defaultDateLabelHeight
        }
        
        let size = HMChatConstants.defaultImageMessageSize
        
        var textMessage = ""
        var textHeight: CGFloat = 0.0
        if let msg = message.message {
            textMessage = HMString.stringByTrimingWhitespace(msg)
            let height = HMString.getTextSizeFromString(textMessage, withDefinedMaxWidth: size.width).height
            textHeight = height * HMChatConstants.defaultAddressPaddingPercent
            if textHeight != 0.0 {
                textHeight += HMChatConstants.defaultMargin
            }
        }
        
        var imageX: CGFloat = HMChatConstants.defaultTextMargin + HMChatConstants.defaultAngleWidth
        let imageY: CGFloat = HMChatConstants.defaultTextMargin + dateLabelY
        
        let bubbleWidth = size.width + HMChatConstants.defaultTextMargin + HMChatConstants.defaultAngleWidth
        let bubbleHeight = size.height + HMChatConstants.defaultTextMargin + textHeight
        
        var bubbleX: CGFloat = HMChatConstants.defaultIconSize + HMChatConstants.defaultMargin + HMChatConstants.defaultIconToMessageMargin
        let bubbleY: CGFloat = HMChatConstants.defaultMargin + dateLabelY
        var isUserSelf = false
        
        let addressY = imageY + size.height + HMChatConstants.defaultMargin
        var messageTextColor: UIColor = UIColor.black
        
        if message.userType == HMChatUserType.me {
            isUserSelf = true
            imageX = ScreenSize.width - HMChatConstants.defaultTextMargin - size.width - 7
            bubbleX = ScreenSize.width - (HMChatConstants.defaultIconSize + HMChatConstants.defaultMargin + HMChatConstants.defaultIconToMessageMargin) - bubbleWidth
            messageTextColor = UIColor.white
        }
        
        let imageFrame = CGRect(x: imageX, y: imageY, width: size.width, height: size.height)
        let bubbleRect = CGRect(x: bubbleX, y: bubbleY, width: bubbleWidth, height: bubbleHeight)
        let timeLabelFrame = CGRect(x: imageX, y: bubbleY + bubbleHeight, width: size.width, height: HMChatConstants.defaultTimeLabelHeight)
        
        if showDateLabel == true {
            self.setupDateLabel(HMDateTime.convertTimeIntervalToLocalDateString(message.timeInSeconds))
        }
        
        self.setupCellBubbleItem(bubbleRect, isUserSelf: isUserSelf)
        self.setupMessageImage(imageFrame, image: nil)
        if textMessage != "" {
            let addressLabelFrame = CGRect(x: imageX, y: addressY, width: size.width, height: textHeight)
            self.setupMessageLabel(text: textMessage, frame: addressLabelFrame, textColor: messageTextColor)
        }
        self.setupTimeLabel(timeString, frame: timeLabelFrame)
        
        //"ic_file_download", "ic_clear_white"
        //#imageLiteral(resourceName: "ic_file_upload"), #imageLiteral(resourceName: "ic_file_download"), #imageLiteral(resourceName: "ic_clear_white")
        
        if message.messageStatus == HMChatMessageStatus.waitingToUpload {
            self.removeLoader()
            self.setupUploadDownloadButton(imageFrame, imageName: "ic_file_upload")
        } else if message.messageStatus == HMChatMessageStatus.upload || message.messageStatus == HMChatMessageStatus.uploading {
            self.setupLoader(imageFrame, isUserSelf: isUserSelf)
            self.setupUploadDownloadButton(imageFrame, imageName: "ic_clear_white")
        } else if message.messageStatus == HMChatMessageStatus.sendingToServer {
            self.setupLoader(imageFrame, isUserSelf: isUserSelf)
            self.removeUploadDownloadButton()
        } else if message.messageStatus == HMChatMessageStatus.uploaded {
            self.removeLoader()
            self.removeUploadDownloadButton()
        } else if message.messageStatus == HMChatMessageStatus.errorWhileUploading || message.messageStatus == HMChatMessageStatus.errorWhileSendingMedia {
            self.removeLoader()
            self.setupUploadDownloadButton(imageFrame, imageName: "ic_file_upload")
        } else if message.messageStatus == HMChatMessageStatus.waitingToDownload {
            self.removeLoader()
            self.setupUploadDownloadButton(imageFrame, imageName: "ic_file_download")
        } else if message.messageStatus == HMChatMessageStatus.download || message.messageStatus == HMChatMessageStatus.downloading || message.messageStatus == HMChatMessageStatus.download {
            self.setupLoader(imageFrame, isUserSelf: isUserSelf)
            self.setupUploadDownloadButton(imageFrame, imageName: "ic_clear_white")
        } else if message.messageStatus == HMChatMessageStatus.errorWhileDownloading || message.messageStatus == HMChatMessageStatus.errorWhileSaving {
            self.removeLoader()
            self.setupUploadDownloadButton(imageFrame, imageName: "ic_file_download")
        } else if message.messageStatus == HMChatMessageStatus.savedToDevice {
            self.removeLoader()
            self.removeUploadDownloadButton()
        }
        
        
        
        /*
        
        if theMessage.messageType == HMChatMessageType.image {
            let imageSize = HMChatConstants.defaultImageMessageSize
            var messageX: CGFloat = HMChatConstants.defaultTextMargin + HMChatConstants.defaultAngleWidth
            let messageY: CGFloat = HMChatConstants.defaultTextMargin + dateLabelY
            let bubbleWidth = imageSize.width + HMChatConstants.defaultTextMargin + HMChatConstants.defaultAngleWidth
            let bubbleHeight = imageSize.height + HMChatConstants.defaultTextMargin
            var bubbleX: CGFloat = HMChatConstants.defaultIconSize + HMChatConstants.defaultMargin + HMChatConstants.defaultIconToMessageMargin
            let bubbleY: CGFloat = HMChatConstants.defaultMargin + dateLabelY
            var isUserSelf = false
            
            if theMessage.userType == HMChatUserType.me {
                isUserSelf = true
                messageX = ScreenSize.width - HMChatConstants.defaultTextMargin - imageSize.width - 7
                bubbleX = ScreenSize.width - (HMChatConstants.defaultIconSize + HMChatConstants.defaultMargin + HMChatConstants.defaultIconToMessageMargin) - bubbleWidth
            }
            
            let imageFrame = CGRect(x: messageX, y: messageY, width: imageSize.width, height: imageSize.height)
            let bubbleRect = CGRect(x: bubbleX, y: bubbleY, width: bubbleWidth, height: bubbleHeight)
            let timeLabelFrame = CGRect(x: messageX, y: HMChatConstants.defaultTextMargin + imageSize.height + dateLabelY + 5, width: imageSize.width, height: HMChatConstants.defaultTimeLabelHeight)
            if showDateLabel == true {
                self.setupDateLabel(HMDateTime.convertTimeIntervalToLocalDateString(theMessage.timeInSeconds))
            }
            self.setupCellBubbleItem(bubbleRect, isUserSelf: isUserSelf)
            self.setupMessageImage(imageFrame, image: self.checkImageDict(theMessage))
            self.setupTimeLabel(timeString, frame: timeLabelFrame)
            //self.backgroundColor = UIColor.redColor()
            
            self.setupUploadDownloadButton(theMessage)
        } else if theMessage.messageType == HMChatMessageType.location {
            
            let size = HMChatConstants.defaultImageMessageSize
            
            var address = ""
            var addressHeight: CGFloat = 0.0
            if theMessage.messageExtraData != nil {
                address = HMUtilities.checkObjectInDictionary(theMessage.messageExtraData!, strObject: HMMessageDict.address)
                address = HMString.stringByTrimingWhitespace(address)
                let height = HMString.getTextSizeFromString(address, withDefinedMaxWidth: size.width).height
                addressHeight = height * HMChatConstants.defaultAddressPaddingPercent
                if addressHeight != 0.0 {
                    addressHeight += HMChatConstants.defaultMargin
                }
            }
            
            var imageX: CGFloat = HMChatConstants.defaultTextMargin + HMChatConstants.defaultAngleWidth
            let imageY: CGFloat = HMChatConstants.defaultTextMargin + dateLabelY
            
            let bubbleWidth = size.width + HMChatConstants.defaultTextMargin + HMChatConstants.defaultAngleWidth
            let bubbleHeight = size.height + HMChatConstants.defaultTextMargin + addressHeight
            
            var bubbleX: CGFloat = HMChatConstants.defaultIconSize + HMChatConstants.defaultMargin + HMChatConstants.defaultIconToMessageMargin
            let bubbleY: CGFloat = HMChatConstants.defaultMargin + dateLabelY
            var isUserSelf = false
            
            let addressY = imageY + size.height + HMChatConstants.defaultMargin
            var messageTextColor: UIColor = UIColor.black
            
            if theMessage.userType == HMChatUserType.me {
                isUserSelf = true
                imageX = ScreenSize.width - HMChatConstants.defaultTextMargin - size.width - 7
                bubbleX = ScreenSize.width - (HMChatConstants.defaultIconSize + HMChatConstants.defaultMargin + HMChatConstants.defaultIconToMessageMargin) - bubbleWidth
                messageTextColor = UIColor.white
            }
            
            
            
            let imageFrame = CGRect(x: imageX, y: imageY, width: size.width, height: size.height)
            let bubbleRect = CGRect(x: bubbleX, y: bubbleY, width: bubbleWidth, height: bubbleHeight)
            let timeLabelFrame = CGRect(x: imageX, y: bubbleY + bubbleHeight, width: size.width, height: HMChatConstants.defaultTimeLabelHeight)
            
            if showDateLabel == true {
                self.setupDateLabel(HMDateTime.convertTimeIntervalToLocalDateString(theMessage.timeInSeconds))
            }
            
            self.setupCellBubbleItem(bubbleRect, isUserSelf: isUserSelf)
            self.setupMessageImage(imageFrame, image: self.checkImageDict(theMessage))
            if address != "" {
                let addressLabelFrame = CGRect(x: imageX, y: addressY, width: size.width, height: addressHeight)
                self.setupMessageLabelForLocation(text: address, frame: addressLabelFrame, textColor: messageTextColor)
            }
            self.setupTimeLabel(timeString, frame: timeLabelFrame)
            self.checkForActivityIndicatorInLocationMessage(dict: theMessage.messageExtraData)
        }
 */
    }

    
    func setupMessageLabel(text: String, frame: CGRect, textColor: UIColor) {
        messageLabel = UILabel(frame: frame);
        messageLabel?.text = text
        messageLabel?.numberOfLines = 0
        messageLabel?.textColor = textColor
        messageLabel?.font = HMChatConstants.defaultMessageTextFont
        messageLabel?.textAlignment = .left
        self.addSubview(messageLabel!)
    }
    
    func setupDateLabel(_ dateString: String) {
        dateLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: ScreenSize.width, height: HMChatConstants.defaultDateLabelHeight))
        dateLabel.text = dateString
        dateLabel.font = HMChatConstants.defaultDateLabelFont
        dateLabel.backgroundColor = UIColor.clear
        let dateTextSize = HMString.getTextSizeFromString(dateString)
        dateLabel.textAlignment = .center
        
        //dateLabel.frame = CGRectMake(0.0, 5.0, dateTextSize.width + HMChatConstants.DefaultDateLabelMargin, dateTextSize.height + HMChatConstants.DefaultDateLabelMargin)
        dateLabel.frame = CGRect(x: 0.0, y: HMChatConstants.defaultDateLabelMargin, width: dateTextSize.width + HMChatConstants.defaultDateLabelMargin, height: HMChatConstants.defaultDateLabelHeight - HMChatConstants.defaultDateLabelMargin)
        
        dateLabel.frame.origin.x = (ScreenSize.width / 2) - (dateLabel.frame.size.width / 2)
        
        let dateLabelBubblePath: UIBezierPath = HMShape.hmGetBubbleShapePathWithSizeForDateLabel(dateLabel.frame.size)
        let layer = CAShapeLayer()
        layer.path = dateLabelBubblePath.cgPath
        layer.fillColor = HMChatConstants.defaultDateLabelBgColor.cgColor
        
        viewDate = UIView(frame: dateLabel.frame)
        viewDate.backgroundColor = UIColor.clear
        viewDate.layer.insertSublayer(layer, at: 0)
        
        self.addSubview(viewDate)
        self.addSubview(dateLabel)
    }
    
    func setupTimeLabel(_ timeString: String, frame: CGRect) {
        timeLabel = UILabel(frame: frame);
        timeLabel.text = timeString
        timeLabel.textAlignment = .right
        timeLabel.textColor = UIColor.lightGray
        timeLabel.font = HMChatConstants.defaultTimeLabelFont
        self.addSubview(timeLabel)
    }
    
    func setupCellBubbleItem(_ bubbleFrame: CGRect, isUserSelf: Bool) {
        bubbleView = UIView(frame: bubbleFrame)
        let messageBubblePath: UIBezierPath = HMShape.hmGetBubbleShapePathWithSize(bubbleFrame.size, isUserSelf: isUserSelf)
        let layer = CAShapeLayer()
        layer.path = messageBubblePath.cgPath
        layer.fillColor = isUserSelf ? HMChatConstants.defaultOutgoingColor.cgColor : HMChatConstants.defaultIncomingColor.cgColor
        bubbleView.layer.addSublayer(layer)
        self.addSubview(bubbleView)
    }
    
    func setupMessageImage(_ frame: CGRect, image: UIImage?) {
        messageImage = UIImageView(frame: frame)
        messageImage?.image = image
        messageImage?.backgroundColor = UIColor.clear
        messageImage?.layer.cornerRadius = HMChatConstants.defaultAngleWidth
        messageImage?.layer.masksToBounds = true
        messageImage?.contentMode = .scaleAspectFill
        messageImage?.backgroundColor = UIColor.clear
        //messageImage?.backgroundColor = UIColor.redColor()
        self.addSubview(messageImage!)
    }
    
    class func getCellHeight(_ message: HMMessage, showDateLabel: Bool) -> CGFloat {
        var text = ""
        var textHeight: CGFloat = 0.0
        if let msg = message.message {
            text = HMString.stringByTrimingWhitespace(msg)
            let height = HMString.getTextSizeFromString(text, withDefinedMaxWidth: HMChatConstants.defaultImageMessageSize.width).height
            textHeight = height * HMChatConstants.defaultAddressPaddingPercent
            if textHeight != 0.0 {
                textHeight += HMChatConstants.defaultMargin
            }
        }
        
        let bubbleHeight = HMChatConstants.defaultImageMessageSize.height + HMChatConstants.defaultTextMargin
        let bubbleY: CGFloat = HMChatConstants.defaultMargin
        var dateLabelY: CGFloat = 0.0
        if showDateLabel == true {
            dateLabelY = HMChatConstants.defaultDateLabelHeight
        }
        let cellHeight = bubbleHeight + bubbleY + HMChatConstants.defaultTimeLabelHeight + dateLabelY + textHeight
        return cellHeight
    }
    
    func setupLoader(_ frame: CGRect, isUserSelf: Bool) {
        let padding: CGFloat = 2.0
        let fillColor = isUserSelf ? UIColor.white : UIColor.black
        if spinnerView == nil {
            spinnerView = JTMaterialSpinner()
        }
        
        spinnerView.frame = CGRect(x: frame.origin.x + (frame.size.width * 0.5) - (HMChatConstants.defaultLoaderSize.width * 0.5), y: frame.origin.y + (frame.size.height * 0.5) - (HMChatConstants.defaultLoaderSize.height * 0.5), width: HMChatConstants.defaultLoaderSize.width, height: HMChatConstants.defaultLoaderSize.height)
        spinnerView.circleLayer.lineWidth = padding
        spinnerView.circleLayer.strokeColor = fillColor.cgColor
        spinnerView.beginRefreshing()
        spinnerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        spinnerView.circleView(UIColor.clear, borderWidth: 0.0)
        self.addSubview(spinnerView)
    }
    
    func setupUploadDownloadButton(_ frame: CGRect, imageName: String) {
        if uploadDownloadButton == nil {
            uploadDownloadButton = UIButton(type: UIButtonType.custom)
        }
        uploadDownloadButton?.frame = CGRect(x: frame.origin.x + (frame.size.width * 0.5) - (HMChatConstants.defaultUploadDownloadButtonSize.width * 0.5), y: frame.origin.y + (frame.size.height * 0.5) - (HMChatConstants.defaultUploadDownloadButtonSize.height * 0.5), width: HMChatConstants.defaultUploadDownloadButtonSize.width, height: HMChatConstants.defaultUploadDownloadButtonSize.height)
        uploadDownloadButton?.setImage(UIImage(named: imageName), for: UIControlState.normal)
        uploadDownloadButton?.circleView(UIColor.clear, borderWidth: 0.0)
        var bgColor = UIColor.black.withAlphaComponent(0.5)
        if let spnr = spinnerView {
            if spnr.isDescendant(of: self) {
                bgColor = UIColor.clear
            }
        }
        
        uploadDownloadButton?.backgroundColor = bgColor
        uploadDownloadButton?.showsTouchWhenHighlighted = true
        uploadDownloadButton?.addTarget(self, action: #selector(self.uploadDownloadButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(uploadDownloadButton!)
    }
    
    func uploadDownloadButtonTapped(_ sender: UIButton)  {
        delegate?.didPressUploadDownloadButton(indexPath: self.indexPath)
    }
    
    func removeLoader() {
        if let spnr = spinnerView {
            spnr.endRefreshing()
            if spnr.isDescendant(of: self) {
                spnr.removeFromSuperview()
            }
            spinnerView = nil
        }
    }
    
    func removeUploadDownloadButton() {
        if let btn = uploadDownloadButton {
            if btn.isDescendant(of: self) {
                btn.removeFromSuperview()
            }
            uploadDownloadButton = nil
        }
    }
}
