//
//  TeamViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var matchTableView: UITableView!
    @IBOutlet weak var infoLabel: UILabel!
    let defaults = NSUserDefaults.standardUserDefaults()
    var favorites: FavoriteTeams = FavoriteTeams()
    @IBOutlet weak var favButton: UIBarButtonItem!
    
    var matches: [TournamentMatch]? {
        didSet{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.matchTableView.reloadData()
            })
        }
    }
    
    var currentTeam: TournamentTeam? {
        didSet {
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchTableView.delegate = self
        matchTableView.dataSource = self
        self.configureView()

        
        SharingManager.soap.getMatches(nil, groupID: nil, teamID: currentTeam?.id) { (matches) -> () in
            self.matches = matches
        }
        changeButton()
        // Do any additional setup after loading the view.
    }
    
    func favorite() {
        let dataRecieved = defaults.objectForKey("favorites") as? NSData
        var tempFav : FavoriteTeams?
        if dataRecieved != nil{
            tempFav = NSKeyedUnarchiver.unarchiveObjectWithData(dataRecieved!) as? FavoriteTeams
        }
        if tempFav == nil {
            let data = NSKeyedArchiver.archivedDataWithRootObject(favorites)
            defaults.setObject(data, forKey: "favorites")
            let dataRecieved = defaults.objectForKey("favorites") as? NSData
            tempFav = NSKeyedUnarchiver.unarchiveObjectWithData(dataRecieved!) as? FavoriteTeams
        }
        tempFav!.addFav(currentTeam!)
        // Prints out the faved teams in the code below
        let data2 = NSKeyedArchiver.archivedDataWithRootObject(tempFav!)
        defaults.setObject(data2, forKey: "favorites")
        let dataRecieved2 = defaults.objectForKey("favorites") as? NSData
        let name = NSKeyedUnarchiver.unarchiveObjectWithData(dataRecieved2!) as! FavoriteTeams
        for index in 0...name.favorites.count-1{
            print(name.favorites[index].name!)
        }
        changeButton()
    }
    
    
    func checkIfFaved(team: TournamentTeam) -> Bool{
        let dataRecieved = defaults.objectForKey("favorites") as? NSData
        var tempFav : FavoriteTeams?
        if dataRecieved != nil{
            tempFav = NSKeyedUnarchiver.unarchiveObjectWithData(dataRecieved!) as? FavoriteTeams
        }
        if (tempFav != nil) {
            if (tempFav!.favorites.count > 0) {
                for index in 0...tempFav!.favorites.count-1{
                    let convert = (tempFav!.favorites[index] as! NSObject) as! TournamentTeam
                    if (convert.name! == team.name!) {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    func unFavorite(){
        let dataRecieved = defaults.objectForKey("favorites") as? NSData
        var tempFav : FavoriteTeams?
        if dataRecieved != nil{
            tempFav = NSKeyedUnarchiver.unarchiveObjectWithData(dataRecieved!) as? FavoriteTeams
            if (checkIfFaved(currentTeam!) == true){
                if (tempFav!.favorites.count > 0) {
                    for index in 0...tempFav!.favorites.count-1{
                        let favoriteTeam = (tempFav!.favorites[index] as! NSObject) as! TournamentTeam
                        if (currentTeam!.name! == favoriteTeam.name!){
                            tempFav!.removeFav(index)
                            break
                        }
                    }
                }
                let data = NSKeyedArchiver.archivedDataWithRootObject(tempFav!)
                defaults.setObject(data, forKey: "favorites")
            }
            // prints out the new faved teams
            let data2 = NSKeyedArchiver.archivedDataWithRootObject(tempFav!)
            defaults.setObject(data2, forKey: "favorites")
            let dataRecieved2 = defaults.objectForKey("favorites") as? NSData
            let name = NSKeyedUnarchiver.unarchiveObjectWithData(dataRecieved2!) as! FavoriteTeams
            if(name.favorites.count > 0){
                for index in 0...name.favorites.count-1{
                    print(name.favorites[index].name!)
                }
            }
            changeButton()
        }
    }
    
    func changeButton(){
        if (checkIfFaved(currentTeam!) == true){
            let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "unFavorite")
            self.navigationItem.rightBarButtonItem = button
        } else{
            let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "favorite")
            self.navigationItem.rightBarButtonItem = button
        }
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matches != nil ? matches!.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("matchCell") as UITableViewCell!
        cell.textLabel?.text = "\(matches![indexPath.row].homeTeamName!) \(matches![indexPath.row].homegoal!)  - \(matches![indexPath.row].awaygoal!) \(matches![indexPath.row].awayTeamName!) "
        return cell
    }
    
    func configureView(){
        if let team = self.currentTeam{
            if let label = self.infoLabel {
                label.text = label.text! + team.name!
            }
            self.title = team.name
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //code
        
        if (segue.identifier == "identifierFromTeamToMatch"){
            if let indexPath = self.matchTableView.indexPathForSelectedRow{
                let selectedTournamentMatch = matches![indexPath.row]
                (segue.destinationViewController as! MatchViewController).selectedMatch = selectedTournamentMatch
            }
        }
        
        
        /*
        if (segue.identifier == "listToTeamView") {
        if let indexPath = self.teamTableView.indexPathForSelectedRow{
        let selectedTeam = teams![indexPath.row]
        (segue.destinationViewController as! TeamViewController).currentTeam = selectedTeam
        }
        }

*/
        
    }
}
