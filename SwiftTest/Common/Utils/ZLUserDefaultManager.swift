//
//  ZLUserDefaultManager.swift
//  SwiftTest
//
//  Created by lezhi on 2018/6/22.
//  Copyright © 2018年 ZhangLiang. All rights reserved.
//

import UIKit

final class ZLUserDefaultManager: NSObject {
    //Any
    class func getLocalDataAny(key: String) -> Any? {
        let defaults = UserDefaults.standard
        if key.isEmpty {
            return nil
        }
        
        let object = defaults.object(forKey: key)
        return object
    }
    
    class func setLocalDataAny(value: Any, key: String) {
        let defaults = UserDefaults.standard
        if key.isEmpty {
            return
        }
        
        defaults.set(value, forKey: key)
    }
    
    //String
    class func getLocalString(key: String) -> String {
        let defaults = UserDefaults.standard
        if key.isEmpty {
            return ""
        }
        
        let localString = defaults.object(forKey: key) as! String
        return localString
    }
    
    class func setLocalDataString(value: String, key: String) {
        let defaults = UserDefaults.standard
        if key.isEmpty {
            return
        }
        
        defaults.set(value, forKey: key)
    }
    
    //Bool
    class func getLocalDataBool(key: String) -> Bool {
        let defaults = UserDefaults.standard
        if key.isEmpty {
            return false
        }
        
        let boolValue = defaults.bool(forKey: key)
        return boolValue
    }
    
    class func setLocalDataBool(value: Bool, key: String) {
        let defaults = UserDefaults.standard
        if key.isEmpty {
            return
        }
        
        defaults.set(value, forKey: key)
    }
    
    //Int
    class func getLocalDataInt(key: String) -> Int {
        let defaults = UserDefaults.standard
        if key.isEmpty {
            return 0
        }
        
        let intValue = defaults.integer(forKey: key)
        return intValue
    }
    
    class func setLocalDataInt(value: Int, key: String) {
        let defaults = UserDefaults.standard
        if key.isEmpty {
            return
        }
        
        defaults.set(value, forKey: key)
    }
    
    //Dictionary
    class func setLocalDataDict(value: Dictionary<String, Any>, key: String) {
        if key.isEmpty {
            return
        }
        UserDefaults.standard.set(value, forKey: key)
    }
    
    class func getLocalDataDict(key: String) -> Dictionary<String, Any>? {
        return UserDefaults.standard.dictionary(forKey: key)
    }
    
    //float
    //Double
}
