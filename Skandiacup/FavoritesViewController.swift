//
//  FavoritesViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var favoriteTableView: UITableView!
    let defaults = NSUserDefaults.standardUserDefaults()
    var favorites: [TournamentTeam]? = []
    var matchesDict: [String:[TournamentMatch]] = [String:[TournamentMatch]]()
    @IBOutlet weak var favoriteMatchCell: UILabel!
    @IBOutlet weak var notYetFavView: UIView!
    @IBOutlet weak var favoriteHeaderCell: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favorites = getFavoritedTeams()
        
        favorites?.forEach({ (team) -> () in
            SharingManager.data.getMatches(nil, groupID: nil, teamID: team.id, endplay: nil, completionHandler: { (matches, error) -> () in
                if error {
                    print("Error getting matches")
                    // needs to be handled properly
                } else {
                    self.matchesDict[team.name!] = matches
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.favoriteTableView.reloadData()
                    })
                }
            })
        })
    }
    
    
    override func viewDidAppear(animated: Bool) {
        favorites = getFavoritedTeams()
        favorites?.forEach({ (team) -> () in
            SharingManager.data.getMatches(nil, groupID: nil, teamID: team.id, endplay: nil, completionHandler: { (matches, error) -> () in
                if error {
                    print("Error getting matches")
                    // needs to be handled properly
                } else {
                    self.matchesDict[team.name!] = matches
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.favoriteTableView.reloadData()
                    })
                }
            })
        })
        
        
        favoriteTableView.reloadData()
        if (favorites == nil){
            self.favoriteTableView.hidden = true
            self.notYetFavView.hidden=false
        } else {
            self.favoriteTableView.hidden = false
            self.notYetFavView.hidden=true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            //header in each section 
            let cell = tableView.dequeueReusableCellWithIdentifier("favoriteHeaderCell") as! CustomHeaderCell!
            cell.headerLabel?.text = ("\(favorites![indexPath.section].name!)")
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteMatchCell") as UITableViewCell!
        
        if let match = matchesDict[favorites![indexPath.section].name!]?[indexPath.row-1]{
            if match.homegoal != nil{
                cell.textLabel?.text = "\(match.homeTeamName!) \(match.homegoal!)  - \(match.awaygoal!) \(match.awayTeamName!) "
            }else{
                cell.textLabel?.text = "\(match.homeTeamName!) - \(match.awayTeamName!) "
            }
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favorites != nil{
            let currentTeam = favorites![section]
            
            if matchesDict[currentTeam.name!] != nil{
                return matchesDict[currentTeam.name!]!.count + 1
            }
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if favorites != nil{
            return (favorites?.count)!
        }
        return 0
    }
    
    func getFavoritedTeams() -> [TournamentTeam]?{
        var teams = [TournamentTeam]()
        let dataRecieved = defaults.objectForKey("favorites") as? NSData
        var tempFav : FavoriteTeams?
        if dataRecieved != nil{
            tempFav = NSKeyedUnarchiver.unarchiveObjectWithData(dataRecieved!) as? FavoriteTeams
        }
        if (tempFav != nil) {
            if (tempFav!.favorites.count > 0) {
                for index in 0...tempFav!.favorites.count-1{
                    let convert = (tempFav!.favorites[index] as! NSObject) as! TournamentTeam
                    teams.append(convert)
                }
                return teams
            }
        }
        return nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "favoriteToMatchSegue") {
            if let indexPath = self.favoriteTableView.indexPathForSelectedRow{
                    let selectedMatch = matchesDict[favorites![indexPath.section].name!]![indexPath.row-1]
                    (segue.destinationViewController as! MatchViewController).selectedMatch = selectedMatch
            }
        }
        
        if (segue.identifier == "favoriteToTeamSegue") {
            if let indexPath = self.favoriteTableView.indexPathForSelectedRow{
                let selectedTeam = favorites![indexPath.section]
                (segue.destinationViewController as! TeamViewController).currentTeam = selectedTeam
            }
        }
    }
}