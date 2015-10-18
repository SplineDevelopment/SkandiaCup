//
//  EndPlayViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 25/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class EndPlayGamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    var selectedMatchClass: MatchClass?
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var endPlayGamesTable: UITableView!
    

    var endPlayMatchesInMatchClass: [String: [TournamentMatch]] = [String: [TournamentMatch]]()
    var sortedKeys: [String] = [String]()
    var matchHeaders: [String: String] = ["1.0000": "Finale", "2.0000": "Semifinaler", "4.0000": "Kvartfinaler", "8.0000": "Åttendedelsfinaler", "16.0000": "Sekstensdelsfinaler", "32.0000": "32-delsfinale", "64.0000": "64-delsfinale"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.endPlayGamesTable.delegate = self
        self.endPlayGamesTable.dataSource = self
//        self.endPlayGamesTable.tableHeaderView?.layer.frame.size.height = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        if segmentControl.selectedSegmentIndex == 0 {
            self.loadMatchClassGames(1)
        }
        if segmentControl.selectedSegmentIndex == 1 {
            self.loadMatchClassGames(2)
        }
        self.endPlayGamesTable.tableHeaderView = UIView()
    }
    
    
    @IBAction func segmentChanged(sender: AnyObject) {
        if segmentControl.selectedSegmentIndex == 0 {
            self.loadMatchClassGames(1)
        }
        if segmentControl.selectedSegmentIndex == 1 {
            self.loadMatchClassGames(2)
        }
    }
    
    func loadMatchClassGames(endplay: Int){
        self.endPlayMatchesInMatchClass = [String: [TournamentMatch]]()
        SharingManager.data.getMatches(self.selectedMatchClass!.id, groupID: nil, teamID: nil, endplay: endplay) { (matches, error) -> () in
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
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.endPlayGamesTable.reloadData()
                })
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sortedKeys.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if endPlayMatchesInMatchClass[sortedKeys[section]] != nil{
            return endPlayMatchesInMatchClass[sortedKeys[section]]!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("headerCell") as! CustomHeaderCell!
        cell.headerLabel.text = matchHeaders[sortedKeys[section]]
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "endPlayMatchesInMatchClass"
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as! matchCellView
        if let match = endPlayMatchesInMatchClass[sortedKeys[indexPath.section]]?[indexPath.row]{
            if match.homegoal != nil{
                
               /*
                * Use the following lines of code if the endplaymatches are NOT properly populated with teamnames. getMatchTeamNames
                * calculates which team ID won/lost each game.
                */
                
                
                if match.sortOrder != sortedKeys.last{
                    //We need to calculate match winners
                    let playedMatch = getMatchTeamNames(match)
                    endPlayMatchesInMatchClass[sortedKeys[indexPath.section]]![indexPath.row].homeTeamName = playedMatch.homeTeamName
                    endPlayMatchesInMatchClass[sortedKeys[indexPath.section]]![indexPath.row].awayTeamName = playedMatch.awayTeamName
                    cell.homeTeamNameLabel.text = playedMatch.homeTeamName!
                    cell.awayTeamNameLabel.text = playedMatch.awayTeamName!
                } else {
                    //MatchWinners are already in the match
                    cell.homeTeamNameLabel.text = match.homeTeamName!
                    cell.awayTeamNameLabel.text = match.awayTeamName!
                }
                cell.homeTeamGoalLabel.text = match.homegoal!
                cell.awayTeamGoalLabel.text = match.awaygoal!
                cell.fieldNameLabel.text = String(match.fieldId!)
                cell.classNameLabel.text = String(match.classId!)
                cell.dateLabel.text = "\(Date.getDateMatchView(match.matchDate!)) \(Date.getKickoffTimeMatchView(match.matchDate!)) "

                
                /*
                 * The following lines are for when the endplaymatches ARE properly populated with teamnames.
                 * Comment these lines, and uncomment the above snippet if they are not.
                 */
                /*
                cell.homeTeamNameLabel.text = match.homeTeamName!
                cell.awayTeamNameLabel.text = match.awayTeamName!
                cell.homeTeamGoalLabel.text = match.homegoal!
                cell.awayTeamGoalLabel.text = match.awaygoal!
                cell.fieldNameLabel.text = String(match.fieldId!)
                cell.classNameLabel.text = String(match.classId!)
                cell.dateLabel.text = "\(Date.getDateMatchView(match.matchDate!)) \(Date.getKickoffTimeMatchView(match.matchDate!)) "
                
                */
                //Bold text for the match winner 
                if match.winner == "H" {
                    cell.homeTeamNameLabel.font = UIFont.boldSystemFontOfSize(17.0)
                } else if match.winner == "B" {
                    cell.awayTeamNameLabel.font = UIFont.boldSystemFontOfSize(17.0)
                }
            }else{
                cell.textLabel?.text = "Kamp \(match.matchno!): \(match.homeTeamText!) - \(match.awayTeamText!) "
            }
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func getWinnerFromMatch(match: TournamentMatch) -> String{
        let team1 = match.homeTeamName
        let team2 = match.awayTeamName
        
        if team1 == "Unknown" && team2 == "Unknown"{
            let id1 = match.homeTeamText!.characters.split{$0 == " "}.map(String.init)[1]
            let id2 = match.awayTeamText!.characters.split{$0 == " "}.map(String.init)[1]
            let winnerFromMatch = match.winner == "H" ? id1 : id2
            
            for endplaymatch in endPlayMatchesInMatchClass[sortedKeys[sortedKeys.indexOf(match.sortOrder!)!+1]]!{
                if endplaymatch.matchno == winnerFromMatch {
                    return getWinnerFromMatch(endplaymatch)
                }
            }
        } else {
            return (match.winner == "H" ? match.homeTeamName : match.awayTeamName)!
        }
        return ""
    }
    
    func getMatchTeamNames(match: TournamentMatch) -> TournamentMatch {
        var returnMatch = TournamentMatch()
        let matchWinner = getWinnerFromMatch(match)
        var matchLoser = ""
        
        var losermatch = TournamentMatch()
        
        let id1 = match.homeTeamText!.characters.split{$0 == " "}.map(String.init)[1]
        let id2 = match.awayTeamText!.characters.split{$0 == " "}.map(String.init)[1]
        
        let losermatchid = match.winner != "H" ? id1 : id2
        
        for endplaymatch in endPlayMatchesInMatchClass[sortedKeys[sortedKeys.indexOf(match.sortOrder!)!+1]]!{
            if losermatchid == String(endplaymatch.matchno!) {
                losermatch = endplaymatch
            }
        }
        
        matchLoser = losermatch.homeTeamName != nil ? getWinnerFromMatch(losermatch) : ""
        
        returnMatch.homeTeamName = match.winner == "H" ? matchWinner : matchLoser
        returnMatch.awayTeamName = match.winner != "H" ? matchWinner : matchLoser
        return returnMatch
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "endplayMatchToMatchView" {
            if let indexPath = self.endPlayGamesTable.indexPathForSelectedRow {
                if let match = endPlayMatchesInMatchClass[sortedKeys[indexPath.section]]?[indexPath.row] {
                    (segue.destinationViewController as! MatchViewController).selectedMatch = match
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Config.matchCellViewHeight
    }
}