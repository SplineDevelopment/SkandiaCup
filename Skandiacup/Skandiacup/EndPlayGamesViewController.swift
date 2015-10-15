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
    var matchHeaders: [String: String] = ["1.0000": "Finale", "2.0000": "Semifinaler", "4.0000": "Kvartfinaler", "8.0000": "Åttendedelsfinaler", "16.0000": "Sekstensdelsfinaler", "32.0000": "32-delsfinale", "64.0000": "64-delsfinale"]
    
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
        cell.headerLabel.text = matchHeaders[sortedKeys[section]]
        return cell
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "endPlayMatchesInMatchClass"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        if let match = endPlayMatchesInMatchClass[sortedKeys[indexPath.section]]?[indexPath.row]{
            if match.homegoal != nil{
                cell.textLabel?.text = "\(match.homeTeamName!) \(match.homegoal!)  - \(match.awaygoal!) \(match.awayTeamName!) "
            }else{
                cell.textLabel?.text = "Kamp \(match.matchno!): \(match.homeTeamText!) - \(match.awayTeamText!) "
            }
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
}

