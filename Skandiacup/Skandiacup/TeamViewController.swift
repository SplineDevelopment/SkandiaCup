//
//  TeamViewController.swift
//  Skandiacup

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
    var noUpcomming: Bool = false
    var teams = [String]()
    var error_message_is_set = false
    var start_time : Double?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var matchesLoadedOK = false
    var tableSortedOK = false
    var findTeamsLoadedOK = false
    var matchTable: MatchTable?
    var currentMatchClass: MatchClass?
    var currentMatchGroup: MatchGroup?
    var matchesNotYetPlayed: [TournamentMatch]?
    var matchesPlayed: [TournamentMatch]?
    var matchTables: [MatchTable]?{
        didSet{
            self.matchTables?.forEach({ (table) -> () in
                if Int(table.header!.matchGroupId!)! == self.currentTeam!.matchGroupId{
                    self.matchTable = table
                    return
                }
            })
            self.matchTable?.rows?.sortInPlace({$0.position < $1.position})
            self.tableSortedOK = true
            self.isItOkToShowMatches()
        }
    }
    var matches: [TournamentMatch]? {
        didSet {
            if matches != nil{
                matchesNotYetPlayed = findUpcommingMatches(matches!)
                matchesPlayed = findMatchesPlayed(matches!)
            }
        }
    }
    var currentTeam: TournamentTeam? {
        didSet {
            configureView()
            findTeams()
            self.isItOkToShowMatches()
        }
    }
    var currentGroup: MatchGroup? {
        didSet{
            SharingManager.data.getTeams(nil) { (teams, error) -> () in
                if error{
                    print("error in TeamViewController.CurrentGroup.didSet")
                    if !self.error_message_is_set {
                        self.error_message_is_set = true
                        let alertController = UIAlertController(title: "Error", message:
                            "Team data not available atm", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                } else {
                    teams.forEach({ (team) -> () in
                        if team.matchGroupId == self.currentGroup?.id{
                            self.currentTeam = team
                            return
                        }
                    })
                }
            }
        self.currentMatchGroup = currentGroup
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        matchTableView.delegate = self
        matchTableView.dataSource = self
        self.configureView()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.setUpMatches()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.error_message_is_set = false
        self.start_time = CACurrentMediaTime()
        self.matchTableView.hidden = true
        self.activityIndicator.startAnimating()
        changeButton()
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
        let data2 = NSKeyedArchiver.archivedDataWithRootObject(tempFav!)
        defaults.setObject(data2, forKey: "favorites")
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
                    if (convert.id! == team.id!) {
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
                        if (currentTeam!.id! == favoriteTeam.id!){
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
            //let dataRecieved2 = defaults.objectForKey("favorites") as? NSData
            //let name = NSKeyedUnarchiver.unarchiveObjectWithData(dataRecieved2!) as! FavoriteTeams
            changeButton()
            // error handling?
            self.view.makeToast(message: "Removed \(currentTeam!.name!) from favorites", duration: 1, position: "center", title: "Favorites", image: UIImage(named: "ball")!)
        }
    }
    
    func noAction(){
        
    }
    
    func changeButton(){
        if currentGroup != nil {
            let button = UIBarButtonItem(image: UIImage(), style: UIBarButtonItemStyle(rawValue: 1)!, target: self, action: "noAction")
            self.navigationItem.rightBarButtonItem = button
            return
        }
        if let currentTeam = self.currentTeam{
            if (checkIfFaved(currentTeam) == true){
             //   let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "unFavorite")
                let button = UIBarButtonItem(image: UIImage(named: "Star Filled-32-2"), style: .Plain, target: self, action: "unFavorite")
                button.tintColor = UIColor(red:0.95, green:0.77, blue:0.06, alpha:1.0)
                self.navigationItem.rightBarButtonItem = button
            } else{
                //let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "favorite")
                let button = UIBarButtonItem(image: UIImage(named: "Star-32-2"), style: .Plain , target: self, action: "favorite")
                button.tintColor = UIColor(red:0.95, green:0.77, blue:0.06, alpha:1.0)
                self.navigationItem.rightBarButtonItem = button
            }
        }
       
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("sectionHeader") as! CustomHeaderCell
        switch (section) {
        case 0:
            var headerText = SharingManager.locale.tableHeader
            if let mg = self.currentMatchGroup {
                if let mc = self.currentMatchClass{
                    headerText = headerText + " - \(mc.name!) - \(mg.name!)"
                }
            }
            
            headerCell.headerLabel.text = headerText
            //return sectionHeaderView
        case 1:
            headerCell.headerLabel.text = SharingManager.locale.upcomingMatches
            //return sectionHeaderView
        case 2:
            headerCell.headerLabel.text = SharingManager.locale.playedMatches
            //return sectionHeaderView
        default:
            headerCell.headerLabel.text = SharingManager.locale.otherMatches
        }
        return headerCell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(section == 0){           //Table rows in grouptable
           // return self.matchTable != nil ? (self.matchTable?.rows?.count)! + 1 : 0
            if(self.matchTable == nil){
                return teams.count+1
            } else{
                return (self.matchTable?.rows?.count)! + 1
            }
        }
        else if(section == 1){                            // Matches not yet played
            var numberOfRows = 0
            if(matches != nil){
                if matches?.count > 0 {
                    for index in 0...matches!.count-1{
                        if(matches![index].homegoal == nil){
                            numberOfRows++
                        }
                    }
                }
            }
            if (numberOfRows == 0){
                noUpcomming = true
                return 1
            } else{
                noUpcomming = false
                return numberOfRows
            }

        }
        else{              //matches played
            var numberOfRows = 0
            if(matches != nil){
                if matches?.count > 0 {
                    for index in 0...matches!.count-1{
                        if(matches![index].homegoal != nil){
                            numberOfRows++
                        }
                    }
                }
            }
            return numberOfRows
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
            if (matchTable == nil){
                zeroTable(cell, nameTable: teams, index: indexPath.row-1)
                cell.userInteractionEnabled = false
                return cell
            } else{
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
                cell.userInteractionEnabled = false
                return cell
            }
        }
        else if (indexPath.section == 1){
            if (noUpcomming == true){
                let cell = tableView.dequeueReusableCellWithIdentifier("noUpcommingMatches") as! matchCellView!
                cell.noUpcommingMatchesLabel.text = SharingManager.locale.noUpcomingMatches
                cell.dateView.backgroundColor = UIColor.whiteColor()
                cell.view.backgroundColor = UIColor.whiteColor()
                cell.userInteractionEnabled = false
                return cell
            }
            else if let match = matchesNotYetPlayed?[indexPath.row]{
                let cell = tableView.dequeueReusableCellWithIdentifier("matchCell") as! matchCellView!
                if let date = match.matchDate{
                    cell.dateLabel.text = getDate(date)
                    cell.timeLabel.text = getTime(date)
                }
                
                if match.endGameLevel == 0{
                    if let home = match.homeTeamName{
                        cell.homeTeamNameLabel.text = home
                    }
                    
                    if let away = match.awayTeamName{
                        cell.awayTeamNameLabel.text = away
                    }
                }else{
                    if let home = match.homeTeamText{
                        cell.homeTeamNameLabel.text = home
                    }
                    
                    if let away = match.awayTeamText{
                        cell.awayTeamNameLabel.text = away
                    }
                }

                cell.awayTeamGoalLabel.text = "-"
                cell.homeTeamGoalLabel.text = "-"
                
                if let fieldId = match.fieldId{
                    cell.fieldNameLabel.text = String(fieldId)
                }

                if let classId = match.classId{
                    cell.classNameLabel.text = String(classId)
                }
                
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
                cell.userInteractionEnabled = true
                return cell
            }
        } else if let match = matchesPlayed?[indexPath.row]{
            let cell = tableView.dequeueReusableCellWithIdentifier("matchesPlayed") as! matchCellView!
            if let date = match.matchDate{
                cell.dateLabel.text = getDate(date)
                cell.timeLabel.text = getTime(date)
            }
        
            if let home = match.homeTeamText{
                cell.homeTeamNameLabel.text = home
            }
            
            if let away = match.awayTeamText{
                cell.awayTeamNameLabel.text = away
            }
            
            if let homeGoal = match.homegoal{
                cell.homeTeamGoalLabel.text = homeGoal
            }
            
            if let awayGoal = match.awaygoal{
                cell.awayTeamGoalLabel.text = awayGoal
            }
        
            if let fieldId = match.fieldId{
                cell.fieldNameLabel.text = String(fieldId)
            }
            
            if let classId = match.classId{
                cell.classNameLabel.text = String(classId)
            }
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return cell
        }
        return UITableViewCell()
    }

    func setUpcomming(){
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 1 || indexPath.section == 2){
            return Config.matchCellViewHeight
        }
        return UITableViewAutomaticDimension
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
    
    func zeroTable(cell: ResultTableViewCell, nameTable: [String], index: Int){
        cell.teamNameLabel.text = nameTable[index]
        cell.positionLabel.text = String(index+1)
        cell.pointsLabel.text = String(0)
        cell.plusMinusLabel.text = String(0)
        cell.lossesLabel.text = String(0)
        cell.drawsLabel.text = String(0)
        cell.winsLabel.text = String(0)
        cell.gamesPlayedLabel.text = String(0)
    }
    
    func findTeams(){
        var tm = [String]()
        let groupId = currentTeam?.matchGroupId
        SharingManager.data.getTeams(nil) { (teams, error) -> () in
            if error {
                print("error...")
                if !self.error_message_is_set {
                    self.error_message_is_set = true
                    let alertController = UIAlertController(title: "Error", message:
                        "Team data not available", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                let t = teams.filter({ (element) -> Bool in
                    element.matchGroupId != nil ? element.matchGroupId == groupId : false
                })
                t.forEach({ (team) -> () in
                    tm.append(team.name!)
                })
            }
            self.teams = tm
            self.findTeamsLoadedOK = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //code
        if (segue.identifier == "identifierFromTeamToMatch"){
            if let indexPath = self.matchTableView.indexPathForSelectedRow{
                var selectedTournamentMatch = TournamentMatch()
                if (indexPath.section == 1){
                    selectedTournamentMatch = matchesNotYetPlayed![indexPath.row]
                } else {
                    selectedTournamentMatch = matchesPlayed![indexPath.row]
                }
                (segue.destinationViewController as! MatchViewController).selectedMatch = selectedTournamentMatch
            }
        }
    }
    
    func setUpMatches(){
        if self.currentTeam != nil && self.currentGroup != nil {
            SharingManager.data.getMatches(nil, groupID: self.currentGroup!.id, teamID: nil, endplay: nil, completionHandler: { (matches, error) -> () in
                if error{
                    print("Error in Teamviewcontroller.setupMatches")
                    if !self.error_message_is_set {
                        self.error_message_is_set = true
                        let alertController = UIAlertController(title: "Error", message:
                            "Team data not available", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }else{
                    self.matches = matches
                    print("Halaaaa \(self.matches!.count)")
                    SharingManager.data.getTable(nil, playOffId: nil, teamId: self.currentTeam?.id, completionHandler: { (tables, error) -> () in
                        if error{
                            print("Error in Teamviewcontroller.setupMatches")
                            if !self.error_message_is_set {
                                self.error_message_is_set = true
                                let alertController = UIAlertController(title: "Error", message:
                                    "Team data not available", preferredStyle: UIAlertControllerStyle.Alert)
                                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                        }
                        else{
                            self.matchTables = tables
                        }
                    })
                }
                self.matchesLoadedOK = true
            })
        }
        else if currentTeam != nil {
            SharingManager.data.getMatches(nil, groupID: self.currentTeam?.matchGroupId, teamID: self.currentTeam?.id, endplay: nil, completionHandler: { (matches, error) -> () in
                if error{
                    print("Error in Teamviewcontroller.setupMatches")
                    if !self.error_message_is_set {
                        self.error_message_is_set = true
                        let alertController = UIAlertController(title: "Error", message:
                            "Team data not available", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
                }else{
                    self.matches = matches
                    SharingManager.data.getTable(nil, playOffId: nil, teamId: self.currentTeam?.id, completionHandler: { (tables, error) -> () in
                        if error{
                            print("Error in Teamviewcontroller.setupMatches")
                            if !self.error_message_is_set {
                                self.error_message_is_set = true
                                let alertController = UIAlertController(title: "Error", message:
                                    "Team data not available", preferredStyle: UIAlertControllerStyle.Alert)
                                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                                self.presentViewController(alertController, animated: true, completion: nil)
                            }
                        }
                        else{
                            self.matchTables = tables
                        }
                    })
                    
             }
                self.matchesLoadedOK = true
            })
        }
    }
    
    func isItOkToShowMatches(){
        if (findTeamsLoadedOK && matchesLoadedOK && tableSortedOK){
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.matchTableView.reloadData()
                self.matchTableView.hidden = false
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    func findUpcommingMatches(matches: [TournamentMatch]) -> [TournamentMatch]{
        var result = [TournamentMatch]()
        for m in matches{
            if m.homegoal == nil{
                result.append(m)
            }
        }
        return result
    }
    
    func findMatchesPlayed(matches: [TournamentMatch]) -> [TournamentMatch]{
        var result = [TournamentMatch]()
        for m in matches{
            if m.homegoal != nil{
                result.append(m)
            }
        }
        return result
    }
    
    func dateTimeConverter(dateString: String) -> [String]{
        let dateTimeArr = dateString.characters.split{$0 == "T"}.map(String.init)
        return dateTimeArr
    }
    
    func getDate(dateString: String) ->String{
        var array = dateTimeConverter(dateString)
        return array[0]
    }
    
    func getTime(dateString: String) ->String{
        var array = dateTimeConverter(dateString)
        let time = array[1].substringWithRange(Range<String.Index>(start: array[1].startIndex, end: array[1].endIndex.advancedBy(-3)))
        return time
    }
    
}
