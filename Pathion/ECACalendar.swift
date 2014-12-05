//
//  PTCalendar.swift
//  Pathion
//
//  Created by justin cheng on 20/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

class ECACalendar: UIViewController, UIScrollViewDelegate {
    
    var meta = NSDictionary()
    var cals = [UIImageView]()
    
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let navBarSize: CGSize = self.navigationController!.navigationBar.bounds.size
        let rec = CGRect(x: 0.0, y: 64.0, width: screenSize.width, height: screenSize.height-navBarSize.height-20.0)
        scrollView.frame = rec
        for (var i = 1; i <= 11; i++) {
            var y: Int
            if i<=4 {
                y = 14
            } else {
                y = 15
            }
            
            let imageName = String(format:"%02d_%02d", y,(i+7)%12+1)
            var image: UIImage
            
            let prefs = NSUserDefaults.standardUserDefaults()
            if prefs.objectForKey(imageName) == nil {
                image = UIImage(named: imageName)!
            } else {
                image = UIImage(data: prefs.objectForKey(imageName) as NSData)!
            }
            cals.append(UIImageView(image: image))
            
            // setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
            var rect: CGRect = cals[i-1].frame
            rect.size.height = screenSize.height-navBarSize.height-20.0
            rect.size.width = screenSize.width
            rect.origin.x = screenSize.width * CGFloat(i-1)
            rect.origin.y = -64.0
            cals[i-1].frame = rect
            cals[i-1].tag = i	// tag our images for later use when we place them in serial fashion
            scrollView.addSubview(cals[i-1])
        }
        scrollView.contentSize = CGSize(width: 11*screenSize.width, height: scrollView.frame.height-navBarSize.height-20.0)
        
        download_meta(false)
    }
    
    override func viewWillAppear(animated: Bool) {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitYear | .CalendarUnitMonth, fromDate: date)
        let year = components.year
        let thisMonth = components.month
        var pageNum = 0
        if (year < 2014) {
            pageNum = 0;
        } else if (year == 2014) {
            if (thisMonth <= 9) {
                pageNum = 0
            } else {
                pageNum = thisMonth-9;
            }
        } else if (year == 2015) {
            if (thisMonth <= 7) {
                pageNum = thisMonth + 3
            } else {
                pageNum = 10
            }
        } else {
            pageNum = 10
        }
        var frame: CGRect = scrollView.frame;
        frame.origin.x = frame.size.width * CGFloat(pageNum)
        frame.origin.y = 0.0
        scrollView.scrollRectToVisible(frame, animated:false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func download_meta(alarm: Bool) {
        let urls = "https://www.dropbox.com/s/1v4achgks33ecrm/calendar.json?dl=1"
        let URL: NSURL = NSURL(string: urls)!
        var e: NSError?
        let request: NSURLRequest = NSURLRequest(URL: URL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error == nil {
                self.meta = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &e) as NSDictionary
                self.download(alarm)
            } else {
                var alert = UIAlertController(title: "Error", message: "Failed to download metadata.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func refresh() {
        download_meta(true)
    }
    
    func download(alarm: Bool) {
        var prefs = NSUserDefaults.standardUserDefaults()
        var flag = true
        for (var i = 1; i <= 11; i++) {
            var y: Int
            if i<=4 {
                y = 14
            } else {
                y = 15
            }
            let vName = String(format:"v%02d_%02d", y,(i+7)%12+1)
            let ov = prefs.integerForKey(vName)
            let v = meta.objectForKey(vName) as Int
            if (v>ov) {
                flag = false
                let name = String(format:"%02d_%02d", y,(i+7)%12+1)
                let URLs = meta.objectForKey(name) as String
                let url = NSURL(string: URLs)
                var e: NSError?
                let request: NSURLRequest = NSURLRequest(URL: url!)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if error == nil {
                        prefs.setObject(data, forKey: name)
                        prefs.setInteger(v, forKey: vName)
                        prefs.synchronize()
                        self.load()
                    } else {
                        var alert = UIAlertController(title: "Error", message: "Failed to download \(name).", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                })
            }
        }
        if flag && alarm {
            var alert = UIAlertController(title: "Updated", message: "The calendars are up to date.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func load() {
        let prefs = NSUserDefaults.standardUserDefaults()
        for (var i = 1; i <= 11; i++) {
            var y: Int
            if i<=4 {
                y = 14
            } else {
                y = 15
            }
            let name = String(format:"%02d_%02d", y,(i+7)%12+1)
            if prefs.objectForKey(name) != nil {
                cals[i-1].image = UIImage(data: prefs.objectForKey(name) as NSData)!
            }
        }
    }
    
}
