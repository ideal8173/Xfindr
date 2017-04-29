//
//  HMLocationManager.swift
//  XFindr
//
//  Created by Rajat on 4/4/17.
//  Copyright © 2017 Honey Maheshwari. All rights reserved.
//

import UIKit
import CoreLocation

protocol HMLocationManagerDelegate {
    func hmLocationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
}

class HMLocationManager: NSObject, CLLocationManagerDelegate {
    
    class var sharedInstance: HMLocationManager {
        struct Singleton {
            static let instance = HMLocationManager()
        }
        return Singleton.instance
    }

    var locationManager: CLLocationManager!
    var locationUpdateTimer: Timer?
    var delegate: HMLocationManagerDelegate?
    static let distanceFilter: Double = 1000.0
    static let timeDuration: Double = 600.0
    
    class func sharedLocationManager() -> CLLocationManager {
        if sharedInstance.locationManager == nil {
            sharedInstance.locationManager = CLLocationManager()
            sharedInstance.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            //sharedInstance.locationManager.requestAlwaysAuthorization()
            sharedInstance.locationManager.requestWhenInUseAuthorization()
            /*
            if #available(iOS 9.0, *) {
                sharedInstance.locationManager.allowsBackgroundLocationUpdates = true
            } else {
                // Fallback on earlier versions
            }
            sharedInstance.locationManager.pausesLocationUpdatesAutomatically = false
 */
        }
        return sharedInstance.locationManager
    }
    
    class func setupHMLocationManagerDelegate(delegate: HMLocationManagerDelegate?) {
        sharedInstance.delegate = delegate
    }
    
    fileprivate func restartLocationUpdates() {
        if self.locationUpdateTimer != nil {
            self.locationUpdateTimer?.invalidate()
            self.locationUpdateTimer = nil
        }
        
        let locationManager = HMLocationManager.sharedLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.distanceFilter = HMLocationManager.distanceFilter
        //locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func startLocationTracking() {
        if CLLocationManager.locationServicesEnabled() == false {
            
        } else {
            let authorizationStatus = CLLocationManager.authorizationStatus()
            if authorizationStatus == .denied || authorizationStatus == .restricted {
                
            } else {
                let locationManager = HMLocationManager.sharedLocationManager()
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
                locationManager.distanceFilter = HMLocationManager.distanceFilter
                //locationManager.requestAlwaysAuthorization()
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
            }
        }
    }
    
    fileprivate func stopLocationTracking() {
        if self.locationUpdateTimer != nil {
            self.locationUpdateTimer?.invalidate()
            self.locationUpdateTimer = nil
        }
        
        let locationManager = HMLocationManager.sharedLocationManager()
        locationManager.stopUpdatingLocation()
    }
    
    class func getUserLatLong() -> CLLocationCoordinate2D {
        if let location = sharedLocationManager().location {
            return location.coordinate
        }
        return CLLocationCoordinate2DMake(0.0, 0.0)
    }
    
    class func startUpdatingLoactionToServer() {
        if let timer = sharedInstance.locationUpdateTimer {
            timer.invalidate()
            sharedInstance.locationUpdateTimer = nil
        }
        HMLocationDefaults.removeDefaults()
        HMLocationDefaults.createDefaultDict()
        sharedInstance.startTimer()
        sharedInstance.locationUpdateTimer = Timer.scheduledTimer(timeInterval: timeDuration, target: sharedInstance, selector: #selector(sharedInstance.startTimer), userInfo: nil, repeats: true)
        sharedInstance.startLocationTracking()
    }
    
    class func stopUpdatingLocationToServer() {
        if let timer = sharedInstance.locationUpdateTimer {
            timer.invalidate()
            sharedInstance.locationUpdateTimer = nil
        }
        sharedInstance.stopLocationTracking()
        HMLocationDefaults.removeDefaults()
    }
    
    func startTimer(){
        HMUtilities.hmBackgroundQueue {
            HMLocationManager.sharedInstance.updateCurrentLocationToServer()
        }
    }
    
    fileprivate func updateCurrentLocationToServer() {
        var strLat = ""
        var strLong = ""
        
        let locationManager = HMLocationManager.sharedLocationManager()
        
        if locationManager.location != nil {
            strLat = "\(locationManager.location!.coordinate.latitude)"
            strLong = "\(locationManager.location!.coordinate.longitude)"
        } else {
            
        }
        
        if strLat == "" || strLong == "" {
            return
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var myLastLocation = CLLocationCoordinate2DMake(0.0, 0.0)
        _ = HMLocationDefaults.getLastLocation()
        
        delegate?.hmLocationManager(manager, didUpdateLocations: locations)
        
        for location in locations {
            let theLocation = location.coordinate
            let theAccuracy = location.horizontalAccuracy
            let locationAge = -location.timestamp.timeIntervalSinceNow
            if locationAge > 20 {
                continue
            }
            if CLLocationCoordinate2DIsValid(theLocation) && theAccuracy > 0 && theAccuracy < 2000 && (theLocation.latitude != 0.0 && theLocation.longitude != 0.0) {
                myLastLocation = theLocation
            }
        }
        
        let preTime = HMLocationDefaults.getPreviousTime()
        let currentTime = HMLocationDefaults.getCurrentTimeInNSTimeInterval()
        let timeDifference = fabs(currentTime - preTime)
        
        if (myLastLocation.latitude != 0.0 && myLastLocation.longitude != 0.0) {
            if timeDifference > 20 {
                HMLocationDefaults.changeDataInUserDefaults(forKey: HMLocationDefaults.lastLat, value: myLastLocation.latitude as AnyObject)
                HMLocationDefaults.changeDataInUserDefaults(forKey: HMLocationDefaults.lastLng, value: myLastLocation.longitude as AnyObject)
                HMLocationDefaults.changeDataInUserDefaults(forKey: HMLocationDefaults.lastTime, value: HMLocationDefaults.getCurrentTimeInNSTimeInterval() as AnyObject)
                HMLocationManager.sharedInstance.updateCurrentLocationToServer()
            }
        }
    }
    
}


class HMLocationDefaults: NSObject {
    static let defLoacation = "LoacationDict"
    static let lastLat = "lastLat"
    static let lastLng = "lastLng"
    static let lastTime = "lastTime"
    static let serverSendStatus = "serverSendStatus"
    static let date = "date"
    
    class func removeDefaults() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: defLoacation)
    }
    
    
    class func createDefaultDict() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: defLoacation)
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.local
        let strDate = dateFormatter.string(from: now)
        
        let dict = NSMutableDictionary()
        dict.hmSet(object: 0.0, forKey: lastLat)
        dict.hmSet(object: 0.0, forKey: lastLng)
        dict.hmSet(object: 0.0, forKey: lastTime)
        dict.hmSet(object: 0, forKey: serverSendStatus)
        dict.hmSet(object: strDate, forKey: date)
        defaults.set(dict, forKey: defLoacation)
    }
    
    class func changeDataInUserDefaults(forKey key: String, value: Any) {
        let defaults = UserDefaults.standard
        if let dictTmp = defaults.dictionary(forKey: defLoacation) {
            let dict = NSMutableDictionary(dictionary: dictTmp).mutableCopy() as! NSMutableDictionary
            dict.hmSet(object: value, forKey: key)
            defaults.set(dict, forKey: defLoacation)
        }
    }
    
    class func changeDataInUserDefaults(withDictionary dict: NSMutableDictionary) {
        let defaults = UserDefaults.standard
        if let dictTmp = defaults.dictionary(forKey: defLoacation) {
            let dictLocal = NSMutableDictionary(dictionary: dictTmp).mutableCopy() as! NSMutableDictionary
            for (key, value) in dict {
                dictLocal.hmSet(object: value, forKey: key as! String)
            }
            defaults.set(dict, forKey: defLoacation)
        }
    }
    
    class func getLastLocation() -> CLLocationCoordinate2D {
        
        var lat: Double = 0.0
        var lng: Double = 0.0
        
        let defaults = UserDefaults.standard
        if let dictTmp = defaults.dictionary(forKey: defLoacation) {
            let dict = NSDictionary(dictionary: dictTmp)
            if let doubleVlaue: Double = dict.object(forKey: lastLat) as? Double {
                lat = doubleVlaue
            } else if let numb: NSNumber = dict.object(forKey: lastLat) as? NSNumber {
                lat = Double(numb)
            } else if let str: String = dict.object(forKey: lastLat) as? String {
                if let numb = Double(str) {
                    lat = numb
                }
            }
            
            
            if let doubleVlaue: Double = dict.object(forKey: lastLng) as? Double {
                lng = doubleVlaue
            } else if let numb: NSNumber = dict.object(forKey: lastLng) as? NSNumber {
                lng = Double(numb)
            } else if let str: String = dict.object(forKey: lastLng) as? String {
                if let numb = Double(str) {
                    lng = numb
                }
            }
        }
        
        return CLLocationCoordinate2DMake(lat, lng)
        
    }
    
    class func getPreviousTime() -> Double {
        let defaults = UserDefaults.standard
        if let dictTmp = defaults.dictionary(forKey: defLoacation) {
            let dict = NSDictionary(dictionary: dictTmp)
            if let doubleVlaue: Double = dict.object(forKey: lastTime) as? Double {
                return doubleVlaue
            } else if let numb: NSNumber = dict.object(forKey: lastTime) as? NSNumber {
                return Double(numb)
            }
        }
        return NSDate().timeIntervalSince1970
    }
    
    class func getDate() -> String {
        let defaults = UserDefaults.standard
        if let dictTmp = defaults.dictionary(forKey: defLoacation) {
            let dict = NSDictionary(dictionary: dictTmp)
            return dict.object(forKey: date) as! String
        }
        return ""
    }
    
    class func getCurrentTimeInNSTimeInterval() -> Double {
        let currentTime = NSDate().timeIntervalSince1970
        return currentTime
    }
    
    class func checkForCurrentDate() -> Bool {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.local
        let strDate = dateFormatter.string(from: now)
        let preDate = getDate()
        if preDate == strDate {
            return true
        }
        
        return false
    }
    
}
