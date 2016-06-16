//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import UIKit

class TeamsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate{
    var filterViewTest: filterView?
    
    @IBOutlet weak var teamTableView: UITableView!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var standardPixelHeight: CGFloat?
    var heighIsSet = false
    var matchClasses: [MatchClass]?
    var filteredTeams = [TournamentTeam]()
    var countryPickerValues: [String] = [SharingManager.locale.all]
    let sexPickerValues = [SharingManager.locale.all,SharingManager.locale.male, SharingManager.locale.female]
    var dropDownViewIsDisplayed = false
    var error_message_is_set = false
    var dimView:UIView?
    var matchclassesLoaded = false
    var teamsloaded = false

    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    var teams: [TournamentTeam]? {
        didSet{
            setupCountryPicker()
            self.reloadIfDataIsLoaded()
        }
    }
    

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
        /* Creating a DimView for dimming the view when dropdownview is displayed */
        dimView = DimView(frame: CGRectInfinite)
        self.dimView!.backgroundColor = .blackColor()
        self.dimView!.alpha = 0
        self.view.addSubview(self.dimView!)
        
        /* Creating and setting up a filterview for use in the dropdownview */
        filterViewTest = filterView(frame: CGRectZero)
        filterViewTest?.setupDelegates(self)
        self.filterViewTest?.layer.cornerRadius = 5
        self.view.insertSubview(filterViewTest!, aboveSubview: self.view)
        self.filterViewTest!.searchTextField.addTarget(self, action: "updateFilteredTeams", forControlEvents: UIControlEvents.EditingChanged)
        self.filterViewTest!.hidden = true
        self.filterViewTest!.innerView.layer.cornerRadius = 10.0
        self.filterViewTest!.innerView.layer.borderColor = UIColor.grayColor().CGColor
        self.filterViewTest!.innerView.layer.borderWidth = 0.5
        self.filterViewTest!.innerView.clipsToBounds = true
        let height = filterViewTest?.innerView.frame.height
        self.filterViewTest!.frame = CGRectMake(0 , -height!, UIScreen.mainScreen().bounds.width, height!)
        
        /* Delegates for the tableview */
        teamTableView.dataSource = self
        teamTableView.delegate = self
        teamTableView.hidden = true
        activityIndicator.hidden = false
        self.dimView?.userInteractionEnabled = true
        
        activityIndicator.startAnimating()
    }
    
    func reloadIfDataIsLoaded(){
        if(self.matchclassesLoaded && self.teamsloaded){
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.teamTableView.hidden = false
                self.activityIndicator.stopAnimating()
                self.teamTableView.reloadData()
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.matchclassesLoaded = false
        self.teamsloaded = false
        self.error_message_is_set = false
        SharingManager.data.getMatchClass { (matchclasses, error) -> () in
            if error{
                print("Error in TeamsViewController.viewWillAppear")
                if !self.error_message_is_set {
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.error_message_is_set = true
                    let alertController = UIAlertController(title: SharingManager.locale.errorTitle, message:
                        SharingManager.locale.errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: SharingManager.locale.errorDismiss, style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }else{
                if !self.error_message_is_set {
                    self.matchClasses = matchclasses
                    self.matchclassesLoaded = true
                    self.reloadIfDataIsLoaded()
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
                    let alertController = UIAlertController(title: SharingManager.locale.errorTitle, message:
                        SharingManager.locale.errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: SharingManager.locale.errorDismiss, style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                // needs to be handled properly
            } else {
                if !self.error_message_is_set {
                    self.teams = teams
                    self.filteredTeams = teams
                    self.teamsloaded = true
                    self.reloadIfDataIsLoaded()
                    self.updateFilteredTeams()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = teamTableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
        var cellText = filteredTeams[indexPath.row].name!
        matchClasses?.forEach({ (mc) -> () in
            if(mc.id! == filteredTeams[indexPath.row].matchClassId!){
                mc.matchGroups?.forEach({ (mg) -> () in
                    if(mg.id == filteredTeams[indexPath.row].matchGroupId){
                        cellText = cellText + " - \(SharingManager.locale.teamCellClass) \(mc.code!) - \(SharingManager.locale.teamCellGroup) \(mg.name!)"
                    }
                })
            }
        })
        cell!.textLabel?.text = cellText
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return SharingManager.config.teamCellHeight
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.filteredTeams.count
    }

    func changeSegment(){
        teamTableView.layer.frame.size.height = teamTableView.layer.frame.size.height + SharingManager.config.filterViewHeight
    }
    
    
    func hideDropDownView() {
        self.navigationItem.rightBarButtonItem?.enabled = false
        var frame = self.filterViewTest!.frame
        frame.origin.y = -frame.size.height
        resign()
        self.animateDropDownToFrame(frame) {
            self.dropDownViewIsDisplayed = false
            self.filterViewTest!.hidden = true
            self.teamTableView.allowsSelection = true
            self.teamTableView.scrollEnabled = true
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    
    func showDropDownView() {
        self.navigationItem.rightBarButtonItem?.enabled = false
        var frame = self.filterViewTest!.frame
        frame.origin.y = self.navigationController!.navigationBar.frame.size.height + 15
        self.filterViewTest!.hidden = false
        self.teamTableView.allowsSelection = false
        self.teamTableView.scrollEnabled = false
        self.animateDropDownToFrame(frame) {
            self.dropDownViewIsDisplayed = true
            self.navigationItem.rightBarButtonItem?.enabled = true
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
        moveTeamTableView()
    }
    
    private func moveTeamTableView(){
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, self.filterViewTest!.innerView.frame.height, 0)
        if(dropDownViewIsDisplayed){
            self.teamTableView.layer.transform = rotationTransform
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.teamTableView.layer.transform = CATransform3DIdentity
                }, completion: { (success) -> Void in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    })
            })
        }else if !dropDownViewIsDisplayed{
            self.teamTableView.layer.transform = CATransform3DIdentity
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
        }
        
        if(pickerView.accessibilityIdentifier == "countryPicker"){
            (self.filterViewTest!).countryTextField.text = self.countryPickerValues[row]
        }
        updateFilteredTeams()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.view.endEditing(true)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch: UITouch = touches.first! as UITouch
        if touch.view == self.dimView{
            resign()
            if(dropDownViewIsDisplayed){
                moveTeamTableView()
                hideDropDownView()
            }
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
        
        if sexPickerValue != "" && sexPickerValue != SharingManager.locale.all {
            filteredTeams = filteredTeams.filter({ (team) -> Bool in
                if(sexPickerValue == SharingManager.locale.male){
                    for matchclass in self.matchClasses!{
                        if team.matchClassId == matchclass.id{
                            return matchclass.gender == "M"
                        }
                    }
                }else if sexPickerValue == SharingManager.locale.female{
                    for matchclass in self.matchClasses!{
                        if team.matchClassId == matchclass.id{
                            return matchclass.gender == "F"
                        }
                    }
                }
                return false
            })
        }
        
        if countryPickerValue != "" && countryPickerValue != SharingManager.locale.all{
            filteredTeams = filteredTeams.filter({ (team) -> Bool in
                return team.countryCode == countryPickerValue
            })
        }
        
        if searchText != "" && searchText != SharingManager.locale.searchBoxPlaceholder {
            filteredTeams = filteredTeams.filter({ (team) -> Bool in
                let tmp: NSString = team.name!
                let range = tmp.rangeOfString(searchText!, options: NSStringCompareOptions.CaseInsensitiveSearch)
                return range.location != NSNotFound
            })
        }
       self.reloadIfDataIsLoaded()
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
        self.view.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.accessibilityIdentifier == "searchTextField"{
            (self.filterViewTest!).searchTextField.textColor = UIColor.blackColor()
            if (self.filterViewTest!).searchTextField.text! == SharingManager.locale.searchBoxPlaceholder {
                (self.filterViewTest!).searchTextField.text! = ""
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField.accessibilityIdentifier == "searchTextField"{
            if (self.filterViewTest!).searchTextField.text!.isEmpty {
                (self.filterViewTest!).searchTextField.text = SharingManager.locale.searchBoxPlaceholder
                (self.filterViewTest!).searchTextField.textColor = UIColor.grayColor()
            }
        }
    }
}