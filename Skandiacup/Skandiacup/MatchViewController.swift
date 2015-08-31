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
    
    @IBAction func indexChanged(sender: AnyObject) {
        current = teams;
//        let ds = Datasource2()
//        tableView.dataSource = ds
        tableView.reloadData()
    }
//    var ds = Datasource2()
//    var ds : Datasource2!
//    var ds : TableDataSource!
    var current : [String]!
    var classes = ["J19", "G18", "G20"]
    var teams = ["lag1", "lag2"]
    
   override func viewDidLoad() {
        super.viewDidLoad()
        current = classes
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
        return current.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell{
//        let cell = UITableViewCell()
//        let label = UILabel(frame: CGRect(x:0, y:0, width:200, height:50))
//        label.text = classes[indexPath.row]
//        cell.addSubview(label)
        let cell = tableView.dequeueReusableCellWithIdentifier("classCell") as UITableViewCell!
        cell.textLabel?.text = current[indexPath.row]
        return cell
    }
    
    
    // UITableViewDelegate Functions
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}

