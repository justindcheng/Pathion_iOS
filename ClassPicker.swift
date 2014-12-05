//
//  ClassPicker.swift
//  Pathion
//
//  Created by justin cheng on 20/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

class ClassPicker: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    
    @IBOutlet var classPick: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        classPick.selectRow(theClassMgr.cls, inComponent: 0, animated: false)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return theClassMgr.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var viewControllers = self.navigationController!.viewControllers as NSArray
        var count = viewControllers.count
        var previousController = viewControllers.objectAtIndex(count-2) as Timetable
        previousController.update(row)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return theClassMgr.className(row)
    }
}
