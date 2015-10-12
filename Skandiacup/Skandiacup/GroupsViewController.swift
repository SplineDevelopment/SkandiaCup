//
//  GroupViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
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
        print("VIEWDIDLOADDDDD")
        super.viewDidLoad()
        groupTableView.dataSource = self
        groupTableView.delegate = self
//        segmentController.selectedSegmentIndex = 1
        SharingManager.data.getMatchClass { (matchclasses) -> () in
            self.groups = matchclasses
        }
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func indexChanged(sender: AnyObject) {
                (self.parentViewController?.parentViewController as! TournamentViewController).switchTable(segmentController.selectedSegmentIndex)
//        self.viewDidLoad()
        segmentController.selectedSegmentIndex = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("groupCell") as UITableViewCell!
        cell.textLabel?.text = groups![indexPath.row].name
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

    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //
    //    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups != nil ? groups!.count : 0
    }
    
    func changeSegment(){
//        self.segmentController.selectedSegmentIndex = 1
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
    
 
    
}
