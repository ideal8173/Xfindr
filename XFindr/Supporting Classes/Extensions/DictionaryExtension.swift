//
//  DictionaryExtension.swift
//  testSwift3SupportinClasses
//
//  Created by Honey Maheshwari on 9/26/16.
//  Copyright © 2016 Honey Maheshwari. All rights reserved.
//

import Foundation

extension NSDictionary {
    
    func hmGetObject(forKey key: String) -> Any? {
        return self.object(forKey: key)
    }

    func hmDictionaryToString() -> String {
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: self, options:  JSONSerialization.WritingOptions.prettyPrinted)
            if let encodedString: String = String(data: jsonData, encoding: String.Encoding.utf8) {
                return encodedString
            }
        } catch let err {
            print("err >>>> \(err)")
        }
        return ""
    }
    
    func hmGetInt(forKey key: String) -> Int {
        if let intVal: Int = self.object(forKey: key) as? Int {
            return intVal
        } else if let numVal: NSNumber = self.object(forKey: key) as? NSNumber {
            return Int(numVal)
        } else if let strVal: String = self.object(forKey: key) as? String {
            if let intVal: Int = Int(strVal) {
                return intVal
            }
        }
        return 0
    }
    
    func hmGetString(forKey key: String) -> String {
        if let strVal: String = self.object(forKey: key) as? String {
            return strVal
        } else if let val: Bool = self.object(forKey: key) as? Bool {
            if val == true {
                return "yes"
            } else {
                return "no"
            }
        }
        return ""
    }
    
    func hmGetFloat(forKey key: String) -> Float {
        if let floatVal: Float = self.object(forKey: key) as? Float {
            return floatVal
        } else if let numVal: NSNumber = self.object(forKey: key) as? NSNumber {
            return Float(numVal)
        } else if let strVal: String = self.object(forKey: key) as? String {
            if let floatVal: Float = Float(strVal) {
                return floatVal
            }
        }
        return 0.0
    }
    
    func hmGetDouble(forKey key: String) -> Double {
        if let doubleVal: Double = (self.object(forKey: key) as AnyObject).doubleValue {
            return doubleVal
        } else if let numVal: NSNumber = self.object(forKey: key) as? NSNumber {
            return Double(numVal)
        } else if let strVal: String = self.object(forKey: key) as? String {
            if let doubleVal: Double = Double(strVal) {
                return doubleVal
            }
        }
        return 0.0
    }
    
    func hmGetNSDictionary(forKey key: String) -> NSDictionary {
        if let dictVal: NSDictionary = self.object(forKey: key) as? NSDictionary {
            return dictVal
        } else if let dictVal: NSMutableDictionary = self.object(forKey: key) as? NSMutableDictionary {
            return dictVal
        }
        return NSDictionary()
    }
    
    func hmGetNSMutableDictionary(forKey key: String) -> NSMutableDictionary {
        if let dictVal: NSDictionary = self.object(forKey: key) as? NSDictionary {
            return NSMutableDictionary(dictionary: dictVal).mutableCopy() as! NSMutableDictionary
        } else if let dictVal: NSMutableDictionary = self.object(forKey: key) as? NSMutableDictionary {
            return NSMutableDictionary(dictionary: dictVal).mutableCopy() as! NSMutableDictionary
        }
        return NSMutableDictionary()
    }
    
    func hmGetNSArray(forKey key: String) -> NSArray {
        if let arrVal: NSArray = (self.object(forKey: key) as AnyObject) as? NSArray {
            return arrVal
        } else if let arrVal: NSMutableArray = self.object(forKey: key) as? NSMutableArray {
            return arrVal
        }
        return NSArray()
    }
    
    func hmGetNSMutableArray(forKey key: String) -> NSMutableArray {
        if let arrVal: NSArray = self.object(forKey: key) as? NSArray {
            return NSMutableArray(array: arrVal).mutableCopy() as! NSMutableArray
        } else if let arrVal: NSMutableArray = self.object(forKey: key) as? NSMutableArray {
            return NSMutableArray(array: arrVal).mutableCopy() as! NSMutableArray
        }
        return NSMutableArray()
    }
    
}

extension NSMutableDictionary {
    
    func hmSet(object: Any, forKey key: String!) {
        self.setObject(object, forKey: key as NSCopying)
    }
    
    func hmSet(value: Any, forKey key: String!) {
        if self.object(forKey: key) != nil {
            self.setObject(value, forKey: key as NSCopying)
        } else {
            self.setValue(value, forKey: key)
        }
    }
    
    func hmReplace(object: Any, forKey key: String!) {
        self.hmSet(value: object, forKey: key)
    }
    
    func hmReomoveObject(forKey key: String!) {
        self.removeObject(forKey: key)
    }
    
    func hmReomoveObjects(forKeys keys: [String]!) {
        self.removeObjects(forKeys: keys)
    }
    
    func hmReomoveAllObject(forKey key: String!) {
        self.removeAllObjects()
    }
}


extension String {
    
    func test() -> String {
        let str = self + "test"
        return str
    }
    
}
