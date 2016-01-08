//
//  GroupViewController.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import UIKit

class GroupsViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var groupTableView: UITableView!
    var groups: [MatchClass]? {
        didSet{
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.groupTableView.reloadData()
            }
        }
    }
    @IBOutlet weak var segmentController: UISegmentedControl!
    
    override func viewDidLoad() {
        self.segmentController.selectedSegmentIndex = 1
        super.viewDidLoad()
        groupTableView.dataSource = self
        groupTableView.delegate = self
        SharingManager.data.getMatchClass { (matchclasses, error) -> () in
            if error {
                print("error getting matchclasses")
                if !(self.parentViewController?.parentViewController as! TournamentViewController).groupsView.hidden {
                    let alertController = UIAlertController(title: "Error", message:
                        "Group data not available atm", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            } else {
                self.groups = matchclasses
            }
        }
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
                (self.parentViewController?.parentViewController as! TournamentViewController).switchTable(segmentController.selectedSegmentIndex)
        segmentController.selectedSegmentIndex = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupCell") as UITableViewCell!
        cell.textLabel?.text = groups![indexPath.row].name
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "groupsViewToGroupView") {
            if let indexPath = self.groupTableView.indexPathForSelectedRow{
                let selectedGroup = groups![indexPath.row]
                (segue.destinationViewController as! GroupViewController).currentGroup = selectedGroup

            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups != nil ? groups!.count : 0
    }
}
