//
//  EndPlayViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 25/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class EndPlayGamesViewController: UITableViewController{
    var selectedMatchClass: MatchClass?
    
    @IBOutlet var endPlayGamesTable: UITableView!
    
    var endPlayMatchesInMatchClass: [String: [TournamentMatch]] = [String: [TournamentMatch]]()
    var sortedKeys: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMatchClassGames()
    }
    
    func loadMatchClassGames(){
        SharingManager.data.getMatches(self.selectedMatchClass!.id, groupID: nil, teamID: nil, endplay: 1) { (matches, error) -> () in
            if error {
                print("error getting matches (endplay)")
                // needs to be handled properly
            }
            else {
                var counter = 0
                matches.forEach({ (match) -> () in
                    if self.endPlayMatchesInMatchClass[match.sortOrder!] != nil{
                        self.endPlayMatchesInMatchClass[match.sortOrder!]!.append(match)
                        counter = counter + 1
                    } else{
                        self.endPlayMatchesInMatchClass[match.sortOrder!] = [TournamentMatch]()
                        self.endPlayMatchesInMatchClass[match.sortOrder!]!.append(match)
                    }
                })
                self.sortedKeys = Array(self.endPlayMatchesInMatchClass.keys).sort({$0 < $1})
                self.endPlayGamesTable.reloadData()
            }
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sortedKeys.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if endPlayMatchesInMatchClass[sortedKeys[section]] != nil{
            return endPlayMatchesInMatchClass[sortedKeys[section]]!.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! CustomHeaderCell!
        cell.headerLabel.text = sortedKeys[section]
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "endPlayMatchesInMatchClass"

//        if indexPath.row == 0{
//            // header row
//            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
//            cell.textLabel?.text = "THIS IS A HEADER FOR MATCH \(sortedKeys[indexPath.section])"
//            return cell
//        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        if endPlayMatchesInMatchClass[sortedKeys[indexPath.section]] != nil{
            cell.textLabel?.text = "\(endPlayMatchesInMatchClass[sortedKeys[indexPath.section]]![indexPath.row].homeTeamName!) \(endPlayMatchesInMatchClass[sortedKeys[indexPath.section]]![indexPath.row].homegoal!)  - \(endPlayMatchesInMatchClass[sortedKeys[indexPath.section]]![indexPath.row].awaygoal!) \(endPlayMatchesInMatchClass[sortedKeys[indexPath.section]]![indexPath.row].awayTeamName!) "
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
}

