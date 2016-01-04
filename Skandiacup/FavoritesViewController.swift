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
    var matchClasses: [MatchClass]?
    @IBOutlet weak var favoriteMatchCell: UILabel!
    @IBOutlet weak var notYetFavView: UIView!
    var isLoaded: Bool = false
    @IBOutlet weak var actInd: UIActivityIndicatorView!
    @IBOutlet weak var favoriteHeaderCell: UILabel!
    var matchesLoaded: [String: Bool] = [String: Bool]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favorites = getFavoritedTeams()
        favoriteTableView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        self.notYetFavView.hidden=true
        
        SharingManager.data.getMatchClass { (matchclasses, error) -> () in
            if error{
                print("Error getting matches")
                let alertController = UIAlertController(title: "Error", message:
                    "Data not available at this moment", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            }else{
                self.matchClasses = matchclasses
            }
        }
    }
    
    
    override func viewDidAppear(animated: Bool) {
        favorites = getFavoritedTeams()
        favorites?.forEach({ (team) -> () in
            matchesLoaded[String(team.id!)] = false
            SharingManager.data.getMatches(nil, groupID: team.matchGroupId, teamID: team.id, endplay: nil, completionHandler: { (matches, error) -> () in
                if error {
                    print("Error getting matches")
                    let alertController = UIAlertController(title: "Error", message:
                        "Match data not available atm", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                    // needs to be handled properly
                } else {
                    self.matchesDict[String(team.id!)] = matches
                    self.matchesLoaded[String(team.id!)] = true
                    if(self.favorites!.count == self.matchesLoaded.count ){
                        self.reloadTableIfAllMatchesAreLoaded()
                    }
                }
            })
        })

        if (favorites == nil){
            self.favoriteTableView.hidden = true
            self.notYetFavView.hidden=false
        } else {
            if(!isLoaded){
                favoriteTableView.hidden = true
                actInd.startAnimating()
            }
        }
    }
    
    func reloadTableIfAllMatchesAreLoaded(){
        if allMatchesAreLoaded(){
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.actInd.stopAnimating()
                self.isLoaded = true
                self.favoriteTableView.hidden = false
                self.favoriteTableView.reloadData()
            })
        }
    }
    
    func allMatchesAreLoaded() -> Bool {
        if favorites != nil {
            for team in self.favorites!{
                if !matchesLoaded[String(team.id!)]! {
                    return false
                }
            }
            return true
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            //header in each section
            let cell = tableView.dequeueReusableCellWithIdentifier("favoriteHeaderCell") as! CustomHeaderCell!
            var cellText = favorites![indexPath.section].name!
            matchClasses?.forEach({ (mc) -> () in
                if(mc.id! == favorites![indexPath.section].matchClassId!){
                    mc.matchGroups?.forEach({ (mg) -> () in
                        if(mg.id == favorites![indexPath.section].matchGroupId){
                            cellText = cellText + " - \(SharingManager.locale.teamCellClass) \(mc.code!) - \(SharingManager.locale.teamCellGroup) \(mg.name!)"
                        }
                    })
                }
            })
            cell.headerLabel?.text = cellText
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteMatchCell") as UITableViewCell!
        
        if let match = matchesDict[String(favorites![indexPath.section].id!)]?[indexPath.row-1]{
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
            
            if matchesDict[String(currentTeam.id!)] != nil{
                return matchesDict[String(currentTeam.id!)]!.count + 1
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
                let selectedMatch = matchesDict[String(favorites![indexPath.section].id!)]![indexPath.row-1]
                (segue.destinationViewController as! MatchViewController).selectedMatch = selectedMatch
            }
        }
        
        if (segue.identifier == "favoriteToTeamSegue") {
            if let indexPath = self.favoriteTableView.indexPathForSelectedRow{
                let selectedTeam = favorites![indexPath.section]
                (segue.destinationViewController as! TeamViewController).currentTeam = selectedTeam
                matchClasses?.forEach({ (mc) -> () in
                    if(mc.id! == selectedTeam.matchClassId!){
                        mc.matchGroups?.forEach({ (mg) -> () in
                            if(mg.id == selectedTeam.matchGroupId){
                                (segue.destinationViewController as! TeamViewController).currentMatchClass = mc
                                (segue.destinationViewController as! TeamViewController).currentMatchGroup = mg
                            }
                        })
                    }
                })
            }
        }
    }
}