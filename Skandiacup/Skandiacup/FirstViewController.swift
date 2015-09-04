//
//  FirstViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // TESTING 
        SharingManager.soap.getArena([1,2,182256]) { (arenas) -> () in
            print(arenas)
        }
        SharingManager.soap.getArena(nil) { (arenas) -> () in
            print(arenas)
        }
        SharingManager.soap.getMatches(nil, groupID: 3001448, teamID: 14084631) { (matches) -> () in
            //print(matches)
            print(matches.count)
        }
        SharingManager.soap.getTournamentClub(nil, countryCode: nil) { (clubs) -> () in
            print(clubs)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

