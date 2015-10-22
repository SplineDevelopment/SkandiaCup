//
//  FieldDiariesViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 15/10/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class FieldDiariesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var fieldTableview: UITableView!
    
    var fields: [Field]? {
        didSet {
                  (self.parentViewController?.parentViewController as! FieldOverviewViewController).activityIndicator.startAnimating()
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                (self.parentViewController?.parentViewController as! FieldOverviewViewController).activityIndicator.stopAnimating()
                self.fieldTableview.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        self.fieldTableview.delegate = self
        self.fieldTableview.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        SharingManager.data.getField(nil, fieldID: nil) { (fields, error) -> () in
            if error{
                print("Error in FieldDiariesViewController.viewWillAppear")
                let alertController = UIAlertController(title: "Error", message:
                    "Field data not available atm", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else{
                self.fields = fields
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
  
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = fieldTableview.dequeueReusableCellWithIdentifier("fieldCell") {
            if let field = fields?[indexPath.row] {
                cell.textLabel?.text = field.fieldName
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fields != nil ? fields!.count : 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fieldToFieldItem" {
            if let indexPath = self.fieldTableview.indexPathForSelectedRow{
                if let field = fields?[indexPath.row]{
                    (segue.destinationViewController as! FieldItemViewController).field = field
                }
            }
        }
    }
}
