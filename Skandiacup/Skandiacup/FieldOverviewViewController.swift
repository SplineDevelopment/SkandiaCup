//
//  FieldOverviewViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 15/10/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class FieldOverviewViewController: UIViewController {
    
    
    @IBOutlet weak var fieldMapView: UIView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var fieldsDiariesView: UIView!
    @IBOutlet weak var fieldSegmentController: UISegmentedControl!
    

    @IBAction func fieldSegmentChanged(sender: AnyObject) {
        switch fieldSegmentController.selectedSegmentIndex{
        case 0:
            self.showFieldMap()
        case 1:
            self.showFieldDiaries()
        default: break
            //            print("erroe")
        }
    }
    
    func showFieldMap(){
        fieldMapView.hidden = false
        fieldsDiariesView.hidden = true
        
    }
    
    func showFieldDiaries(){
        fieldMapView.hidden = true
        fieldsDiariesView.hidden = false
        
    }

    
    override func viewDidLoad() {
        fieldMapView.hidden = false
        fieldsDiariesView.hidden = true
    }
    
    
    
    func callViewChangedToChildController<T : SegmentChangeProto>(t : T.Type) {
        self.childViewControllers.forEach({ (child) -> () in
            if let tempController = child as? T {
                tempController.viewChangedTo()
            }
        })
    }

}

