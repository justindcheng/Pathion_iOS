//
//  Event.swift
//  Pathion
//
//  Created by justin cheng on 20/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

class Event: UIViewController {

    @IBOutlet var poster: UIImageView!
    @IBOutlet var desc: UITextView!
    @IBOutlet var nav: UINavigationItem!
    
    var txt = String()
    var img = String()
    var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setContent() {
        nav!.title = name
        setText()
        setPoster()
    }
    
    func setText() {
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: txt)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error == nil {
                self.desc!.text = NSString(data: data, encoding: NSUTF8StringEncoding)
            } else {
                var alert = UIAlertController(title: "Error", message: "Failed to download content.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    func setPoster() {
        let request: NSURLRequest = NSURLRequest(URL: NSURL(string: img)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
            if error == nil {
                self.poster!.image = UIImage(data: data)
            } else {
                var alert = UIAlertController(title: "Error", message: "Failed to download image.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }

}
