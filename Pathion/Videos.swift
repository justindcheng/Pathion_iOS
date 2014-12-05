//
//  Videos.swift
//  Pathion
//
//  Created by justin cheng on 20/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit
import MediaPlayer

class Videos: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var videos: NSArray? = NSArray()
    var imgcache = [String: NSData]()
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let prefs = NSUserDefaults.standardUserDefaults()
        videos = prefs.objectForKey("videos") as? NSArray
        if (videos == nil) {
            videos = NSArray()
        }
        fetchList(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchList(alarm: Bool) {
        let url = NSURL(string: "https://www.dropbox.com/s/onqjkb745z32rhp/videos.json?dl=1")!
        let request: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error == nil {
                var e: NSError?
                self.videos = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &e) as? NSArray
                var prefs = NSUserDefaults.standardUserDefaults()
                prefs.setObject(self.videos!, forKey: "videos")
                prefs.synchronize()
                self.reload()
                if alarm {
                    var alert = UIAlertController(title: "Updated", message: "The videos are up to date.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                var alert = UIAlertController(title: "Error", message: "Failed to update videos.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("VideoCell", forIndexPath: indexPath) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "VideoCell")
        }
        let dict = videos!.objectAtIndex(indexPath.row) as NSDictionary
        let prefs = NSUserDefaults.standardUserDefaults()
        let data = imgcache[String(format: "video%02d", indexPath.row)]
        if ((data) != nil) {
            let img = UIImage(data: data!)! as UIImage
            cell!.imageView.image = img
        } else {
            var imgURL: NSURL = NSURL(string: dict.objectForKey("image") as String)!
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    self.imgcache[String(format: "video%02d", indexPath.row)] = data
                    tableView.reloadData()
                }
            })
        }
        cell!.textLabel.text = (dict.objectForKey("title") as String)
        cell!.detailTextLabel?.text = (dict.objectForKey("caption") as String)
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dict = videos!.objectAtIndex(indexPath.row) as NSDictionary
        let urlstr = dict.objectForKey("url") as String
        UIApplication.sharedApplication().openURL(NSURL(string: urlstr)!)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func reload() {
        table.reloadData()
    }
    
    @IBAction func refresh() {
        fetchList(true)
    }

}
