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
        // Do any additional setup after loading the view.
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
