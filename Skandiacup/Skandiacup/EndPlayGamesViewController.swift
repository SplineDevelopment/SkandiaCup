//
//  EndPlayViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 25/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class EndPlayGamesViewController: UITableViewController{
    var selectedMatchClass = ""
    @IBOutlet var endPlayGamesTable: UITableView!
    
    var endPlayMatchesInMatchClass = ["Kamp1", "Kamp2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("EndPlayGamesViewControllerstart")

        loadMatchClassGames()
        
    }
    
    
    func loadMatchClassGames(){
        print(selectedMatchClass)
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endPlayMatchesInMatchClass.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "endPlayMatchesInMatchClass"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        
        let textValue = endPlayMatchesInMatchClass[indexPath.row]
        
        cell.textLabel?.text = textValue
        
        return cell
    }
    
    



}

