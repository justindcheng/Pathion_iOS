//
//  Marks.swift
//  Pathion
//
//  Created by justin cheng on 21/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

var theMarks = Marks()

class Marks: NSObject {
    var marks: [NSDictionary]?
    override init() {
        let prefs = NSUserDefaults.standardUserDefaults()
        marks = prefs.arrayForKey("marks") as [NSDictionary]?
        if marks == nil {
            marks = [NSDictionary]()
        }
    }
    
    func count() -> Int {
        return marks!.count
    }
    
    func addMark(sub: String, mark: Int, full: Int) {
        let newSub = NSDictionary(objects: [sub, mark, full], forKeys: ["subject", "mark", "full"])
        marks!.append(newSub)
        marks!.sort { (t1: NSDictionary, t2: NSDictionary) -> Bool in
            return t2.objectForKey("subject") as String > t1.objectForKey("subject") as String
        }
        save()
    }
    
    func removeMark(index: Int) {
        marks!.removeAtIndex(index)
        save()
    }
    
    func getMark(index: Int) -> NSDictionary {
        return marks![index]
    }
    
    func getAvg() -> Double {
        if (getTotalMarks() == 0) {
            return 0
        } else {
            var avg = Double(getTotalMarks())/Double(getTotalFull())
            avg *= 10000
            avg = Double(Int(avg + 0.5))
            avg /= 100
            return avg
        }
    }
    
    func getTotalMarks() -> Int {
        var tot = 0
        for (var i = 0; i < marks!.count; i++) {
            tot += marks![i].objectForKey("mark") as Int
        }
        return tot
    }
    
    func getTotalFull() -> Int {
        var tot = 0
        for (var i = 0; i < marks!.count; i++) {
            tot += marks![i].objectForKey("full") as Int
        }
        return tot
    }
    
    func save() {
        var prefs = NSUserDefaults.standardUserDefaults()
        prefs.setObject(marks!, forKey: "marks")
        prefs.synchronize()
    }
}
