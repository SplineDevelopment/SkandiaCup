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
            if (selectedMatch==nil){
                print("send tilbake til start med feilmeld")
            }
        }
    }
    
    @IBOutlet weak var flagOne: UILabel!
    
    @IBOutlet weak var scoreOne: UILabel!
    
    @IBOutlet weak var teamOne: UILabel!
    
    @IBOutlet weak var teamTwo: UILabel!
    
    @IBOutlet weak var scoreTwo: UILabel!
    
    @IBOutlet weak var flagTwo: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var kickoffTimeLabel: UILabel!
    
    @IBAction func btnPushed(sender: AnyObject) {
        
        flagOne.text = "🇳🇴"
        teamOne.text = "Rosenborg"
        scoreOne.text = "3"
        teamTwo.text = "Abugutha"
        scoreTwo.text = "2"
        flagTwo.text = "🇰🇲"

        flagOne.font = UIFont.systemFontOfSize(30)
        
        flagTwo.font = UIFont.systemFontOfSize(30)
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        // Do any additional setup after loading the view.
        //TODO find ut hva vi skal gjore
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView(){
        //flagOne.text = "🇳🇴"
        teamOne.text = selectedMatch?.homeTeamName
        scoreOne.text = selectedMatch?.homegoal
        teamTwo.text = selectedMatch?.awayTeamName
        scoreTwo.text = selectedMatch?.awaygoal
        //flagTwo.text = "🇰🇲"
        
        
        dateLabel.text = Date.getDateMatchView((selectedMatch?.matchDate)!)
        kickoffTimeLabel.text = Date.getKickoffTimeMatchView((selectedMatch?.matchDate)!)
        
        flagOne.font = UIFont.systemFontOfSize(30)
        
        flagTwo.font = UIFont.systemFontOfSize(30)

        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    

}
