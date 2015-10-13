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
    
    @IBOutlet weak var favoriteHeaderCell: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favorites = getFavoritedTeams()
        
        favorites?.forEach({ (team) -> () in
            SharingManager.data.getMatches(nil, groupID: nil, teamID: team.id, completionHandler: { (matches) -> () in
                self.matchesDict[team.name!] = matches
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.favoriteTableView.reloadData()
                })
            })
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        favorites = getFavoritedTeams()
        
        favorites?.forEach({ (team) -> () in
            SharingManager.data.getMatches(nil, groupID: nil, teamID: team.id, completionHandler: { (matches) -> () in
                self.matchesDict[team.name!] = matches
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.favoriteTableView.reloadData()
                })
            })
        })
        
        
        favoriteTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteHeaderCell") as! CustomHeaderCell!
//        cell.headerLabel.text = ("\(favorites![section].name!)")
//        return cell
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            //header in each section 
            let cell = tableView.dequeueReusableCellWithIdentifier("favoriteHeaderCell") as! CustomHeaderCell!
            cell.headerLabel?.text = ("\(favorites![indexPath.section].name!)")
//            cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 25)
//            cell.textLabel?.textAlignment = .Center
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteMatchCell") as UITableViewCell!
        
        cell.textLabel?.text = "\(matchesDict[favorites![indexPath.section].name!]![indexPath.row-1].homeTeamName!) \(matchesDict[favorites![indexPath.section].name!]![indexPath.row-1].homegoal!)  - \(matchesDict[favorites![indexPath.section].name!]![indexPath.row-1].awaygoal!) \(matchesDict[favorites![indexPath.section].name!]![indexPath.row-1].awayTeamName!) "
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favorites != nil{
            print("SECTION IS \(section) LENGTH IS f\(favorites?.count)")
            
            let currentTeam = favorites![section]
            print("CURRENT TEAM IS \(currentTeam.name)")
            
            if matchesDict[currentTeam.name!] != nil{
                return matchesDict[currentTeam.name!]!.count + 1
            }
        }
        print("Returning 0 ")
        return 0
//        return favorites?.count ?? 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if favorites != nil{
            print("numberofsect \(favorites?.count)")
            return (favorites?.count)!
        }
        print("returning 0 sections")
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}