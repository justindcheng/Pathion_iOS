//
//  FirstViewController.swift
//  Pathion
//
//  Created by justin cheng on 20/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

class PTHome: UIViewController {
    //@IBOutlet var dayOfWeek: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var weather: UILabel!
    @IBOutlet var temperature: UILabel!
    @IBOutlet var todayDay: UILabel!
    //@IBOutlet var tmrDay: UILabel!

    @IBOutlet var bEvent: UIButton!
    @IBOutlet var bTimetable: UIButton!
    @IBOutlet var bCalendar: UIButton!
    @IBOutlet var bVideo: UIButton!
    @IBOutlet var bForum: UIButton!
    @IBOutlet var bMark: UIButton!
    @IBOutlet var bWelfare: UIButton!
    @IBOutlet var bFacebook: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var screensize = self.view.frame.size
        screensize.height -= 64
        var rec = CGRect()
        rec.size.width = screensize.width/2-15
        rec.size.height = screensize.height/5-15
        
        rec.origin.x = 10
        rec.origin.y = 64 + screensize.height/5
        bEvent.removeFromSuperview()
        bEvent.setTranslatesAutoresizingMaskIntoConstraints(true)
        bEvent.frame = rec
        self.view.addSubview(bEvent)
        
        rec.origin.y += screensize.height/5
        bCalendar.removeFromSuperview()
        bCalendar.setTranslatesAutoresizingMaskIntoConstraints(true)
        bCalendar.frame = rec
        self.view.addSubview(bCalendar)
        
        rec.origin.y += screensize.height/5
        bForum.removeFromSuperview()
        bForum.setTranslatesAutoresizingMaskIntoConstraints(true)
        bForum.frame = rec
        self.view.addSubview(bForum)
        
        rec.origin.y += screensize.height/5
        bWelfare.removeFromSuperview()
        bWelfare.setTranslatesAutoresizingMaskIntoConstraints(true)
        bWelfare.frame = rec
        self.view.addSubview(bWelfare)
        
        rec.origin.x = 5 + screensize.width/2
        rec.origin.y = 64 + screensize.height/5
        bTimetable.removeFromSuperview()
        bTimetable.setTranslatesAutoresizingMaskIntoConstraints(true)
        bTimetable.frame = rec
        self.view.addSubview(bTimetable)
        
        rec.origin.y += screensize.height/5
        bVideo.removeFromSuperview()
        bVideo.setTranslatesAutoresizingMaskIntoConstraints(true)
        bVideo.frame = rec
        self.view.addSubview(bVideo)
        
        rec.origin.y += screensize.height/5
        bMark.removeFromSuperview()
        bMark.setTranslatesAutoresizingMaskIntoConstraints(true)
        bMark.frame = rec
        self.view.addSubview(bMark)
        
        rec.origin.y += screensize.height/5
        bFacebook.removeFromSuperview()
        bFacebook.setTranslatesAutoresizingMaskIntoConstraints(true)
        bFacebook.frame = rec
        self.view.addSubview(bFacebook)
        
        updateInfo()
        updateWeather(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateInfo() {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let today: String = dateFormatter.stringFromDate(NSDate())
        date.text = today
        //dateFormatter.dateFormat = "EEEE"
        //let weekDay: String = dateFormatter.stringFromDate(NSDate())
        //dayOfWeek.text = weekDay
        var e: NSError?
        let filePath = NSBundle.mainBundle().pathForResource("day", ofType: "json")
        var da: NSData = NSData(contentsOfFile: filePath!, options: nil, error: &e)!
        var days = NSJSONSerialization.JSONObjectWithData(da, options: nil, error: &e) as NSDictionary
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var todayText = dateFormatter.stringFromDate(NSDate())
        var whichDay = days.objectForKey(todayText) as String?
        if (whichDay == nil || whichDay == "") {
            whichDay = "HOLIDAY"
        }
        todayDay.text = whichDay!.uppercaseString
        //todayText = dateFormatter.stringFromDate(NSDate(timeIntervalSinceNow: 86400))
        //whichDay = days.objectForKey(todayText) as String?
        //if (whichDay == nil || whichDay == "") {
        //    whichDay = "HOLIDAY"
        //}
        //tmrDay.text = "tmr is \(whichDay!)"
    }
    
    func updateWeather(alarm: Bool) {
        var e: NSError?
        let url: NSURL = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=Hongkong")!
        let request: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error == nil {
                let json = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &e) as NSDictionary
                let wea = json.objectForKey("weather") as NSArray
                let weaa = wea[0] as NSDictionary
                self.weather.text = weaa.objectForKey("main") as? String
                
                let main = json.objectForKey("main") as NSDictionary
                let lowt = main.objectForKey("temp_min") as Double
                let hight = main.objectForKey("temp_max") as Double
                var flowt = Double(Int((lowt - 273.15)*10 + 0.5))
                var fhight = Double(Int((hight - 273.15)*10 + 0.5))
                flowt /= 10
                fhight /= 10
                self.temperature.text = "\(flowt)-\(fhight)°C"
                if alarm {
                    var alert = UIAlertController(title: "Updated", message: "The info is up to date.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                var alert = UIAlertController(title: "Error", message: "Failed to update weather.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func pressFacebook(AnyObject) {
        let url = NSURL(string: "fb://profile/942174419132692")
        if (UIApplication.sharedApplication().canOpenURL(url!)) {
            UIApplication.sharedApplication().openURL(url!)
        } else {
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/pages/Pathion-SPCC-2014-2015-Student-Union-Candidate-Cabinet/942174419132692")!)
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        updateInfo()
        updateWeather(true)
    }
}

