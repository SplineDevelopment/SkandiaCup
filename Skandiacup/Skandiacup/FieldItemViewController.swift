//
//  FieldItemViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 15/10/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class FieldItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var fieldMatchTableView: UITableView!
    var matches: [TournamentMatch]?
    
    var field: Field?{
        didSet {
            configureView()
        }
    }
    
    func configureView(){
        SharingManager.data.getMatches(nil, groupID: nil, teamID: nil, endplay: nil) { (matches, error) -> () in
            if error{
                print("Error in FieldItemViewController.field.didSet")
                let alertController = UIAlertController(title: "Error", message:
                    "Match data not available atm", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            } else{
                self.matches = matches
                self.matches = self.matches!.filter({ (match) -> Bool in
                    return match.homegoal == nil && match.fieldId == self.field?.fieldID
                })
                self.matches?.sortInPlace({$0.matchDate < $1.matchDate})
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.fieldMatchTableView.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fieldMatchTableView.delegate = self
        self.fieldMatchTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let field = self.field{
            self.title = field.fieldName
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matches != nil ? self.matches!.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = self.fieldMatchTableView.dequeueReusableCellWithIdentifier("fieldMatchCell"){
            if let match = matches?[indexPath.row]{
                if match.endGameLevel == 0{
                     cell.textLabel?.text = "\(Date.getDateMatchView(match.matchDate!)) - \(Date.getKickoffTimeMatchView(match.matchDate!)) - \(match.homeTeamName!) vs \(match.awayTeamName!)"
                }else{
                    cell.textLabel?.text = "\(Date.getDateMatchView(match.matchDate!)) - \(Date.getKickoffTimeMatchView(match.matchDate!)) - \(match.homeTeamText!) vs \(match.awayTeamText!)"
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "fieldMatchToMatchView" {
            if let indexPath = self.fieldMatchTableView.indexPathForSelectedRow{
                if let match = self.matches?[indexPath.row]{
                    (segue.destinationViewController as! MatchViewController).selectedMatch = match
                }
            }
        }
    }
}
