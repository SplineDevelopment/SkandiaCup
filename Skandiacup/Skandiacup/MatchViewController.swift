//
//  SecondViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class MatchViewController: UIViewController{
    @IBOutlet weak var segmentControl: UISegmentedControl!
//    @IBOutlet weak var teamView: UIView!
    @IBOutlet weak var groupView2: UIView!
    @IBOutlet weak var teamView2: UIView!
//    @IBOutlet weak var groupView: UIView!
    
    @IBAction func indexChanged(sender: AnyObject) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            teamView2.hidden = false
            groupView2.hidden = true
        case 1:
            teamView2.hidden = true
            groupView2.hidden = false
        default:
            break;
        }
        
    }
    
   override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

