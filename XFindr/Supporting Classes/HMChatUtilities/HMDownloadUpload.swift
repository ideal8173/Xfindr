//
//  HMDownloadUpload.swift
//  XFindr
//
//  Created by Honey Maheshwari on 4/22/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class HMDownloadUpload: NSObject {
    
    var messageUniqueId: Int!
    var urlString: String!
    var progress: Float!
    var imageOperation: SDWebImageOperation?
    var uploadTask: URLSessionUploadTask?
    var state: HMDownloadUploadState!
    
    convenience init(messageUniqueId: Int, urlString: String, download: Bool) {
        self.init()
        self.messageUniqueId = messageUniqueId
        self.urlString = urlString
        self.progress = 0.0
        self.imageOperation = nil
        self.uploadTask = nil
        if download {
            state = HMDownloadUploadState.download
        } else {
            state = HMDownloadUploadState.upload
        }
        
    }
    
    class func removeDownloadingImage(strUrl: String) {
        SDImageCache.shared().removeImage(forKey: strUrl)
        SDImageCache.shared().removeImage(forKey: strUrl)
    }
    
    class func downloadImage(_ download: HMDownloadUpload, progress uploadProgressBlock: ((Float) -> Void)?, completionHandler: ((_ image: UIImage?, _ error: NSError?) -> Void)?){
        if let url: URL = URL(string: download.urlString) {
            let manager = SDWebImageManager.shared()
            download.imageOperation = manager?.downloadImage(with: url, options: SDWebImageOptions.retryFailed, progress: { (receivedSize, expectedSize) in
                let r = Float(receivedSize)
                let e = Float(expectedSize)
                let a = Float(r / e)
                if uploadProgressBlock != nil {
                    uploadProgressBlock!(a)
                }
            }, completed: { (image, error, cacheType, finished, imageURL) in
                if image != nil {
                    SDImageCache.shared().removeImage(forKey: download.urlString)
                    SDImageCache.shared().removeImage(forKey: imageURL?.absoluteString)
                    if completionHandler != nil {
                        completionHandler!(image, nil)
                    }
                } else {
                    if completionHandler != nil {
                        completionHandler!(nil, error as NSError?)
                    }
                }
            })
        }
    }
    
    class func uploadImageWithProgress(_ upload: HMDownloadUpload, header: [String : AnyObject], parameters: [String : AnyObject], img: UIImage!, imgServerParamName: String!, progress uploadProgressBlock: ((Progress) -> Void)?, completionHandler: ((_ dict: NSDictionary?, _ error: NSError?) -> Void)?) {
        
        let request: NSMutableURLRequest = AFHTTPRequestSerializer().multipartFormRequest(withMethod: "POST", urlString: upload.urlString, parameters: parameters, constructingBodyWith: { (formData) in
            
            formData.appendPart(withFileData: UIImagePNGRepresentation(img)!, name: "file", fileName: "test", mimeType: "image/png")
            
        }, error: nil)
        //
        //        let request: NSMutableURLRequest = HMWebService.createRequest(forImage: upload.urlString, methodType: HM_HTTPMethod.POST, andHeaderDict: header, andParameterDict: parameters, andImageNameAsKeyAndImageAsItsValue: [imgServerParamName: img])
        
        let manager: AFURLSessionManager = AFHTTPSessionManager(sessionConfiguration: URLSessionConfiguration.default)
        
        //        upload.uploadTask = manager.uploadTaskWithStreamedRequest(request, progress: { (uploadProgress) in
        //            print("uploadProgress.fractionCompleted >>>>> \(uploadProgress.fractionCompleted)")
        //            }, completionHandler: { (response, responseObject, error) in
        //
        //        })
        
        upload.uploadTask = manager.uploadTask(withStreamedRequest: request as URLRequest, progress: uploadProgressBlock, completionHandler: { (response, responseObject, error) in
            
            if error == nil && responseObject != nil {
                let dict = HMWebService.getDictionaryFromResponseObject(responseObject!) as NSDictionary
                if completionHandler != nil {
                    completionHandler!(dict, nil)
                }
            } else {
                if completionHandler != nil {
                    completionHandler!(NSDictionary(), error as NSError?)
                }
            }
        })
        
        upload.uploadTask?.resume()
    }
    
}

enum HMDownloadUploadState {
    case download
    case upload
}
