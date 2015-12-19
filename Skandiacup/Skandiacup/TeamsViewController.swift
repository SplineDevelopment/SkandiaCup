//
//  TeamViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.

import UIKit

class TeamsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    var filterViewTest: filterView?
    
    @IBOutlet weak var filterDropDownView: UIView!
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var standardPixelHeight: CGFloat?
    var heighIsSet = false
    
    var countryPickerValues: [String] = ["Alle"]
    let sexPickerValues = ["Alle", "Menn", "Damer"]
    var dropDownViewIsDisplayed = false
    var pickerActive : Bool = false
    var error_message_is_set = false
    var dimView:UIView?

    var teams: [TournamentTeam]? {
        didSet{
            setupCountryPicker()
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.teamTableView.hidden = false
                self.teamTableView.reloadData()
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    var matchClasses: [MatchClass]?
    var filteredTeams = [TournamentTeam]()

    @IBAction func indexChanged(sender: AnyObject) {
        (self.parentViewController?.parentViewController as! TournamentViewController).switchTable(segmentController.selectedSegmentIndex)
        self.segmentController.selectedSegmentIndex = 0
    }
    
    func setupCountryPicker() {
        self.teams!.forEach({ (team) -> () in
            if let countrycode = team.countryCode {
                if !countryPickerValues.contains(countrycode){
                    self.countryPickerValues.append(countrycode)
                }
            }
        })
    }
    
    override func viewDidLoad() {
        segmentController.selectedSegmentIndex = 0
        super.viewDidLoad()
        
        filterViewTest = filterView(frame: CGRectZero)
        filterViewTest?.setupDelegates(self)
        let height = Config.filterViewHeight
        var width = filterViewTest?.frame.size.width
        width = teamTableView.frame.width
        
        self.filterViewTest?.frame = CGRectMake(0, -height, width!, height)
        self.view.addSubview(filterViewTest!)
        
        self.filterViewTest!.searchTextField.addTarget(self, action: "updateFilteredTeams", forControlEvents: UIControlEvents.EditingChanged)
        self.filterViewTest!.hidden = true
        dimView = UIView(frame: CGRectInfinite)
        self.dimView!.backgroundColor = .blackColor()
        self.dimView!.alpha = 0
        
        self.teamTableView.addSubview(self.dimView!)
        
        
        teamTableView.dataSource = self
        teamTableView.delegate = self
        teamTableView.hidden = true
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = teamTableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
        var cellText = filteredTeams[indexPath.row].name!
        matchClasses?.forEach({ (mc) -> () in
            if(mc.id! == filteredTeams[indexPath.row].matchClassId!){
                mc.matchGroups?.forEach({ (mg) -> () in
                    if(mg.id == filteredTeams[indexPath.row].matchGroupId){
                        cellText = cellText + " - Class \(mc.code!) - Group \(mg.name!)"
                    }
                })
            }
        })
        cell!.textLabel?.text = cellText
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
        self.error_message_is_set = false
        SharingManager.data.getMatchClass { (matchclasses, error) -> () in
            if error{
                print("Error in TeamsViewController.viewWillAppear")
                if !self.error_message_is_set {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.error_message_is_set = true
                    let alertController = UIAlertController(title: "Error", message:
                        "Team data not available atm", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }else{
                if !self.error_message_is_set {
                    self.matchClasses = matchclasses
                }
            }
        }
        
        SharingManager.data.getTeams(nil) { (teams, error) -> () in
            if error {
                print("error getting teams")
                if !self.error_message_is_set {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.error_message_is_set = true
                    let alertController = UIAlertController(title: "Error", message:
                        "Team data not available atm", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                // needs to be handled properly
            } else {
                if !self.error_message_is_set {
                    self.teams = teams
                    self.filteredTeams = teams
                    self.updateFilteredTeams()
                }
            }
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Config.teamCellHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.filteredTeams.count
    }

    func changeSegment(){
        teamTableView.layer.frame.size.height = teamTableView.layer.frame.size.height + Config.filterViewHeight
    }
    
    
    func hideDropDownView() {
        var frame = self.filterViewTest!.frame
        frame.origin.y = -frame.size.height
        self.animateDropDownToFrame(frame) {
            self.dropDownViewIsDisplayed = false
            self.filterViewTest!.hidden = true
            self.teamTableView.allowsSelection = true
            self.teamTableView.scrollEnabled = true
        }
    }
    
    func showDropDownView() {
        var frame = self.filterViewTest!.frame
        frame.origin.y = self.navigationController!.navigationBar.frame.size.height+40
        self.filterViewTest!.hidden = false
        self.teamTableView.allowsSelection = false
        self.teamTableView.scrollEnabled = false
        self.animateDropDownToFrame(frame) {
            self.dropDownViewIsDisplayed = true
        }
    }
    
    func animateDropDownToFrame(frame: CGRect, completion:() -> Void) {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseInOut, animations: { () -> Void in
            self.filterViewTest!.frame = frame
            
            if(self.dropDownViewIsDisplayed){
                self.dimView!.alpha = 0.5
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.dimView!.alpha = 0.0
                })
            }else if(!self.dropDownViewIsDisplayed){
                self.dimView!.alpha = 0
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.dimView!.alpha = 0.5
                })
            }
            
        }) { (completed) -> Void in
            if(completed){
                completion()
            }
        }
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        if(dropDownViewIsDisplayed){
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, Config.filterViewHeight+40, 0)
            self.teamTableView.layer.transform = rotationTransform
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.teamTableView.layer.transform = CATransform3DIdentity
                }, completion: { (success) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    })
            })
        }else if !dropDownViewIsDisplayed{
            self.teamTableView.layer.transform = CATransform3DIdentity
            let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, Config.filterViewHeight+40, 0)
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.teamTableView.layer.transform = rotationTransform
                }, completion: { (success) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    })
            })
        }
        if(dropDownViewIsDisplayed){
            hideDropDownView()
        }else{
            showDropDownView()
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "listToTeamView") {
            if let indexPath = self.teamTableView.indexPathForSelectedRow{
                let selectedTeam = filteredTeams[indexPath.row]
                (segue.destinationViewController as! TeamViewController).currentTeam = selectedTeam
                
                matchClasses?.forEach({ (mc) -> () in
                    if(mc.id! == filteredTeams[indexPath.row].matchClassId!){
                        mc.matchGroups?.forEach({ (mg) -> () in
                            if(mg.id == filteredTeams[indexPath.row].matchGroupId){
                                (segue.destinationViewController as! TeamViewController).currentMatchClass = mc
                                (segue.destinationViewController as! TeamViewController).currentMatchGroup = mg
                            }
                        })
                    }
                })
            }
        }
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
            (self.filterViewTest!).sexTextField.text = self.sexPickerValues[row]
            pickerActive = true
        }
        
        if(pickerView.accessibilityIdentifier == "countryPicker"){
            (self.filterViewTest!).countryTextField.text = self.countryPickerValues[row]
            pickerActive = true
        }
        updateFilteredTeams()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.view.endEditing(true)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("TOUCHES BEGAN")
        let touch: UITouch = touches.first! as UITouch
        if touch.view == self.teamTableView{
            resign()
        }
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.view.endEditing(true)
        }
    }
        
    func updateFilteredTeams(){
        filteredTeams = teams!
        let sexPickerValue = sexPickerValues[(self.filterViewTest!).sexPicker.selectedRowInComponent(0)]
        let countryPickerValue = countryPickerValues[(self.filterViewTest!).countryPicker.selectedRowInComponent(0)]
        let searchText = self.filterViewTest!.searchTextField.text
        
        if sexPickerValue != "" && sexPickerValue != "Alle" {
            filteredTeams = filteredTeams.filter({ (team) -> Bool in
                if(sexPickerValue == "Menn"){
                    for matchclass in self.matchClasses!{
                        if team.matchClassId == matchclass.id{
                            return matchclass.gender == "M"
                        }
                    }
                }else if sexPickerValue == "Damer"{
                    for matchclass in self.matchClasses!{
                        if team.matchClassId == matchclass.id{
                            return matchclass.gender == "F"
                        }
                    }
                }
                return false
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
                let range = tmp.rangeOfString(searchText!, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
        }
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.teamTableView.reloadData()
        })
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true)
        resign()
    }
    private func resign(){
        (self.filterViewTest!).sexPicker.resignFirstResponder()
        (self.filterViewTest!).countryPicker.resignFirstResponder()
        (self.filterViewTest!).sexPicker.endEditing(true)
        (self.filterViewTest!).countryPicker.endEditing(true)
    }
}