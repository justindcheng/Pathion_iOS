//
//  SetName.swift
//  Pathion
//
//  Created by justin cheng on 2/10/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

class SetName: UIViewController, UITextFieldDelegate {

    @IBOutlet var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var prefs = NSUserDefaults.standardUserDefaults()
        if (prefs.objectForKey("chatname") != nil &&
            prefs.objectForKey("chatname") as String != "") {
                nameField.text = prefs.objectForKey("chatname") as String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        var prefs = NSUserDefaults.standardUserDefaults()
        if (textField.text == "") {
            prefs.setObject("student", forKey: "chatname")
        } else {
            prefs.setObject(textField.text, forKey: "chatname")
        }
        prefs.synchronize()
        textField.resignFirstResponder()
        return true
    }

}
