//
//  EndPlayViewController.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import UIKit

class EndPlayViewController: UITableViewController{
    @IBOutlet var endPlayMatchClassTable: UITableView!
    var endPlayMatchClasses: [MatchClass]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadMatchClassses()
    }
    
    func loadMatchClassses(){
        SharingManager.data.getMatchClass { (matchclasses, error) -> () in
            if error {
                print("error getting match classes")
                let alertController = UIAlertController(title: SharingManager.locale.errorTitle, message:
                    SharingManager.locale.errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: SharingManager.locale.errorDismiss, style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
                // needs to be handled properly
            } else {
                self.endPlayMatchClasses = matchclasses
                var isEndplay = false
                self.endPlayMatchClasses = self.endPlayMatchClasses?.filter({ (matchclass) -> Bool in
                    matchclass.matchGroups!.forEach({ (matchgroup) -> () in
                        isEndplay = false
                        if Int(matchgroup.matchClassId!)! == matchclass.id && matchgroup.isPlayoff == true{
                            isEndplay = true
                        }
                    })
                    return isEndplay
                })
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.endPlayMatchClassTable.reloadData()
                })
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endPlayMatchClasses != nil ? endPlayMatchClasses!.count : 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MatchClassTable"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell!
        let textValue = endPlayMatchClasses?[indexPath.row].name
        
        cell.textLabel?.text = textValue
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "fromEndPlayMatchClassToEndPlayMatches") {
            if let indexPath = self.endPlayMatchClassTable.indexPathForSelectedRow{
                let selectedEndPlayMatchClass = endPlayMatchClasses?[indexPath.row]
                (segue.destinationViewController as! EndPlayGamesViewController).selectedMatchClass = selectedEndPlayMatchClass
            }
        }
    }
}

