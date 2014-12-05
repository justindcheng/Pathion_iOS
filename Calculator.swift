//
//  Calculator.swift
//  Pathion
//
//  Created by justin cheng on 20/9/14.
//  Copyright (c) 2014 One Mistakes. All rights reserved.
//

import UIKit

class Calculator: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var stats: UILabel!
    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        table.reloadData()
    }
    
    func updateStats() {
        let avg = theMarks.getAvg()
        let totalMarks = theMarks.getTotalMarks()
        let totalFull = theMarks.getTotalFull()
        stats.text = "Total: \(totalMarks)/\(totalFull)   Average: \(avg)%"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateStats()
        return theMarks.count()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("MarkCell", forIndexPath: indexPath) as? UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "MarkCell")
        }
        let sub = theMarks.getMark(indexPath.row)
        cell!.textLabel.text = sub.objectForKey("subject") as? String
        let marks: Int? = sub.objectForKey("mark") as Int?
        let full: Int? = sub.objectForKey("full") as Int?
        cell!.detailTextLabel?.text = "\(marks!)/\(full!)"
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            theMarks.removeMark(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            updateStats()
        }
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
}
