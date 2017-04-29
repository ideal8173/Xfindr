//
//  HMChatMessageCell.swift
//  XFindr
//
//  Created by New on 4/20/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class HMChatMessageCell: UITableViewCell, TTTAttributedLabelDelegate {

    var messageLabel: TTTAttributedLabel? = nil
    var timeLabel: UILabel!
    var viewDate: UIView!
    var dateLabel: UILabel!
    var bubbleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    convenience init(reuseIdentifier: String, message: HMMessage, showDateLabel: Bool)  {
        self.init(style: UITableViewCellStyle.default, reuseIdentifier: reuseIdentifier)
        
        let timeString = HMDateTime.converTimeIntervalToLocalTimeString(message.timeInSeconds)
        var dateLabelY: CGFloat = 0.0
        if showDateLabel == true {
            dateLabelY = HMChatConstants.defaultDateLabelHeight
        }
        
        if message.messageType == HMChatMessageType.text {
            var textMessage = ""
            if message.message != nil {
                textMessage = message.message!
            }
            var textSize = HMString.getTextSizeFromString(textMessage)
            
            textSize.width += 5
            textSize.height += 5
            
            if textSize.width < HMChatConstants.defaultTextMinWidth {
                textSize.width = HMChatConstants.defaultTextMinWidth
            }
            if textSize.height < HMChatConstants.defaultTextMinHeight {
                textSize.height = HMChatConstants.defaultTextMinHeight
            }
            
            var messageX: CGFloat = HMChatConstants.defaultTextMargin + HMChatConstants.defaultAngleWidth
            let messageY: CGFloat = HMChatConstants.defaultTextMargin + dateLabelY
            let messageTextColor: UIColor = UIColor.black
            
            //            let bubbleWidth = textSize.width + HMChatConstants.DefaultTextMargin * 2 + HMChatConstants.DefaultAngleWidth
            //            let bubbleHeight = textSize.height + HMChatConstants.DefaultTextMargin * 2
            
            let bubbleWidth = textSize.width + HMChatConstants.defaultTextMargin + HMChatConstants.defaultAngleWidth
            let bubbleHeight = textSize.height + HMChatConstants.defaultTextMargin
            
            var bubbleX: CGFloat = HMChatConstants.defaultIconSize + HMChatConstants.defaultMargin + HMChatConstants.defaultIconToMessageMargin
            let bubbleY: CGFloat = HMChatConstants.defaultMargin + dateLabelY
            var isUserSelf = false
            
            if message.userType == HMChatUserType.me {
                isUserSelf = true
                messageX = ScreenSize.width - HMChatConstants.defaultTextMargin - textSize.width - 7
                bubbleX = ScreenSize.width - (HMChatConstants.defaultIconSize + HMChatConstants.defaultMargin + HMChatConstants.defaultIconToMessageMargin) - bubbleWidth
            }
            
            let messageLabelFrame = CGRect(x: messageX, y: messageY, width: textSize.width, height: textSize.height)
            /*
             //Remove this comment to show time label in bubble and comment the three lines just below the comment block
             
             let bubbleRect = CGRectMake(bubbleX, bubbleY, bubbleWidth, bubbleHeight + HMChatConstants.DefaultTimeLabelHeight - 2)
             let timeLabelFrame = CGRectMake(messageX, HMChatConstants.DefaultTextMargin + textSize.height + dateLabelY, textSize.width, HMChatConstants.DefaultTimeLabelHeight)
             */
            let bubbleRect = CGRect(x: bubbleX, y: bubbleY, width: bubbleWidth, height: bubbleHeight)
            let timeLabelFrame = CGRect(x: messageX, y: HMChatConstants.defaultTextMargin + textSize.height + dateLabelY + 5, width: textSize.width, height: HMChatConstants.defaultTimeLabelHeight)
            
            if showDateLabel == true {
                self.setupDateLabel(HMDateTime.convertTimeIntervalToLocalDateString(message.timeInSeconds))
            }
            self.setupCellBubbleItem(bubbleRect, isUserSelf: isUserSelf)
            self.setupMessageLabel(textMessage, frame: messageLabelFrame, textColor: messageTextColor)
            self.setupTimeLabel(timeString, frame: timeLabelFrame)
        }
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
    
    func setupCellBubbleItem(_ bubbleFrame: CGRect, isUserSelf: Bool) {
        bubbleView = UIView(frame: bubbleFrame)
        let messageBubblePath: UIBezierPath = HMShape.hmGetBubbleShapePathWithSize(bubbleFrame.size, isUserSelf: isUserSelf)
        let layer = CAShapeLayer()
        layer.path = messageBubblePath.cgPath
        layer.fillColor = isUserSelf ? HMChatConstants.defaultOutgoingColor.cgColor : HMChatConstants.defaultIncomingColor.cgColor
        bubbleView.layer.addSublayer(layer)
        self.addSubview(bubbleView)
    }
    
    func setupMessageLabel(_ text: String, frame: CGRect, textColor: UIColor) {
        
        messageLabel = TTTAttributedLabel(frame: frame)
        messageLabel?.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue | NSTextCheckingResult.CheckingType.phoneNumber.rawValue
        messageLabel?.delegate = self
        messageLabel?.numberOfLines = 0
        //messageLabel?.setText(text)
        messageLabel?.textColor = textColor
        messageLabel?.font = HMChatConstants.defaultMessageTextFont
        
        messageLabel?.setText(text, afterInheritingLabelAttributesAndConfiguringWith: { (mutableAttributedString) -> NSMutableAttributedString? in
            //let range = (str as NSString).rangeOfString(string_to_color)
            
            let range = (text as NSString).range(of: text)
            
            mutableAttributedString?.addAttributes([NSFontAttributeName: HMChatConstants.defaultMessageTextFont, NSParagraphStyleAttributeName: HMString.getHMDefaultMessageParagraphStyle(), NSForegroundColorAttributeName: textColor], range: range)
            
            return mutableAttributedString
        })
        
        self.addSubview(messageLabel!)
    }
    
    func setupTimeLabel(_ timeString: String, frame: CGRect) {
        timeLabel = UILabel(frame: frame);
        timeLabel.text = timeString
        timeLabel.textAlignment = .right
        timeLabel.textColor = UIColor.lightGray
        timeLabel.font = HMChatConstants.defaultTimeLabelFont
        self.addSubview(timeLabel)
    }

    //MARK: TTTAttributedLabel Delegate
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        print("url", url)
    }
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWithPhoneNumber phoneNumber: String!) {
        print("phoneNumber", phoneNumber)
    }
    
    class func getCellHeight(_ message: HMMessage, showDateLabel: Bool) -> CGFloat {
        var textMessage = ""
        if message.message != nil {
            textMessage = message.message!
        }
        var textSize = HMString.getTextSizeFromString(textMessage)
        textSize.width += 5
        textSize.height += 5
        
        if textSize.width < HMChatConstants.defaultTextMinWidth {
            textSize.width = HMChatConstants.defaultTextMinWidth
        }
        if textSize.height < HMChatConstants.defaultTextMinHeight {
            textSize.height = HMChatConstants.defaultTextMinHeight
        }
        
        let bubbleHeight = textSize.height + HMChatConstants.defaultTextMargin
        let bubbleY: CGFloat = HMChatConstants.defaultMargin
        var dateLabelY: CGFloat = 0.0
        if showDateLabel == true {
            dateLabelY = HMChatConstants.defaultDateLabelHeight
        }
        
        let cellHeight = bubbleHeight + bubbleY + HMChatConstants.defaultTimeLabelHeight + dateLabelY
        return cellHeight
    }
    
}
