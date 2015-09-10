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
    
    @IBOutlet weak var scoreOne: UILabel!
    @IBOutlet weak var teamOne: UILabel!
    @IBOutlet weak var teamTwo: UILabel!
    @IBOutlet weak var scoreTwo: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var kickoffTimeLabel: UILabel!

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
                teamOne.text = selectedMatch?.homeTeamName
        scoreOne.text = selectedMatch?.homegoal
        teamTwo.text = selectedMatch?.awayTeamName
        scoreTwo.text = selectedMatch?.awaygoal
        print(selectedMatch?.fieldId)
        //fieldLabel.text = "Bane nummer: \(selectedMatch?.fieldId)"
        
        dateLabel.text = Date.getDateMatchView((selectedMatch?.matchDate)!)
        kickoffTimeLabel.text = Date.getKickoffTimeMatchView((selectedMatch?.matchDate)!)
    }
    
}
