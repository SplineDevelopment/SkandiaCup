//
//  TeamViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.

import UIKit

class TeamsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    var dropDownViewIsDisplayed = false
    var searchActive : Bool = false
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var dropDownView: UIView!
    
    var teams: [TournamentTeam]? {
        didSet{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.teamTableView.hidden = false
                self.teamTableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    var filteredTeams = [TournamentTeam]()
    
    @IBAction func indexChanged(sender: AnyObject) {
        (self.parentViewController?.parentViewController as! TournamentViewController).switchTable(segmentController.selectedSegmentIndex)
            viewDidLoad()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (dropDownView as! filterView).setupSearchBar(self)
        teamTableView.dataSource = self
        teamTableView.delegate = self
        teamTableView.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        self.dropDownView.hidden = true
        segmentController.selectedSegmentIndex = 0
        SharingManager.soap.getTeams(nil) { (teams) -> () in
            self.teams = teams
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(searchActive){
            let cell = teamTableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
            if filteredTeams.count > 0{
                cell.textLabel?.text = filteredTeams[indexPath.row].name
            }
            return cell
        } else {
            let cell = teamTableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
            cell.textLabel?.text = teams![indexPath.row].name
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            return filteredTeams.count
        }else{
            return teams != nil ? teams!.count : 0
        }
    }

    func changeSegment(){
        self.segmentController.selectedSegmentIndex = 0
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        if !dropDownViewIsDisplayed{
            dropDownView.hidden = false
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 169, 0)
            dropDownView.layer.transform = CATransform3DIdentity
            teamTableView.layer.transform = CATransform3DIdentity
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.dropDownView.layer.transform = rotationTransform
                self.teamTableView.layer.transform = rotationTransform
                self.dropDownViewIsDisplayed = true
                }, completion: { (success) -> Void in
                    self.dropDownView.hidden = false
            })
        } else if dropDownViewIsDisplayed{
            dropDownView.hidden = false
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 169, 0)
            dropDownView.layer.transform = rotationTransform
            teamTableView.layer.transform = rotationTransform
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
                self.dropDownView.layer.transform = CATransform3DIdentity
                self.teamTableView.layer.transform = CATransform3DIdentity
                self.dropDownViewIsDisplayed = false
                }, completion: { (success) -> Void in
                    self.dropDownView.hidden = true
            })
        }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "listToTeamView") {
            if let indexPath = self.teamTableView.indexPathForSelectedRow{
                let selectedTeam = teams![indexPath.row]
                (segue.destinationViewController as! TeamViewController).currentTeam = selectedTeam
            }
        }
    }
    
    //search bar delegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filteredTeams = teams!.filter({ (team) -> Bool in
            let tmp: NSString = team.name!
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(filteredTeams.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.teamTableView.reloadData()
    }
}