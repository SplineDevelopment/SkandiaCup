//
//  MatchViewController.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import UIKit

class MatchViewController: UIViewController {
    var selectedMatch: TournamentMatch?
    
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
        
        SharingManager.data.getField(nil, fieldID: selectedMatch!.fieldId) { (fields, error) -> () in
            if error {
                print("error getting fields")
                let alertController = UIAlertController(title: SharingManager.locale.errorTitle, message:
                    SharingManager.locale.errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: SharingManager.locale.errorDismiss, style: UIAlertActionStyle.Default,handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if fields.count > 0 {
                        self.fieldLabel.text = fields[0].fieldName
                    } else {
                        self.fieldLabel.text = "Unknown field"
                    }
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func configureView(){
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            if let text = self.selectedMatch?.homeTeamText{
                self.homeTeam.text = text;
            } else {
                self.homeTeam.text = self.selectedMatch?.homeTeamName;
            }
            
            if let text = self.selectedMatch?.awayTeamText{
                self.awayTeam.text = text;
            } else {
                self.awayTeam.text = self.selectedMatch?.awayTeamName;
            }
            
            self.homeScore.text = self.selectedMatch?.homegoal
            self.awayScore.text = self.selectedMatch?.awaygoal
            self.dateLabel.text = Date.getDateMatchView((self.selectedMatch?.matchDate)!)
            self.kickoffTimeLabel.text = Date.getKickoffTimeMatchView((self.selectedMatch?.matchDate)!)
            
            //Straff
            if (self.selectedMatch?.reason=="ST"){
                var winner = ""
                if (self.selectedMatch?.winner=="H"){
                    winner = (self.selectedMatch?.homeTeamName)!
                } else {
                    winner = (self.selectedMatch?.awayTeamName)!
                }
                
                self.reasonForWinLabel.text = "\(winner) \(SharingManager.locale.penaltyReason)"
                
            //walkover
            } else if (self.selectedMatch?.reason=="WO"){
                var winner = ""
                if (self.selectedMatch?.winner=="H"){
                    winner = (self.selectedMatch?.homeTeamName)!
                } else {
                    winner = (self.selectedMatch?.awayTeamName)!
                }
                self.reasonForWinLabel.text = "\(winner) \(SharingManager.locale.walkoverReason)"
                
            } else {
                self.reasonForWinLabel.text = ""
            }
        })
    }
}
