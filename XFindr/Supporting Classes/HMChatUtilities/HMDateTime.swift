//
//  HMDateTime.swift
//  testFTChat
//
//  Created by Honey Maheshwari on 9/1/16.
//  Copyright © 2016 Honey Maheshwari. All rights reserved.
//

import UIKit

class HMDateTime: NSObject {
    
    //MARK: Time
    
    class func getCurrentTimeInSeconds() -> Double {
        let currentime = Date().timeIntervalSince1970
        return currentime
    }
    
    class func convertSecToMS(sec: Double) -> Double {
        return floor(sec * 1000)
    }
    
    class func convertMSToSec(ms: Double) -> Double {
        return Double(ms / 1000)
    }
    
    class func getCurrentTimeInMS() -> Double {
        let currentime = Date().timeIntervalSince1970
        return floor(currentime)
    }
    
    class func getCurrentTimeInMS_String() -> String {
        let currentime = Date().timeIntervalSince1970 * 1000
        let strMS = "\(floor(currentime))"
        return strMS
    }
    /*
     let date_time = "2017-04-24T13:59:52+00:00"
     var dateFormat = DateFormatter()
     dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ'"
     dateFormat.timeZone = TimeZone(identifier: "UTC")
     if let date = dateFormat.date(from: date_time) {
     print("date >>>>>> \(date)")
     dateFormat = DateFormatter()
     dateFormat.timeZone = TimeZone.autoupdatingCurrent
     dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
     let str = dateFormat.string(from: date)
     print("str >>>>>> \(str)")
     let timeInterval = date.timeIntervalSince1970
     print("timeInterval >>>>>> \(timeInterval)")
     }
     */
    
    class func getMessageTimeWhenReceived(dict: NSDictionary) -> TimeInterval {
        let current_time = dict.hmGetDouble(forKey: HMSocketConstants.current_time)
        if current_time != 0.0 {
            return HMDateTime.convertMSToSec(ms: current_time)
        }
        
        let date_time = HelperClass.checkObjectInDictionaryWithNoDecimal(dictH: dict, strObject: HMSocketConstants.date_time)
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ'"
        dateFormat.timeZone = TimeZone(identifier: "UTC")
        if let date = dateFormat.date(from: date_time){
            return date.timeIntervalSince1970
        }
        return Date().timeIntervalSince1970
    }
    
    class func convertTimeIntervalToLocalDateString(_ timeInSec: Double) -> String {
        let timeInterval = timeInSec
        let converteDate: Date? = Date(timeIntervalSince1970: timeInterval)
        if converteDate != nil {
            let df = DateFormatter()
            //df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            df.dateFormat = "yyyy-MM-dd"
            df.timeZone = TimeZone.autoupdatingCurrent
            df.dateStyle = DateFormatter.Style.medium
            //df.timeStyle = NSDateFormatterStyle.LongStyle
            let strDate: String? = df.string(from: converteDate!)
            if strDate != nil {
                return strDate!
            }
        }
        return ""
    }
    
    class func converTimeIntervalToLocalTimeString(_ timeInSec: Double) -> String {
        let timeInterval = timeInSec
        let converteDate: Date? = Date(timeIntervalSince1970: timeInterval)
        if converteDate != nil {
            let df = DateFormatter()
            df.dateFormat = "HH:mm:ss"
            df.timeZone = TimeZone.autoupdatingCurrent
            df.timeStyle = DateFormatter.Style.short
            let strDate: String? = df.string(from: converteDate!)
            if strDate != nil {
                return strDate!
            }
        }
        return ""
    }
    
    class func converDateTimeIntervalToLocalDateString(_ timeInSec: Double) -> String {
        let timeInterval = timeInSec
        let converteDate: Date? = Date(timeIntervalSince1970: timeInterval)
        if converteDate != nil {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            df.timeZone = TimeZone.autoupdatingCurrent
            df.dateStyle = DateFormatter.Style.medium
            df.timeStyle = DateFormatter.Style.medium
            let strDate: String? = df.string(from: converteDate!)
            if strDate != nil {
                return strDate!
            }
        }
        return ""
    }
    
    class func getCurrentDateAndTimeForDatabase() -> (timeInSec: String, dateInUTC: String) {
        let currentime = Date().timeIntervalSince1970
        let timeInSec = "\(currentime)"
        var dateInUTC = ""
        let converteDate: Date? = Date(timeIntervalSince1970: currentime)
        if converteDate != nil {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            df.timeZone = TimeZone(identifier: "UTC")
            let strDate: String? = df.string(from: converteDate!)
            if strDate != nil {
                dateInUTC = strDate!
            }
        }
        return (timeInSec, dateInUTC)
    }
    
    class func getDateFromSecForDatabase(_ timeInSec: Double) -> String {
        var dateInUTC = ""
        let converteDate: Date? = Date(timeIntervalSince1970: timeInSec)
        if converteDate != nil {
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            df.timeZone = TimeZone(identifier: "UTC")
            let strDate: String? = df.string(from: converteDate!)
            if strDate != nil {
                dateInUTC = strDate!
            }
        }
        return dateInUTC
    }
    /*
     
     + (NSMutableDictionary *)changeDateFormatToUTCForDataBase {
     NSMutableDictionary * dict = [NSMutableDictionary new];
     NSDateFormatter *dateFormat = [NSDateFormatter new];
     dateFormat = [NSDateFormatter new];
     /*
     [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
     [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
     */
     [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
     [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
     NSString *str2 = [dateFormat stringFromDate:[NSDate date]];
     NSDate *date = [dateFormat dateFromString:str2];
     NSString * timeInMS = [NSString stringWithFormat:@"%lld", [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]];
     [dict setObject:timeInMS forKey:@"timeInMS"];
     
     NSDateFormatter *dateFormat2 = [NSDateFormatter new];
     dateFormat2 = [NSDateFormatter new];
     [dateFormat2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     [dateFormat2 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
     NSString *str3 = [dateFormat2 stringFromDate:date];
     [dict setObject:str3 forKey:@"timeInUTC"];
     
     return dict;
     }
     */
    
}
