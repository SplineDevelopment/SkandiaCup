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
    
    var endPlayMatchClasses: [MatchClass]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadMatchClassses()
    }
    
    func loadMatchClassses(){
        SharingManager.data.getMatchClass { (matchclasses, error) -> () in
            if error {
                print("error getting match classes")
                // needs to be handled properly
            } else {
                self.endPlayMatchClasses = matchclasses
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.endPlayMatchClassTable.reloadData()
                })
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endPlayMatchClasses != nil ? endPlayMatchClasses!.count : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "MatchClassTable"
        //let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MealTableViewCell
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        
        // Fetches the appropriate meal for the data source layout.
        //let meal = meals[indexPath.row]
        
        let textValue = endPlayMatchClasses?[indexPath.row].name
        
        cell.textLabel?.text = textValue
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "fromEndPlayMatchClassToEndPlayMatches") {
            if let indexPath = self.endPlayMatchClassTable.indexPathForSelectedRow{
                let selectedEndPlayMatchClass = endPlayMatchClasses?[indexPath.row]
                (segue.destinationViewController as! EndPlayGamesViewController).selectedMatchClass = selectedEndPlayMatchClass
            }
        }
    }





}

