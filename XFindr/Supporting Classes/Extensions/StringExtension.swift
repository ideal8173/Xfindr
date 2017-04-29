//
//  StringExtension.swift
//  testFTChat
//
//  Created by Honey Maheshwari on 9/1/16.
//  Copyright © 2016 Honey Maheshwari. All rights reserved.
//

import Foundation

extension String {
    
    var hm_LastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    
    var hm_PathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }
    
    var hm_StringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).deletingLastPathComponent
        }
    }
    
    var hm_StringByDeletingPathExtension: String {
        get {
            return (self as NSString).deletingPathExtension
        }
    }
    
    var hm_PathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }
    
    var hm_Length: Int {
        get {
            return (self as NSString).length
        }
    }
    
    func hm_StringByAppendingPathComponent(_ path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func hm_StringByAppendingPathExtension(_ ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
    
    func hm_StringToDictionary() -> NSDictionary {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: [])
                if let ddd: NSDictionary = dict as? NSDictionary {
                    return ddd
                }
            } catch let err {
                print("err >>>>> \(err)")
            }
        }
        return NSDictionary()
    }
    
    var numbersOnly: String {
        return components(separatedBy: NSCharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    var integerValue: Int {
        return Int(self) ?? 0
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var hasOnlyNewlineSymbols: Bool {
        return trimmingCharacters(in: CharacterSet.newlines).isEmpty
    }
    
    
    var hm_First: String {
        return String(characters.prefix(1))
    }
    
    var hm_Last: String {
        return String(characters.suffix(1))
    }
    
    var hm_UppercaseFirst: String {
        return hm_First.uppercased() + String(characters.dropFirst())
    }
    
    var hm_UppercaseEveryWord: String {
        return self.capitalized(with: Locale.current)
    }
    
    
}

extension Double {
    struct Number {
        static let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            return formatter
        }()
    }
    
    var twoDigits: String {
        return Number.formatter.string(from: NSNumber(value: self)) ?? ""
    }
}



