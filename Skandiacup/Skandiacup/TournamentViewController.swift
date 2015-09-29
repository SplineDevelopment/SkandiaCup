//
//  SecondViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class TournamentViewController: UIViewController{
    @IBOutlet weak var teamsView: UIView!
    @IBOutlet weak var groupsView: UIView!

    
     func switchTable(index: Int) {
        switch index {
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

    func testingFunc<T : TeamsViewChangeProto>(t : T.Type) {
        self.childViewControllers.forEach({ (child) -> () in
            child.childViewControllers.forEach({ (child) -> () in
                if let tempController = child as? TeamsViewChangeProto {
                    tempController.updateFilterViewHeight()
                }
            })
        })
    }

   override func viewDidLoad() {
        super.viewDidLoad()
        print("COUNT \(self.childViewControllers.count)")
        teamsView.hidden = false
        groupsView.hidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}