//
//  TeamViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.

import UIKit

class TeamsViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    var searchPressed = false
    var animated = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var teams: [TournamentTeam]? {
        didSet{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.teamTableView.hidden = false
                self.teamTableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
        (self.parentViewController?.parentViewController as! TournamentViewController).switchTable(segmentController.selectedSegmentIndex)
            viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamTableView.dataSource = self
        teamTableView.delegate = self
        teamTableView.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        segmentController.selectedSegmentIndex = 0
        
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
//        print("ANIMATED: \(animated) SEARCHPRESSED: \(searchPressed) INDEXPATH ROW \(indexPath.row)")
        if indexPath.row == 0 && searchPressed {
            let cell = tableView.dequeueReusableCellWithIdentifier("searchCell") as UITableViewCell!
            return cell
        }
        if searchPressed{
            let cell = tableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
            cell.textLabel?.text = teams![indexPath.row-1].name
            return cell
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
            cell.textLabel?.text = teams![indexPath.row].name
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(indexPath.row == 0 && searchPressed){
            return 169
        }
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams != nil ? teams!.count : 0
    }
    
    func changeSegment(){
        self.segmentController.selectedSegmentIndex = 0
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        searchPressed = searchPressed ? false : true
        if(!searchPressed){
            let cell = self.teamTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 200, 0)
            let rotationTransform2 = CATransform3DTranslate(CATransform3DIdentity, 0, 169, 0)
            cell!.layer.transform = rotationTransform
            teamTableView.layer.transform = rotationTransform2
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                cell!.layer.transform = CATransform3DIdentity
                self.teamTableView.layer.transform = CATransform3DIdentity
                self.teamTableView.reloadData()
                self.animated = false
            })
        }
        self.teamTableView.reloadData()
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
        segmentController.setEnabled(true, forSegmentAtIndex: 0)
    }
    
    override func viewWillDisappear(animated: Bool) {
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if(indexPath.row == 0 && searchPressed){
            if(!animated){
                let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -200, 0)
                let rotationTransform2 = CATransform3DTranslate(CATransform3DIdentity, 0, -169, 0)
                cell.layer.transform = rotationTransform
                teamTableView.layer.transform = rotationTransform2

                UIView.animateWithDuration(1.0, animations: { () -> Void in
                    cell.layer.transform = CATransform3DIdentity
                    self.teamTableView.layer.transform = CATransform3DIdentity
                    self.animated = true
                })
            }
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "listToTeamView") {
            if let indexPath = self.teamTableView.indexPathForSelectedRow{
                if searchPressed{
                    let selectedTeam = teams![indexPath.row-1]
                    (segue.destinationViewController as! TeamViewController).currentTeam = selectedTeam
                }else{
                    let selectedTeam = teams![indexPath.row]
                    (segue.destinationViewController as! TeamViewController).currentTeam = selectedTeam
                }
            }
        }
    }
}