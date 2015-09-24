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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        favorites = getFavoritedTeams()
    }
    
    override func viewDidAppear(animated: Bool) {
        favorites = getFavoritedTeams()
        favoriteTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteCell") as UITableViewCell!
            cell.textLabel?.text = favorites?[indexPath.row].name! ?? "Ingen lag er lagt til som favoritter enda"
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites?.count ?? 1
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
        if (segue.identifier == "favoritesToTeamView") {
            if let indexPath = self.favoriteTableView.indexPathForSelectedRow{
                    let selectedTeam = favorites![indexPath.row]
                    (segue.destinationViewController as! TeamViewController).currentTeam = selectedTeam
                }
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

