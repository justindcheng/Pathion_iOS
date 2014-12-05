//
//  Timetable.swift
//  Pathion
//
//  Created by justin cheng on 20/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

class Timetable: UIViewController, UIScrollViewDelegate {
    var scrollView: UIScrollView?
    var imgView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let navBarSize: CGSize = self.navigationController!.navigationBar.bounds.size
        let rec = CGRect(x: 0.0, y: 20.0 + navBarSize.height, width: screenSize.width, height: screenSize.height - navBarSize.height - 20.0)
        scrollView = UIScrollView(frame: rec)
        scrollView!.bounces = false
        scrollView!.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView!)
        
        imgView = UIImageView(image: UIImage(named: "1A"))
        let iw = Double(imgView!.frame.width)
        let ih = Double(imgView!.frame.height)
        let ratio: Double = iw / ih
        let w = ratio * Double(screenSize.height - navBarSize.height - 20.0)
        let rec2 = CGRectMake(0.0, -20.0 - navBarSize.height, CGFloat(w), screenSize.height - navBarSize.height - 20.0)
        imgView!.frame = rec2
        scrollView!.addSubview(imgView!)
        scrollView!.scrollEnabled = true
        var si = imgView!.frame.size
        si.height -= 64
        scrollView!.contentSize = si
        
        let prefs = NSUserDefaults.standardUserDefaults()
        if prefs.objectForKey("timetable") == nil {
            let urls = theClassMgr.url(theClassMgr.className(0))
            let url = NSURL(string: urls)
            let request: NSURLRequest = NSURLRequest(URL: url!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    theClassMgr.setClass(0)
                    var prefs = NSUserDefaults.standardUserDefaults()
                    prefs.setObject(data, forKey: "timetable")
                    prefs.synchronize()
                    self.downloaded()
                } else {
                    var alert = UIAlertController(title: "Error", message: "Failed to download timetable.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        } else {
            downloaded()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func update(index: Int) {
        
        if index == theClassMgr.cls {
            return
        }
        
        let urls = theClassMgr.url(theClassMgr.className(index))
        let url = NSURL(string: urls)
        let request: NSURLRequest = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error == nil {
                theClassMgr.setClass(index)
                var prefs = NSUserDefaults.standardUserDefaults()
                prefs.setObject(data, forKey: "timetable")
                prefs.synchronize()
                self.downloaded()
            } else {
                var alert = UIAlertController(title: "Error", message: "Failed to download timetable.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    func downloaded() {
        
        let prefs = NSUserDefaults.standardUserDefaults()
        let da = prefs.objectForKey("timetable") as NSData
        
        var img = UIImage(data: da)
        imgView!.image = img
    }
}
