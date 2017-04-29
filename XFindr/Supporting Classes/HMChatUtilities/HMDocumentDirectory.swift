//
//  HMDocumentDirectory.swift
//  XFindr
//
//  Created by Honey Maheshwari on 4/24/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit

class HMDocumentDirectory: NSObject {
    
    class func hmGetDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    class func hmGetUniqueNameForAudioFile() -> String {
        let timeInterval = Date().timeIntervalSince1970
        let unique = Int(timeInterval)
        let strUnique = "hm_audio_\(unique).m4a"
        return strUnique
    }
    
    class func hmDeleteFile(fileName: String) {
        let filePath = hmGetDocumentsDirectoryURL(forFileName: fileName)
        if !FileManager.default.fileExists(atPath: filePath.absoluteString) {
            do {
                try FileManager.default.removeItem(at: filePath)
            } catch let error {
                print("error while deleting file >>>> \(error)")
            }
        }
    }
    
    class func hmGetDocumentsDirectoryURL(forFileName: String) -> URL {
        return hmGetDocumentsDirectory().appendingPathComponent(forFileName)
    }
    
    func hmCheckContentOfDocumentsDirectory() {
        let hmFileManager = FileManager.default
        do {
            let contents = try hmFileManager.contentsOfDirectory(atPath: NSHomeDirectory().hm_StringByAppendingPathComponent("Documents"))
            print("contents >>>>> \(contents)")
        } catch let err {
            print(" NSHomeDirectory >>>> \(err)")
        }
    }
    
    class func hmGetUniqueNameForImageFile() -> String {
        let timeInterval = Date().timeIntervalSince1970
        let unique = Int(timeInterval)
        let strUnique = "hm_image_\(unique).png"
        return strUnique
    }
    
    class func hmSaveImage(image: UIImage?) -> String? {
        if let img = image {
            let imageUniqueName = hmGetUniqueNameForImageFile()
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath = paths.first {
                let writePath = URL(fileURLWithPath: dirPath).appendingPathComponent(imageUniqueName)
                do {
                    try UIImagePNGRepresentation(img)?.write(to: writePath)
                    return imageUniqueName
                } catch let err {
                    print(" NSHomeDirectory >>>> \(err)")
                    return nil
                }
            }
        }
        return nil
    }
    
    class func hmGetImage(forName name: String) -> UIImage? {
        if name.hm_Length > 0 {
            let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
            let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
            if let dirPath = paths.first {
                let readPath = URL(fileURLWithPath: dirPath).appendingPathComponent(name)
                let image = UIImage(contentsOfFile: readPath.path)
                return image
            }
        }
        return nil
    }
    
    /*
     let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
     let nsUserDomainMask    = FileManager.SearchPathDomainMask.userDomainMask
     let paths               = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
     if let dirPath          = paths.first
     {
     let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent("Image2.png")
     let image    = UIImage(contentsOfFile: imageURL.path)
     // Do whatever you want with the image
     }
     
     
     
     let nsDocumentDirectory = NSSearchPathDirectory.DocumentDirectory
     let nsUserDomainMask = NSSearchPathDomainMask.UserDomainMask
     if let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true) {
     if paths.count > 0 {
     if let dirPath = paths[0] as? String {
     let readPath = dirPath.stringByAppendingPathComponent("Image.png")
     let image = UIImage(named: readPath)
     let writePath = dirPath.stringByAppendingPathComponent("Image2.png")
     UIImagePNGRepresentation(image).writeToFile(writePath, atomically: true)
     }
     }
     }
     */
    
}
