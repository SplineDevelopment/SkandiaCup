//
//  SecondViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class TournamentViewController: UIViewController{
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var teamsView: UIView!
    @IBOutlet weak var groupsView: UIView!

    
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            teamsView.hidden = false
            groupsView.hidden = true
        case 1:
            teamsView.hidden = true
            groupsView.hidden = false
        default:
            break;
        }
        
    }
    
   override func viewDidLoad() {
        super.viewDidLoad()
        teamsView.hidden = false
        groupsView.hidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

