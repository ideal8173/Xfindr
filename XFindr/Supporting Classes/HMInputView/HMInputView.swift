//
//  HMInputView.swift
//  testInputView
//
//  Created by Honey Maheshwari on 4/19/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

@objc protocol HMInputViewDelegate {
    func hmInputViewShouldBeginEditing()
    func hmInputViewShouldEndEditing()
    func hmInputViewShouldUpdateHeight(_ desiredHeight: CGFloat)
    func hmInputViewDidPressSendButton(_ text: String)
    func hmTextViewResignFirstResponder()
    @objc optional func hmInputViewDidPressLeftButton()
    @objc optional func hmInputViewDidPressCameraButton()
}

enum HMInputViewAppearance {
    case dark
    case `default`
}

class HMInputView: UIView, UITextViewDelegate {

    var inputTextView: UIPlaceHolderTextView!
    var sendButton: UIButton!
    var cameraButton: UIButton!
    var locationButton: UIButton!
    var dealButton: UIButton!
    var guestbookButton: UIButton!
    var hmDelegate: HMInputViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(appearance: HMInputViewAppearance) {
        let frame: CGRect = CGRect(x: 0.0, y: ScreenSize.height - HMChatConstants.defaultInputViewHeight, width: ScreenSize.width, height: HMChatConstants.defaultInputViewHeight)
        self.init(frame: frame)
        
        if appearance == .dark {
            self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        } else {
            self.backgroundColor = UIColor.white
        }
        
        self.setupDividerLabel()
        self.setupInputTextView()
        self.setupSendButton()
        self.setupBottomButtons()
    }
    
    func setupDividerLabel() {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: 1.0))
        label.text = nil
        label.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        self.addSubview(label)
        
    }
    
    func setupInputTextView() {
        inputTextView = UIPlaceHolderTextView(frame: CGRect(x: 8.0, y: HMChatConstants.defaultInputTextViewMargin, width: self.bounds.width - HMChatConstants.defaultSendInputViewButtonSize.width - 8.0, height: self.bounds.height - HMChatConstants.defaultInputTextViewMargin * 2 - HMChatConstants.defaultInputBottomButtonHeight))
        inputTextView.font = HMChatConstants.defaultMessageTextFont
        inputTextView.placeholder = HMChatConstants.placeholderText
        inputTextView.backgroundColor = UIColor.clear
        inputTextView.delegate = self
        inputTextView.bounces = false
        inputTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        inputTextView.keyboardAppearance = UIKeyboardAppearance.default
        
        self.addSubview(inputTextView)
    }
    
    func setupSendButton() {
        sendButton = UIButton(type: UIButtonType.custom)
        sendButton.frame = CGRect(x: self.bounds.width - HMChatConstants.defaultSendInputViewButtonSize.width, y: 0, width: HMChatConstants.defaultSendInputViewButtonSize.width, height: HMChatConstants.defaultSendInputViewButtonSize.height)
        sendButton.backgroundColor = UIColor.clear
        sendButton.setTitle(nil, for: .normal)
        sendButton.setImage(UIImage(named: "chat_blue_arrow"), for: .normal)
        sendButton.setImage(UIImage(named: "chat_gray_arrow"), for: .selected)
        sendButton.showsTouchWhenHighlighted = true
        sendButton.addTarget(self, action: #selector(self.sendButtonTapped(_:)), for: .touchUpInside)
        sendButton.isSelected = true
        self.addSubview(sendButton)
    }
    
    func setupBottomButtons() {
        let buttonWidth = self.bounds.width / 4
        
        cameraButton = UIButton(type: UIButtonType.custom)
        cameraButton.frame = CGRect(x: 0.0, y: self.bounds.height - HMChatConstants.defaultInputBottomButtonHeight, width: buttonWidth, height: HMChatConstants.defaultInputBottomButtonHeight)
        cameraButton.setImage(UIImage(named: "camera_upload_icon"), for: UIControlState.normal)
        cameraButton.backgroundColor = UIColor.clear
        cameraButton.showsTouchWhenHighlighted = true
        cameraButton.addTarget(self, action: #selector(self.cameraButtonTapped(_:)), for: .touchUpInside)
        self.addSubview(cameraButton)
        
        locationButton = UIButton(type: UIButtonType.custom)
        locationButton.frame = CGRect(x: buttonWidth, y: self.bounds.height - HMChatConstants.defaultInputBottomButtonHeight, width: buttonWidth, height: HMChatConstants.defaultInputBottomButtonHeight)
        locationButton.setImage(UIImage(named: "location_icon"), for: UIControlState.normal)
        locationButton.backgroundColor = UIColor.clear
        locationButton.showsTouchWhenHighlighted = true
        self.addSubview(locationButton)
        
        dealButton = UIButton(type: UIButtonType.custom)
        dealButton.frame = CGRect(x: buttonWidth * 2, y: self.bounds.height - HMChatConstants.defaultInputBottomButtonHeight, width: buttonWidth, height: HMChatConstants.defaultInputBottomButtonHeight)
        dealButton.setImage(UIImage(named: "shakehand_icon"), for: UIControlState.normal)
        dealButton.backgroundColor = UIColor.clear
        dealButton.showsTouchWhenHighlighted = true
        self.addSubview(dealButton)
        
        guestbookButton = UIButton(type: UIButtonType.custom)
        guestbookButton.frame = CGRect(x: buttonWidth * 3, y: self.bounds.height - HMChatConstants.defaultInputBottomButtonHeight, width: buttonWidth, height: HMChatConstants.defaultInputBottomButtonHeight)
        guestbookButton.setImage(UIImage(named: "guestbook_icon"), for: UIControlState.normal)
        guestbookButton.backgroundColor = UIColor.clear
        guestbookButton.showsTouchWhenHighlighted = true
        self.addSubview(guestbookButton)
    }
    
    //MARK: UITextView Delegate
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if (hmDelegate != nil) {
            hmDelegate!.hmInputViewShouldBeginEditing()
        }
        return true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if (hmDelegate != nil) {
            hmDelegate!.hmInputViewShouldEndEditing()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let text: String = textView.text

        if HMString.stringByTrimingWhitespace(text as String) != "" {
            sendButton.isSelected = false
        } else {
            sendButton.isSelected = true
        }
        
        let numLines = Int(textView.contentSize.height / textView.font!.lineHeight) - 1
        let calculatedHeight: CGFloat = CGFloat(numLines * 20) + HMChatConstants.defaultInputViewHeight
        if hmDelegate != nil {
            let height = min(calculatedHeight, HMChatConstants.defaultInputViewMaxHeight)
            hmDelegate!.hmInputViewShouldUpdateHeight(height)
            self.updateSubViewFrame()
        }
    }
    
    //MARK: Button Action
    
    func sendButtonTapped(_ sender: UIButton) {
        if sendButton.isSelected == true {
            return
        }
        if (hmDelegate != nil) {
            let text = HMString.stringByTrimingWhitespace(inputTextView.text!)
            hmDelegate!.hmInputViewDidPressSendButton(text)
        }
    }
    
    func cameraButtonTapped(_ sender: UIButton) {
        if (hmDelegate != nil) {
            if hmDelegate!.hmInputViewDidPressCameraButton != nil {
                hmDelegate!.hmInputViewDidPressCameraButton!()
            }
        }
        
    }
    
    
    func clearText(_ resignFirstResponder: Bool){
        inputTextView.text = ""
        if resignFirstResponder == true {
            inputTextView.resignFirstResponder()
        }
        sendButton.isSelected = true
        if (hmDelegate != nil) {
            hmDelegate!.hmInputViewShouldUpdateHeight(HMChatConstants.defaultInputViewHeight)
            self.updateSubViewFrame()
        }
    }
    
    func getText() -> String {
        let text = HMString.stringByTrimingWhitespace(inputTextView.text!)
        return text
    }
    
    func hmResignFirstResponder() {
        inputTextView.resignFirstResponder()
        if hmDelegate != nil {
            hmDelegate!.hmTextViewResignFirstResponder()
        }
    }
    
    func updateSubViewFrame() {
        self.sendButton.frame.origin.y = self.bounds.height - HMChatConstants.defaultSendInputViewButtonSize.height - HMChatConstants.defaultInputBottomButtonHeight
        self.cameraButton.frame.origin.y = self.bounds.height - HMChatConstants.defaultInputBottomButtonHeight
        self.locationButton.frame.origin.y = self.bounds.height - HMChatConstants.defaultInputBottomButtonHeight
        self.dealButton.frame.origin.y = self.bounds.height - HMChatConstants.defaultInputBottomButtonHeight
        self.guestbookButton.frame.origin.y = self.bounds.height - HMChatConstants.defaultInputBottomButtonHeight
        self.inputTextView.frame.origin.y = HMChatConstants.defaultInputTextViewMargin
        self.inputTextView.frame.size.height = self.bounds.height - HMChatConstants.defaultInputTextViewMargin * 2 - HMChatConstants.defaultInputBottomButtonHeight
        let textLength = (self.inputTextView.text as NSString).length
        if textLength > 0 {
            self.inputTextView.scrollRangeToVisible(NSMakeRange(textLength - 1, 1))
        }
    }
}
