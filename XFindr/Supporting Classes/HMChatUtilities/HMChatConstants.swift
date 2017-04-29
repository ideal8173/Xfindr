//
//  HMChatConstants.swift
//  XFindr
//
//  Created by Honey Maheshwari on 4/19/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import Foundation

struct HMChatConstants {
    static let chatMessageCellIndentifier = "HMChatMessageCell"
    static let chatImageCellIndentifier = "HMChatImageCell"
    
    
    static let messageTextMaximumWidth: CGFloat = ScreenSize.width * 0.75
    static let defaultLineSpacing: CGFloat = 2.0
    static let defaultTextMargin: CGFloat = 10.0
    static let defaultMargin: CGFloat = 5.0
    
    //MARK: CELL
    
    static let defaultTextMinHeight: CGFloat = 25.0
    static let defaultTextMinWidth: CGFloat = 60.0
    static let defaultAngleWidth: CGFloat = 8.0
    static let defaultIconSize: CGFloat = 0.0
    static let defaultIconToMessageMargin: CGFloat = 0.0
    static let defaultDateLabelHeight: CGFloat = 30.0
    static let defaultTimeLabelHeight: CGFloat = 20.0
    static let defaultDateLabelMargin: CGFloat = 5.0
    
    static let defaultAddressPaddingPercent: CGFloat = 0.95
    
    static let defaultImageMessageSize: CGSize = CGSize(width: 210.0, height: 150.0)
    static let defaultLoaderSize: CGSize = CGSize(width: 50.0, height: 50.0)
    static let defaultUploadDownloadButtonSize: CGSize = CGSize(width: 35.0, height: 35.0)
    
    static let defaultDateLabelFont: UIFont = UIFont.systemFont(ofSize: 14)
    static let defaultTimeLabelFont: UIFont = UIFont.systemFont(ofSize: 13)
    
    static let defaultOutgoingColor: UIColor = UIColor(red: 220/255, green: 248/255, blue: 198/255, alpha: 1)
    static let defaultIncomingColor: UIColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
    static let defaultBgColor: UIColor = UIColor(red: 229/255, green: 221/255, blue: 213/255, alpha: 1)
    static let defaultDateLabelBgColor: UIColor = UIColor(hm_hexString: "0xD4EAF4")
    
    //MARK: Bubble
    
    static let defaultMessageRoundCorner: CGFloat = 10.0
    
    //MARK: HMInputView
    
    static let defaultInputViewHeight: CGFloat = 90.0
    static let defaultSendInputViewButtonSize: CGSize = CGSize(width: 45.0, height: 45.0)
    static let defaultInputTextViewHeight: CGFloat = 30.0
    static let defaultInputViewMaxHeight: CGFloat = 150.0
    static let defaultInputTextViewMargin: CGFloat = 8.0
    static let defaultInputBottomButtonHeight: CGFloat = 45.0
    static let placeholderText = "Type your message here..."
    
    static let defaultMessageTextFont: UIFont = UIFont.systemFont(ofSize: 16)
}

struct HMChatUserType {
    static let unknown: Int = 0
    static let me: Int = 1
    static let other: Int = 2
}

struct HMChatMessageType {
    static let unknown: Int = 0
    static let text: Int = 1
    static let image: Int = 2
    static let audio: Int = 3
    static let video: Int = 4
    static let location: Int = 5
    static let contact: Int = 6
}

struct HMChatMessageStatus {
    static let unknown: Int = 0
    static let waitingToSend: Int = 1
    static let sending: Int = 2
    static let send: Int = 3
    static let received: Int = 4
    static let errorWhileSendingTextMessage: Int = 5
    
    static let waitingToDownload: Int = 11
    static let download: Int = 12
    static let downloading: Int = 13
    static let downloaded: Int = 14
    static let savedToDevice: Int = 15
    static let errorWhileDownloading: Int = 16
    static let errorWhileSaving: Int = 17
    
    static let waitingToUpload: Int = 20
    static let upload: Int = 21
    static let uploading: Int = 22
    static let uploaded: Int = 23
    static let sendingToServer: Int = 24
    static let errorWhileUploading: Int = 25
    static let errorWhileSendingMedia: Int = 26
}

struct HMReadUnreadState {
    static let readed: Int = 1
    static let unReaded: Int = 2
}

enum HMReloadStatus {
    case reload
    case imagePicker
    case contactPicker
    case locationPicker
}

enum HMImageState {
    case dontCare
    case fetching
    case available
    case notAvailable
    case error
}

enum HMUserTyping {
    case send
    case failedToSend
    case notTyping
}
