//
//  MatchViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 04/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController {
    var selectedMatch: TournamentMatch? {
        didSet{
            //TODO
            if (selectedMatch==nil){
                print("send tilbake til start med feilmeld")
            }
        }
    }
    
    @IBOutlet weak var reasonForWinLabel: UILabel!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var homeTeam: UILabel!
    @IBOutlet weak var awayTeam: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var kickoffTimeLabel: UILabel!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var imageFullscreen = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView(){
        homeTeam.text = selectedMatch?.homeTeamName
        homeScore.text = selectedMatch?.homegoal
        awayTeam.text = selectedMatch?.awayTeamName
        awayScore.text = selectedMatch?.awaygoal
        //fieldLabel.text = String(selectedMatch!.fieldId)
        SharingManager.data.getField(nil, fieldID: selectedMatch!.fieldId) { (fields, error) -> () in
            if error {
                print("error getting fields")
                let alertController = UIAlertController(title: "Error", message:
                    "Field data not available atm", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                // needs to be handled properly
            } else {
                // check for count here? fields can be empty with no error
                // testing needed?
                if fields.count > 0 {
                    self.fieldLabel.text = fields[0].fieldName
                } else {
                    self.fieldLabel.text = "Unknown field"
                }
            }
        }
        print(selectedMatch?.fieldId)
        //fieldLabel.text = "Bane nummer: \(selectedMatch?.fieldId)"
        
        dateLabel.text = Date.getDateMatchView((selectedMatch?.matchDate)!)
        kickoffTimeLabel.text = Date.getKickoffTimeMatchView((selectedMatch?.matchDate)!)
        
        
        //Straff
        if (selectedMatch?.reason=="ST"){
            var winner = ""
            if (selectedMatch?.winner=="H"){
                winner = (selectedMatch?.homeTeamName)!
            } else {
                winner = (selectedMatch?.awayTeamName)!
            }
            
            reasonForWinLabel.text = "\(winner) vant etter straffesparkkonkurranse"

        //walkover
        } else if (selectedMatch?.reason=="WO"){
            var winner = ""
            if (selectedMatch?.winner=="H"){
               winner = (selectedMatch?.homeTeamName)!
            } else {
                winner = (selectedMatch?.awayTeamName)!
            }
            reasonForWinLabel.text = "\(winner) vant på walkover"
            
        } else {
            reasonForWinLabel.text = ""        
        }
    }
}
