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
    var table = TableMock.generateAMock()
    var infoSectionIsSet = false
    var isEven = false
    
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
            print("hmm")
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
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("sectionHeader") as! CustomHeaderCell
        switch (section) {
        case 0:
            headerCell.headerLabel.text = "Tabell";
            //return sectionHeaderView
        case 1:
            headerCell.headerLabel.text = "Kamper spilt";
            //return sectionHeaderView
        case 2:
            headerCell.headerLabel.text = "Kommende kamper";
            //return sectionHeaderView
        default:
            headerCell.headerLabel.text = "Other";
        }
        return headerCell
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){
            return table.teams.count+1
        }
        else if(section == 1){
            return matches != nil ? matches!.count : 0
        }
        else{
            return 0
        }
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        infoSectionIsSet = false
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(indexPath.section == 0 && infoSectionIsSet == false){
            let cell = tableView.dequeueReusableCellWithIdentifier("tableInfoSection") as UITableViewCell!
            infoSectionIsSet = true
            return cell
        }
        if (indexPath.section == 0){
            let i = indexPath.row-1
            print(indexPath.row)
            let cell = tableView.dequeueReusableCellWithIdentifier("tableSection") as! ResultTableViewCell
            cell.teamNameLabel.text = String(table.teams[i])
            cell.positionLabel.text = String(i+1)
            cell.pointsLabel.text = String(table.points[i])
            cell.plusMinusLabel.text = String((table.goalsFor[i] - table.goalsAgainst[i]))
            cell.lossesLabel.text = String(table.losses[i])
            cell.drawsLabel.text = String(table.draws[i])
            cell.winsLabel.text = String(table.wins[i])
            cell.gamesPlayedLabel.text = String(table.gamesPlayed[i])
            if (isEven){
                cell.backgroundColor = UIColor(red:0.87, green:0.89, blue:0.82, alpha:1.0)
            }
            isEven = !isEven
            return cell
        }
        else if (indexPath.section == 1){
            let cell = tableView.dequeueReusableCellWithIdentifier("matchCell") as UITableViewCell!
            cell.textLabel?.text = "\(matches![indexPath.row].homeTeamName!) \(matches![indexPath.row].homegoal!)  - \(matches![indexPath.row].awaygoal!) \(matches![indexPath.row].awayTeamName!) "
            return cell
        } else{
            return UITableViewCell()
        }
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
