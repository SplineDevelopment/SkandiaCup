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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var matches: [TournamentMatch]?
    
    var field: Field?{
        didSet {
            configureView()
        }
    }
    @IBOutlet weak var errormessage: UILabel!
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
                print("matches count = \(self.matches?.count)")
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    self.fieldMatchTableView.reloadData()
                    if(self.matches?.count == 0){
                        self.fieldMatchTableView.hidden = true
                        self.errormessage.text = SharingManager.locale.emptyTableFieldDiaries
                    } else{
                        self.fieldMatchTableView.hidden = false
                    }
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        self.activityIndicator.hidden = false;
        self.activityIndicator.startAnimating();
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewDidLoad()
        self.fieldMatchTableView.delegate = self
        self.fieldMatchTableView.dataSource = self
        self.fieldMatchTableView.hidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        if let field = self.field{
            self.title = field.fieldName
        }
        if let row = self.fieldMatchTableView.indexPathForSelectedRow{
            self.fieldMatchTableView.deselectRowAtIndexPath(row, animated: false)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matches != nil ? self.matches!.count : 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.fieldMatchTableView.dequeueReusableCellWithIdentifier("fieldMatchCell") as! matchCellView!
        if let match = matches?[indexPath.row]{
        if let date = match.matchDate{
            cell.dateLabel.text = getDate(date)
            cell.timeLabel.text = getTime(date)
        }
        if match.endGameLevel == 0{
            if let home = match.homeTeamName{
                cell.homeTeamNameLabel.text = home
            }
            
            if let away = match.awayTeamName{
                cell.awayTeamNameLabel.text = away
            }
        }else{
            if let home = match.homeTeamText{
                cell.homeTeamNameLabel.text = home
            }
            
            if let away = match.awayTeamText{
                cell.awayTeamNameLabel.text = away
            }
        }
        cell.awayTeamGoalLabel.text = "-"
        cell.homeTeamGoalLabel.text = "-"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.userInteractionEnabled = true
        }
      return cell
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
    
    func getDate(dateString: String) ->String{
        var array = dateTimeConverter(dateString)
        return array[0]
    }
    
    func getTime(dateString: String) ->String{
        var array = dateTimeConverter(dateString)
        let time = array[1].substringWithRange(Range<String.Index>(start: array[1].startIndex, end: array[1].endIndex.advancedBy(-3)))
        return time
    }
    
    func dateTimeConverter(dateString: String) -> [String]{
        let dateTimeArr = dateString.characters.split{$0 == "T"}.map(String.init)
        return dateTimeArr
    }
    
}
