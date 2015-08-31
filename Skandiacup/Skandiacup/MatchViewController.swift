//
//  SecondViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var ds = Datasource2()
   

    @IBAction func indexChanged(sender: AnyObject) {
        tableView.dataSource = ds
        tableView.reloadData()
//        switch segmentControl.selectedSegmentIndex{
//        case 0:
//            tableView.dataSource = self
//            NSLog("Popular selected")
//            //show popular view
//        case 1:
//            tableView.dataSource = ds
//            NSLog("History selected")
//            //show history view
//        default:
//            break;
//        }

    }
    var classes = ["J19", "G18", "G20"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //datasource funcitons
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell{
//        let cell = UITableViewCell()
//        let label = UILabel(frame: CGRect(x:0, y:0, width:200, height:50))
//        label.text = classes[indexPath.row]
//        cell.addSubview(label)
        let cell = tableView.dequeueReusableCellWithIdentifier("classCell") as UITableViewCell!
        cell.textLabel?.text = classes[indexPath.row]
        return cell
    }
    
    
    // UITableViewDelegate Functions
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}

