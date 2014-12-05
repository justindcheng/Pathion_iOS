//
//  EventList.swift
//  Pathion
//
//  Created by justin cheng on 28/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

class EventList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var events: NSArray?
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let prefs = NSUserDefaults.standardUserDefaults()
        events = prefs.objectForKey("eventlist") as? NSArray
        if events == nil {
            events = NSArray()
        }
        downloadList()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func downloadList() {
        let url = NSURL(string: "https://www.dropbox.com/s/hr932j39u05gucp/events.json?dl=1")
        let request: NSURLRequest = NSURLRequest(URL: url!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error == nil {
                var e: NSError?
                self.events = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &e) as? NSArray
                var prefs = NSUserDefaults.standardUserDefaults()
                prefs.setObject(self.events, forKey: "eventlist")
                prefs.synchronize()
                self.table.reloadData()
                var alert = UIAlertController(title: "Updated", message: "The info is up to date.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                var alert = UIAlertController(title: "Error", message: "Failed to update.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func refresh() {
        downloadList()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "EventCell")
        }
        let dict = events!.objectAtIndex(indexPath.row) as NSDictionary
        cell!.textLabel.text = (dict.objectForKey("name") as String)
        cell!.detailTextLabel!.text = (dict.objectForKey("caption") as String)
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var board = UIStoryboard(name: "Main", bundle: nil)
        var eventPage = board.instantiateViewControllerWithIdentifier("Event") as Event?
        let dict = events!.objectAtIndex(indexPath.row) as NSDictionary
        eventPage!.name = (dict.objectForKey("name") as String)
        eventPage!.txt = (dict.objectForKey("url") as String)
        eventPage!.img = (dict.objectForKey("image") as String)
        eventPage!.setContent()
        self.navigationController?.pushViewController(eventPage!, animated: true)
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
