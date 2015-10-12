//
//  TeamViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.

import UIKit

class TeamsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UISearchControllerDelegate, UISearchResultsUpdating, SegmentChangeProto, TeamsViewChangeProto{
    @IBOutlet weak var filterDropDownView: UIView!
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var standardPixelHeight: CGFloat?
    var heighIsSet = false
    
    /// Search controller to help us with filtering.
    var searchController: UISearchController!
    
    //get this dynamicly from teams
    let countryPickerValues: [String] = ["Alle", "SE", "NO", "DE"]
    let sexPickerValues = ["Alle", "Menn", "Damer"]
    var dropDownViewIsDisplayed = false
    var pickerActive : Bool = false

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
        self.segmentController.selectedSegmentIndex = 0
    }
    
    override func viewDidLoad() {
        self.teamTableView.backgroundColor = UIColor.clearColor()
        segmentController.selectedSegmentIndex = 0
        super.viewDidLoad()
        self.teamTableView.tableHeaderView?.hidden = true
        (self.teamTableView.tableHeaderView as! filterView).setupDelegates(self)
        teamTableView.dataSource = self
        teamTableView.delegate = self
        teamTableView.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
//        segmentController.selectedSegmentIndex = 0
        /*
        SharingManager.soap.getTeams(nil) { (teams) -> () in
            self.teams = teams
            self.filteredTeams = teams
        }
        */
        SharingManager.data.getTeams(nil) { (teams) -> () in
            self.teams = teams
            self.filteredTeams = teams
        }
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        self.teamTableView.tableHeaderView?.addSubview(searchController.searchBar)
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        self.teamTableView.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, -Config.filterViewHeight, 0)
    }
    
    func viewChangedTo() {
//        self.segmentController.selectedSegmentIndex = 0
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if !(self.heighIsSet) {
                self.standardPixelHeight = self.teamTableView.layer.frame.size.height
                self.heighIsSet = true
            }
            if self.dropDownViewIsDisplayed {
                self.teamTableView.layer.frame.size.height = self.standardPixelHeight!
            } else {
                self.teamTableView.layer.frame.size.height = self.standardPixelHeight! + Config.filterViewHeight
            }
//            self.segmentController.selectedSegmentIndex = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = teamTableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
        if self.searchController.active || pickerActive{
            cell!.textLabel?.text = filteredTeams[indexPath.row].name
        }
        else{
            cell!.textLabel?.text = teams![indexPath.row].name
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Config.teamCellHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.searchController.active || self.pickerActive){
            return self.filteredTeams.count
        }else{
            return teams != nil ? teams!.count : 0
        }
    }

    func changeSegment(){
//        self.segmentController.selectedSegmentIndex = 0
        teamTableView.layer.frame.size.height = teamTableView.layer.frame.size.height + Config.filterViewHeight
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -Config.filterViewHeight, 0)
        if !dropDownViewIsDisplayed{
            teamTableView.setContentOffset(CGPointZero, animated:true)
            self.teamTableView.tableHeaderView?.hidden = false
            teamTableView.layer.transform = rotationTransform
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.teamTableView.layer.transform = CATransform3DIdentity
                self.dropDownViewIsDisplayed = true
                self.teamTableView.layer.frame.size.height = self.teamTableView.layer.frame.size.height - Config.filterViewHeight
                }, completion: { (success) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.teamTableView.reloadData()
                    })
            })
        } else if dropDownViewIsDisplayed{
            self.teamTableView.layer.frame.size.height = self.teamTableView.layer.frame.size.height + Config.filterViewHeight
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.teamTableView.reloadData()
            })
            teamTableView.layer.transform = CATransform3DIdentity
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.teamTableView.layer.transform = rotationTransform
                self.dropDownViewIsDisplayed = false
                }, completion: { (success) -> Void in
                    self.teamTableView.tableHeaderView?.hidden = true
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "listToTeamView") {
            if(self.searchController.active){
                if let indexPath = self.teamTableView.indexPathForSelectedRow{
                    let selectedTeam = filteredTeams[indexPath.row]
                    (segue.destinationViewController as! TeamViewController).currentTeam = selectedTeam
                    self.searchController.active = false
                    self.searchController.searchBar.endEditing(true)
                }
            }else{
                if let indexPath = self.teamTableView.indexPathForSelectedRow{
                    let selectedTeam = teams![indexPath.row]
                    (segue.destinationViewController as! TeamViewController).currentTeam = selectedTeam
                    self.searchController.active = false
                    self.searchController.searchBar.endEditing(true)
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        filteredTeams = teams!
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.teamTableView.reloadData()
        })
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if(pickerView.accessibilityIdentifier == "sexPicker"){
            return sexPickerValues.count
        }
        
        if(pickerView.accessibilityIdentifier == "countryPicker"){
            return countryPickerValues.count
        }
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if(pickerView.accessibilityIdentifier == "sexPicker"){
            return sexPickerValues[row]
        }
        
        if(pickerView.accessibilityIdentifier == "countryPicker"){
            return countryPickerValues[row]
        }
        return ""
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        if(pickerView.accessibilityIdentifier == "sexPicker"){
            (self.teamTableView.tableHeaderView as! filterView).sexTextField.text = self.sexPickerValues[row]
            pickerActive = true
        }
        
        if(pickerView.accessibilityIdentifier == "countryPicker"){
            (self.teamTableView.tableHeaderView as! filterView).countryTextField.text = self.countryPickerValues[row]
            pickerActive = true
        }
        updateFilteredTeams()
        self.view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        updateFilteredTeams()
    }
        
    func updateFilteredTeams(){
        filteredTeams = teams!
        let sexPickerValue = sexPickerValues[(self.teamTableView.tableHeaderView as! filterView).sexPicker.selectedRowInComponent(0)]
        let countryPickerValue = countryPickerValues[(self.teamTableView.tableHeaderView as! filterView).countryPicker.selectedRowInComponent(0)]
        let searchText = searchController.searchBar.text

        if sexPickerValue != "" && sexPickerValue != "Alle" {
            filteredTeams = filteredTeams.filter({ (team) -> Bool in
                return true
            })
        }
        
        if countryPickerValue != "" && countryPickerValue != "Alle"{
            filteredTeams = filteredTeams.filter({ (team) -> Bool in
                return team.countryCode == countryPickerValue
            })
        }
        
        if searchText != "" {
            filteredTeams = filteredTeams.filter({ (team) -> Bool in
                let tmp: NSString = team.name!
                let range = tmp.rangeOfString(searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.teamTableView.reloadData()
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        self.viewChangedTo()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.viewChangedTo()
            self.teamTableView.reloadData()
        }
    }
    
    
    func updateFilterViewHeight (){
        self.viewChangedTo()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            if self.dropDownViewIsDisplayed {
                self.teamTableView.layer.frame.size.height = self.standardPixelHeight!
            } else {
                self.teamTableView.layer.frame.size.height = self.standardPixelHeight! + Config.filterViewHeight
            }
//            self.segmentController.selectedSegmentIndex = 0
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.viewDidAppear(true)
        }
    }
}