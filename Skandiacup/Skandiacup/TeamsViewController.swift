//
//  TeamViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.

import UIKit

class TeamsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UISearchControllerDelegate, UISearchResultsUpdating{
    var dropDownViewIsDisplayed = false
    var searchActive : Bool = false
    
    @IBOutlet weak var testView: UIView!
    let sexPickerValues = ["Menn", "Damer"]
    //get this dynamicly from teams
    let countryPickerValues: [String] = ["Norway", "Lol", "SwedenHAHAHAHAH"]
    
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
//    @IBOutlet weak var dropDownView: UIView!
    
    /// Search controller to help us with filtering.
    var searchController: UISearchController!
    

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
        self.teamTableView.tableHeaderView = testView
        self.teamTableView.tableHeaderView?.sizeToFit()
//        self.teamTableView.tableHeaderView = filterView()
//        (dropDownView as! filterView).setupDelegates(self)
        (self.teamTableView.tableHeaderView as! filterView).setupDelegates(self)
        teamTableView.dataSource = self
        teamTableView.delegate = self
        teamTableView.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
//        self.dropDownView.hidden = false
        
        segmentController.selectedSegmentIndex = 0
        SharingManager.soap.getTeams(nil) { (teams) -> () in
            self.teams = teams
        }
//        (dropDownView as! filterView).ageLabel.text 
        (self.teamTableView.tableHeaderView as! filterView).ageLabel.text = "\(Int((self.teamTableView.tableHeaderView as! filterView).ageSlider.value))"
        
        // test
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
//         (dropDownView as! filterView).searchBar = searchController.searchBar
//        self.teamTableView.tableHeaderView =  searchController.searchBar
        self.teamTableView.tableHeaderView?.addSubview(searchController.searchBar)
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        searchController.searchBar.delegate = self    // so we can monitor text changes + others

        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -Config.filterViewHeight, 0)
        teamTableView.layer.transform = rotationTransform
        teamTableView.contentSize.height = teamTableView.contentSize.height - Config.filterViewHeight
        self.teamTableView.tableHeaderView?.hidden = true
//        self.teamTableView.contentSize.height = self.teamTableView.contentSize.height - Config.filterViewHeight

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        if(searchActive){
//            let cell = teamTableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
//            if filteredTeams.count > 0{
//                cell.textLabel?.text = filteredTeams[indexPath.row].name
//            }
//            return cell
//        } else {
//            let cell = teamTableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
//            cell.textLabel?.text = teams![indexPath.row].name
//            return cell
//        }
        
        let cell = teamTableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
        if self.searchController.active{
            cell!.textLabel?.text = filteredTeams[indexPath.row].name
        }
        else{
            cell!.textLabel?.text = teams![indexPath.row].name
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if(indexPath.row == 0){
//            return 169
//        }
        return Config.teamCellHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(searchActive){
//            return filteredTeams.count
//        }else{
//            return teams != nil ? teams!.count : 0
//        }
        if (self.searchController.active){
            return self.filteredTeams.count
        }else{
            return teams != nil ? teams!.count : 0
        }
    }

    func changeSegment(){
        self.segmentController.selectedSegmentIndex = 0
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        if !dropDownViewIsDisplayed{
//            dropDownView.hidden = false
            self.teamTableView.tableHeaderView?.hidden = false
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -Config.filterViewHeight, 0)
//            dropDownView.layer.transform = CATransform3DIdentity
            teamTableView.layer.transform = rotationTransform
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
//                self.dropDownView.layer.transform = rotationTransform
                self.teamTableView.layer.transform = CATransform3DIdentity
                self.dropDownViewIsDisplayed = true
//                self.teamTableView.contentSize.height = self.teamTableView.contentSize.height + Config.filterViewHeight
                }, completion: { (success) -> Void in
//                    self.dropDownView.hidden = false
            })
        } else if dropDownViewIsDisplayed{
//            dropDownView.hidden = false
             let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, -Config.filterViewHeight, 0)
//            dropDownView.layer.transform = rotationTransform
            teamTableView.layer.transform = CATransform3DIdentity
//            (dropDownView as! filterView).searchBar.endEditing(true)
            
            UIView.animateWithDuration(1.0, animations: { () -> Void in
//                self.dropDownView.layer.transform = CATransform3DIdentity
                self.teamTableView.layer.transform = rotationTransform
                self.dropDownViewIsDisplayed = false
//                self.teamTableView.contentSize.height = self.teamTableView.contentSize.height - Config.filterViewHeight
                }, completion: { (success) -> Void in
//                    self.dropDownView.hidden = true
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
    
    // UISearchBarDelegate funcitons
    
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
        searchBar.endEditing(true)
        searchActive = false;
    }
    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredTeams = teams!.filter({ (team) -> Bool in
//            let tmp: NSString = team.name!
//            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
//            return range.location != NSNotFound
//        })
//        if(filteredTeams.count == 0){
//            searchActive = false;
//        } else {
//            searchActive = true;
//        }
//        self.teamTableView.reloadData()
//    }
    
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
//            (dropDownView as! filterView).
            (self.teamTableView.tableHeaderView as! filterView).sexTextField.text = self.sexPickerValues[row]
        }
        
        if(pickerView.accessibilityIdentifier == "countryPicker"){
//            (dropDownView as! filterView)
            (self.teamTableView.tableHeaderView as! filterView).countryTextField.text = self.countryPickerValues[row]
        }
        self.view.endEditing(true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("Touchesbegan")
//        (dropDownView as! filterView).searchBar.endEditing(true)
//        (dropDownView as! filterView).searchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {

        if(searchController.searchBar.text! == ""){
            filteredTeams = teams!
            return
        }
                self.filteredTeams.removeAll(keepCapacity: false)
        filteredTeams = teams!.filter({ (team) -> Bool in
            let tmp: NSString = team.name!
            let range = tmp.rangeOfString(searchController.searchBar.text!, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })

//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
//        let array = (self.appleProducts as NSArray).filteredArrayUsingPredicate(searchPredicate)
//        self.filteredAppleProducts = array as! [String]
        
        self.teamTableView.reloadData()
    }
}