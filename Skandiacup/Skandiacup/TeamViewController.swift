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
    var infoSectionIsSet = false
    var isEven = false
    var matchTable: MatchTable?
    var matchTables: [MatchTable]?{
        didSet{
            self.matchTables?.forEach({ (table) -> () in
                if Int(table.header!.matchGroupId!)! == self.currentTeam!.matchGroupId{
                    self.matchTable = table
                }
            })
            self.matchTable?.rows?.sortInPlace({$0.position < $1.position})
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.matchTableView.reloadData()
            })
        }
    }
    
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
    
    var currentGroup: MatchGroup? {
        didSet{
            SharingManager.data.getTeams(nil) { (teams, error) -> () in
                if error{
                    print("error in TeamViewController.CurrentGroup.didSet")
                } else {
                    teams.forEach({ (team) -> () in
                        if team.matchGroupId == self.currentGroup?.id{
                            self.currentTeam = team
    //                        self.navigationController?.title = String(self.currentGroup?.id)
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.matchTableView.reloadData()
                            })
                        }
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchTableView.delegate = self
        matchTableView.dataSource = self
        self.configureView()
//        SharingManager.soap.getMatches(nil, groupID: nil, teamID: currentTeam?.id, endplay: nil) { (matches) -> () in
//            self.matches = matches
//        }
        changeButton()
        // Do any additional setup after loading the view.
        
        SharingManager.data.getTable(nil, playOffId: nil, teamId: self.currentTeam?.id, completionHandler: { (tables, error) -> () in
            if error {
                print("error getting matches")
                // needs to be handled properly
            } else {
                self.matchTables = tables
            }
        })
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.setUpMatches()
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
//            print(name.favorites[index].name!)
        }
        changeButton()
        // error handling?
        self.view.makeToast(message: "Added \(currentTeam!.name!) to favorites", duration: 1, position: "center", title: "Favorites", image: UIImage(named: "ball")!)
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
//            if(name.favorites.count > 0){
//                for index in 0...name.favorites.count-1{
//                    print(name.favorites[index].name!)
//                }
//            }
            changeButton()
            // error handling?
            self.view.makeToast(message: "Removed \(currentTeam!.name!) from favorites", duration: 1, position: "center", title: "Favorites", image: UIImage(named: "ball")!)
        }
    }
    
    func changeButton(){
        if let currentTeam = self.currentTeam{
            if (checkIfFaved(currentTeam) == true){
                let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "unFavorite")
                self.navigationItem.rightBarButtonItem = button
            } else{
                let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "favorite")
                self.navigationItem.rightBarButtonItem = button
            }
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
        if(section == 0){           //Table rows in grouptable
            return self.matchTable != nil ? (self.matchTable?.rows?.count)! + 1 : 0
        }
        else if(section == 1){              //matches played
            var numberOfRows = 0
            if(matches != nil){
                for index in 0...matches!.count-1{
                    if(matches![index].homegoal != nil){
                        numberOfRows++
                    }
                }
            }
            return numberOfRows++
        }
        else{                               // Matches not yet played
            var numberOfRows = 0
            if(matches != nil){
                for index in 0...matches!.count-1{
                    if(matches![index].homegoal == nil){
                        numberOfRows++
                    }
                }
            }
            return numberOfRows++
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
        //Table header
        if(indexPath.section == 0 && indexPath.row == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("tableInfoSection") as UITableViewCell!
            infoSectionIsSet = true
            return cell
        }
        
        //Matchtable
        if (indexPath.section == 0){
            let cell = tableView.dequeueReusableCellWithIdentifier("tableSection") as! ResultTableViewCell
            cell.teamNameLabel.text = self.matchTable?.rows![indexPath.row-1].a
            cell.positionLabel.text = self.matchTable?.rows![indexPath.row-1].position
            cell.pointsLabel.text = self.matchTable?.rows![indexPath.row-1].g
            cell.plusMinusLabel.text = convertPlusMinus((self.matchTable?.rows![indexPath.row-1].f)!)
            cell.lossesLabel.text = self.matchTable?.rows![indexPath.row-1].e
            cell.drawsLabel.text = self.matchTable?.rows![indexPath.row-1].d
            cell.winsLabel.text = self.matchTable?.rows![indexPath.row-1].c
            
            var gamesPlayed = 0
            gamesPlayed += Int((self.matchTable?.rows![indexPath.row-1].e)!)!
            gamesPlayed += Int((self.matchTable?.rows![indexPath.row-1].d)!)!
            gamesPlayed += Int((self.matchTable?.rows![indexPath.row-1].c)!)!
            cell.gamesPlayedLabel.text = String(gamesPlayed)
            return cell
        }
        else if (indexPath.section == 1){
            
            let cell = tableView.dequeueReusableCellWithIdentifier("matchCell") as UITableViewCell!
            if let match = matches?[indexPath.row]{
                cell.textLabel?.text = "\(match.homeTeamName!) \(match.homegoal!)  - \(match.awaygoal!) \(match.awayTeamName!) "
                //legg denne inn også på kommendekamper, smiletegn
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func configureView(){
        if let team = self.currentTeam{
            if let label = self.infoLabel {
                label.text = label.text! + team.name!
            }
            self.title = self.currentGroup != nil ? String(self.currentGroup!.name!) : self.currentTeam?.name
        }
    }
    
    //Func to convert +/- goals
    func convertPlusMinus(input: String) -> String{
            var resString = input.componentsSeparatedByString(" ")
            let goalFor = Int(resString[0])
            let goalAgainst = Int(resString[2])
            let res = goalFor! - goalAgainst!
            return String(res)
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
    }
    
    override func willMoveToParentViewController(parent: UIViewController?) {
        let grandpa = self.parentViewController?.parentViewController
        if ((grandpa!.isKindOfClass(TournamentViewController))){
            (grandpa as! TournamentViewController).testingFunc(TeamsViewController)
        }
    }
    
    func setUpMatches(){
        if self.currentTeam != nil && self.currentGroup != nil {
            SharingManager.data.getMatches(nil, groupID: self.currentGroup!.id, teamID: nil, endplay: nil, completionHandler: { (matches, error) -> () in
                if error{
                    print("Error in Teamviewcontroller.setupMatches")
                }else{
                    self.matches = matches
                }
            })
        }
        else if currentTeam != nil {
            SharingManager.data.getMatches(nil, groupID: nil, teamID: self.currentTeam?.id, endplay: nil, completionHandler: { (matches, error) -> () in
                if error{
                    print("Error in Teamviewcontroller.setupMatches")
                }else{
                    self.matches = matches
                }
            })
        }
        SharingManager.data.getTable(nil, playOffId: nil, teamId: self.currentTeam?.id, completionHandler: { (tables, error) -> () in
            if error{
                print("Error in Teamviewcontroller.setupMatches")
            }
            else{
                self.matchTables = tables
            }
        })
    }
}
