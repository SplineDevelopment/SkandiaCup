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
    
    @IBOutlet weak var flagOne: UILabel!
    @IBOutlet weak var scoreOne: UILabel!
    @IBOutlet weak var teamOne: UILabel!
    @IBOutlet weak var teamTwo: UILabel!
    @IBOutlet weak var scoreTwo: UILabel!
    @IBOutlet weak var flagTwo: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var kickoffTimeLabel: UILabel!
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var fieldImage: UIImageView!
    var imageFullscreen = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        
        let imageView = fieldImage
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureView(){
        flagOne.text = "🇳🇴"
        teamOne.text = selectedMatch?.homeTeamName
        scoreOne.text = selectedMatch?.homegoal
        teamTwo.text = selectedMatch?.awayTeamName
        scoreTwo.text = selectedMatch?.awaygoal
        flagTwo.text = "🇳🇴"
        print(selectedMatch?.fieldId)
        fieldLabel.text = "Bane nummer: \(selectedMatch?.fieldId)"
        
        dateLabel.text = Date.getDateMatchView((selectedMatch?.matchDate)!)
        kickoffTimeLabel.text = Date.getKickoffTimeMatchView((selectedMatch?.matchDate)!)
        
        flagOne.font = UIFont.systemFontOfSize(30)
        
        flagTwo.font = UIFont.systemFontOfSize(30)

        

    }
    func imageTapped(img: AnyObject){
        if (!imageFullscreen){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        fieldImage.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
            imageFullscreen = true;
        } else {
            print("make image small")
            
        }
    }
    
    
    

}
