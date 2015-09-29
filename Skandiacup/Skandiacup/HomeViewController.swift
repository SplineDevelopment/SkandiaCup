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
//            self.callViewChangedToChildController(NewsViewController)
        case 1:
            newsView.hidden = true
            infoView.hidden = false
            sosialView.hidden = true
            self.callViewChangedToChildController(InfoViewController)
        case 2:
            newsView.hidden = true
            infoView.hidden = true
            sosialView.hidden = false
            self.callViewChangedToChildController(SosialViewController)
        default:
            print("erroe")
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        switch segmentedControl.selectedSegmentIndex{
//        case 0:
//            self.callViewChangedToChildController(NewsViewController)
        case 1:
            self.callViewChangedToChildController(InfoViewController)
        case 2:
            self.callViewChangedToChildController(SosialViewController)
        default:
            print("erroe")
        }
    }
    
    func callViewChangedToChildController<T : SegmentChangeProto>(t : T.Type) {
        self.childViewControllers.forEach({ (child) -> () in
            if let tempController = child as? T {
                tempController.viewChangedTo()
            }
        })
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        infoView.hidden = true
        newsView.hidden = false
        sosialView.hidden = true
        self.tabBarController?.tabBar.barTintColor = UIColor(red: 41.0/255.0, green: 40.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        self.tabBarController?.tabBar.tintColor = UIColor(red:0.02, green:0.54, blue:0.02, alpha:1.0)
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
