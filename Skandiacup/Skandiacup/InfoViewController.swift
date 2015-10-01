//
//  InfoViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 04/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, SegmentChangeProto {
    func viewChangedTo() {
        print("Changed to info view")
        let since = "2015-09-3 09:00:00"
        /*
        SharingManager.soap.getTournamentMatchStatus(since) { (status) -> () in
            print("testing -- after xml --")
            print("\nneedTotalRefresh: \(status.needTotalRefresh)")
            print("existsNewOrUpdatedMatches: \(status.existsNewOrUpdatedMatches)\n")
            SharingManager.soap.getTournamentClub(nil, countryCode: nil, completionHandler: { (clubs) -> () in
                for e in clubs {
                    print(e)
                }
            })
        }
        */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
