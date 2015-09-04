//
//  HomeViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var newsView: UIView!
    @IBOutlet weak var sosialView: UIView!

    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex{
        case 0:
            newsView.hidden = false
            infoView.hidden = true
            sosialView.hidden = true
        case 1:
            print("1")
            newsView.hidden = true
            infoView.hidden = false
            sosialView.hidden = true

        case 2:
            newsView.hidden = true
            infoView.hidden = true
            sosialView.hidden = false

        
        default:
            print("erroe")
        }
        
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.hidden = true
        newsView.hidden = false
        sosialView.hidden = true
        
        // Do any additional setup after loading the view.
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