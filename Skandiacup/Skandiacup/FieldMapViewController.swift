//
//  FieldMapViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 08/10/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class FieldMapViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        self.scrollView.minimumZoomScale = 1.0
    
        self.scrollView.maximumZoomScale = 6.0
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
