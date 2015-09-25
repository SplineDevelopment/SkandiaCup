//
//  EndPlayViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 25/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class EndPlayViewController: UITableViewController{
    
    @IBOutlet var endPlayMatchClassTable: UITableView!
    var endPlayMatchClasses = ["Gutter 12", "Jenter 12"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMatchClassses()


    }
    
    
    func loadMatchClassses(){
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endPlayMatchClasses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MatchClassTable"
        //let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        
        // Fetches the appropriate meal for the data source layout.
        //let meal = meals[indexPath.row]
        
        let textValue = endPlayMatchClasses[indexPath.row]
        
        cell.textLabel?.text = textValue
        
        return cell
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "fromEndPlayMatchClassToEndPlayMatches") {
            if let indexPath = self.endPlayMatchClassTable.indexPathForSelectedRow{
                let selectedEndPlayMatchClass = endPlayMatchClasses[indexPath.row]
                (segue.destinationViewController as! EndPlayGamesViewController).selectedMatchClass = selectedEndPlayMatchClass
            }
        }
    }





}

