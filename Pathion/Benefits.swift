//
//  SecondViewController.swift
//  Pathion
//
//  Created by justin cheng on 20/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

class Benefits: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var shops: NSDictionary?
    var keys: NSArray?
    @IBOutlet var table: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let prefs = NSUserDefaults.standardUserDefaults()
        shops = prefs.objectForKey("benefits") as? NSDictionary
        if (shops == nil) {
            shops = NSDictionary()
        }
        keys = shops!.allKeys
        fetchShops(false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchShops(alarm: Bool) {
        let url = NSURL(string: "https://www.dropbox.com/s/5vqwuoo5cyvm3yg/benefits.json?dl=1")!
        var e: NSError?
        let request: NSURLRequest = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error == nil {
                var e: NSError?
                self.shops = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &e) as? NSDictionary
                var prefs = NSUserDefaults.standardUserDefaults()
                prefs.setObject(self.shops, forKey: "benefits")
                prefs.synchronize()
                self.keys = self.shops!.allKeys
                self.table.reloadData()
                if alarm {
                    var alert = UIAlertController(title: "Updated", message: "The shops are up to date.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                var alert = UIAlertController(title: "Error", message: "Failed to download metadata.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return keys!.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shops!.objectForKey(keys!.objectAtIndex(section))!.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (keys!.objectAtIndex(section) as String)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("BenefitsCell", forIndexPath: indexPath) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "BenefitsCell")
        }
        let shopDict = getShop(indexPath)
        cell!.textLabel.text = shopDict.objectForKey("name") as? String
        let detail = shopDict.objectForKey("detail") as? String
        let tel = shopDict.objectForKey("tel") as? String
        let address = shopDict.objectForKey("address") as? String
        var desc = ""
        var count = 0
        if (tel != nil) {
            desc = "\(tel!)\n"
            count++
        }
        if (address != nil) {
            desc = desc + "\(address!)\n"
            count++
        }
        if (detail != nil) {
            desc = desc + "\(detail!)"
            count++
        }
        cell!.detailTextLabel!.text = desc
        cell!.detailTextLabel!.numberOfLines = count
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let shop = getShop(indexPath)
        let name = shop.objectForKey("name") as String
        var tel: String? = shop.objectForKey("tel") as String?
        if (tel != nil && tel! != "") {
            let url = NSURL(string: "tel:\(tel!)")
            var alert = UIAlertController(title: "\(name)", message: "call \(tel!)?", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Call", style: .Default, handler: { action in
                switch action.style{
                case .Default:
                    let shop = self.getShop(indexPath)
                    let tel = shop.objectForKey("tel") as String
                    let url = NSURL(string: "tel:\(tel)")
                    if (url != nil) {
                        UIApplication.sharedApplication().openURL(url!)
                    }
                case .Cancel:
                    break
                case .Destructive:
                    break
                }
            }))
            alert.addAction(UIAlertAction(title: "Dismiss", style: .Cancel, handler: { action in
                switch action.style{
                case .Default:
                    break
                case .Cancel:
                    break
                case .Destructive:
                    break
                }
            }))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func getShop(indexPath: NSIndexPath) -> NSDictionary {
        let ary = shops!.objectForKey(keys!.objectAtIndex(indexPath.section))! as NSArray
        let shopDict: NSDictionary = ary.objectAtIndex(indexPath.row) as NSDictionary
        return shopDict
    }
    
    @IBAction func refresh() {
        fetchShops(true)
    }
}

