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
        SharingManager.soap.getTournamentClub([7161221], countryCode: nil) { (clubs) -> () in
            print(clubs)
        }
        SharingManager.soap.getField(nil, fieldID: nil) { (fields) -> () in
            print(fields)
            print(fields.count)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

