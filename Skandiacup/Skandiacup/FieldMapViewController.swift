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
    
    @IBOutlet weak var rotateButton: UIButton!
    
    var lastrotation = 0
    
    @IBAction func rotateButtonPress(sender: AnyObject) {
        UIView.animateWithDuration(0.5, animations: {
            if self.lastrotation == 0 {
                self.lastrotation = 90
                self.imageView.transform = CGAffineTransformMakeRotation((270 * CGFloat(M_PI)) / 180.0)
            } else {
                self.lastrotation = 0
                self.imageView.transform = CGAffineTransformMakeRotation(0)
            }
        })
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        self.scrollView.minimumZoomScale = 1.0
    
        self.scrollView.maximumZoomScale = 6.0
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
        let pointInView = recognizer.locationInView(imageView)
        
        // 2
        var newZoomScale = scrollView.zoomScale * 2
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        // 3
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
}
