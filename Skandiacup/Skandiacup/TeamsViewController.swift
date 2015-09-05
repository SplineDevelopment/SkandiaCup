//
//  TeamViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class TeamsViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var teamTableView: UITableView!
    
    var teams: [TournamentTeam]? {
        didSet{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.teamTableView.reloadData()
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamTableView.dataSource = self
        teamTableView.delegate = self
        
        SharingManager.soap.getTeams(nil) { (teams) -> () in
            self.teams = teams
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
        cell.textLabel?.text = teams![indexPath.row].name
        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams != nil ? teams!.count : 0
    }
    
    // UITableViewDelegate Functions

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(animated: Bool) {
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "listToTeamView") {
            if let indexPath = self.teamTableView.indexPathForSelectedRow{
                let selectedTeam = teams![indexPath.row]
                (segue.destinationViewController as! TeamViewController).currentTeam = selectedTeam
            }
        }
    }

}
