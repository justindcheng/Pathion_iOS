//
//  ClassMgr.swift
//  Pathion
//
//  Created by justin cheng on 21/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

var theClassMgr = ClassMgr()

class ClassMgr: NSObject {
    var cls = 0
    var count = 47
    var urls = NSDictionary()
    
    override init() {
        let prefs = NSUserDefaults.standardUserDefaults()
        cls = prefs.integerForKey("class")
        var e: NSError?
        let filePath = NSBundle.mainBundle().pathForResource("timetable", ofType: "json")
        var da: NSData = NSData(contentsOfFile: filePath!, options: nil, error: &e)!
        urls = NSJSONSerialization.JSONObjectWithData(da, options: nil, error: &e) as NSDictionary
    }
    
    func setClass(clsIndex: Int) {
        cls = clsIndex
        var prefs = NSUserDefaults.standardUserDefaults()
        prefs.setInteger(cls, forKey: "class")
        prefs.synchronize()
    }
    
    func className(clsIndex: Int) -> String {
        switch (clsIndex) {
        case 0: return "1A"
        case 1: return "1B"
        case 2: return "1C"
        case 3: return "1D"
        case 4: return "1E"
        case 5: return "1F"
        case 6: return "1G"
        case 7: return "2A"
        case 8: return "2B"
        case 9: return "2C"
        case 10: return "2D"
        case 11: return "2E"
        case 12: return "2F"
        case 13: return "2G"
        case 14: return "3A"
        case 15: return "3B"
        case 16: return "3C"
        case 17: return "3D"
        case 18: return "3E"
        case 19: return "3F"
        case 20: return "3G"
        case 21: return "4A"
        case 22: return "4B"
        case 23: return "4C"
        case 24: return "4D"
        case 25: return "4E"
        case 26: return "4F"
        case 27: return "4G"
        case 28: return "4H"
        case 29: return "4I"
        case 30: return "5A"
        case 31: return "5B"
        case 32: return "5C"
        case 33: return "5D"
        case 34: return "5E"
        case 35: return "5F"
        case 36: return "5G"
        case 37: return "5H"
        case 38: return "5I"
        case 39: return "5J"
        case 40: return "6A"
        case 41: return "6B"
        case 42: return "6C"
        case 43: return "6D"
        case 44: return "6E"
        case 45: return "6F"
        case 46: return "6G"
        default: return "undefined"
        }
    }
    
    func url(cls: String) -> String {
        return urls.objectForKey(cls) as String
    }
}
