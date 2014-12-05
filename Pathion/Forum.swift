//
//  Forum.swift
//  Pathion
//
//  Created by justin cheng on 2/10/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

class Forum: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var forumTable: UITableView!
    var allPosts = NSMutableArray()
    var objects = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var prefs = NSUserDefaults.standardUserDefaults()
        if (prefs.objectForKey("chatname") == nil || prefs.objectForKey("chatname") as String == "") {
            prefs.setObject("student", forKey: "chatname")
            prefs.synchronize()
        }
        
        loadPosts()
        loadTrolls()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("ForumCell", forIndexPath: indexPath) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "ForumCell")
        }
        cell!.textLabel.text = allPosts.objectAtIndex(indexPath.row).objectForKey("PostName") as? String
        cell!.textLabel.numberOfLines = 0
        return cell!
    }
    
    func loadPosts() {
        var query = PFQuery(className: "posts")
        query.orderByAscending("PostNumber")
        if allPosts.count == 0 {
            query.findObjectsInBackgroundWithTarget(self, selector: "loadedPosts:")
        }
    }
    
    func loadedPosts(Objects: [PFObject]) {
        objects = Objects
        for object: PFObject in objects as [PFObject] {
            allPosts.addObject(object)
        }
        forumTable.reloadData()
    }
    
    func loadTrolls() {
        var query = PFQuery(className: "blocked")
        query.whereKey("UID", equalTo: UIDevice.currentDevice().identifierForVendor.UUIDString)
        query.findObjectsInBackgroundWithTarget(self, selector: "loadedTrolls:")
    }
    
    func loadedTrolls(Objects: [PFObject]) {
        var prefs = NSUserDefaults.standardUserDefaults()
        if Objects.count > 0 {
            prefs.setInteger(1, forKey: "blocked")
            var alert = UIAlertController(title: "Sorry", message: "You are not allowed to comment, but you can still read the posts.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)

        } else {
            prefs.setInteger(0, forKey: "blocked")
        }
        prefs.synchronize()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        var vc = storyboard.instantiateViewControllerWithIdentifier("ChatRoom") as ChatRoom
        vc.postNumber = CInt(indexPath.row)
        vc.className = allPosts.objectAtIndex(indexPath.row).objectForKey("PostName") as? String
        self.navigationController?.showViewController(vc, sender: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
    }

}
