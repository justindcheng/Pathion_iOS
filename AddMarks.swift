//
//  AddMarks.swift
//  Pathion
//
//  Created by justin cheng on 20/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

class AddMarks: UIViewController, UITextFieldDelegate {

    @IBOutlet var subjectField: UITextField!
    @IBOutlet var markField: UITextField!
    @IBOutlet var fullField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addMarks(sender: AnyObject) {
        let ssub = subjectField.text
        let smark = markField.text
        let sfull = fullField.text
        let mark: Int? = smark.toInt()
        let full: Int? = sfull.toInt()
        if (mark != nil && full != nil && mark > full) {
            var alert = UIAlertController(title: "Nice Try", message: "Now try again.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        } else {
            if (ssub != "" && smark != nil && full != nil) {
                theMarks.addMark(ssub, mark: mark!, full: full!)
                subjectField!.text = ""
                markField!.text = ""
                fullField!.text = ""
                var alert = UIAlertController(title: "Saved", message: "\(ssub) : \(smark)/\(sfull) has been saved.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                var alert = UIAlertController(title: "Error", message: "Please fill in the fields.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }

    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }

}
