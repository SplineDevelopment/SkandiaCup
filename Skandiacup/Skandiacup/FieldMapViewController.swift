//
//  FieldMapViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 08/10/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class FieldMapViewController: UIViewController, UIScrollViewDelegate {
    
    var isZoomedIn = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var rotateButton: UIButton!
    
    var rotationRecognizer: UIRotationGestureRecognizer!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.rotationRecognizer = UIRotationGestureRecognizer(target: self,
            action: "handleRotations:")
    }
    
    func handleRotations(sender: UIRotationGestureRecognizer){
        animate()
    }
    
    var rotated = false
    
    func animate() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            if !self.rotated {
                self.scrollView.transform = CGAffineTransformMakeRotation((270 * CGFloat(M_PI)) / 180.0)
            } else {
                self.scrollView.transform = CGAffineTransformMakeRotation((-270 * CGFloat(M_PI)) / 180.0)
            }
            }) { (Bool) -> Void in
                if !self.rotated {
                    self.scrollView.transform = CGAffineTransformMakeRotation((0 * CGFloat(M_PI)) / 180.0)
                    self.imageView.image = self.imageView.image?.imageRotatedByDegrees(270, flip: false)
                } else {
                    self.scrollView.transform = CGAffineTransformMakeRotation((0 * CGFloat(M_PI)) / 180.0)
                    self.imageView.image = self.imageView.image?.imageRotatedByDegrees(-270, flip: false)
                }
                self.rotated = !self.rotated
        }
    }
    
    @IBAction func rotateButtonPress(sender: AnyObject) {
        animate()
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        self.scrollView.minimumZoomScale = 1.0
        self.scrollView.maximumZoomScale = 6.0
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: "scrollViewDoubleTapped:")
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.numberOfTouchesRequired = 1
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        view.addGestureRecognizer(rotationRecognizer)
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        let pointInView = recognizer.locationInView(imageView)
        var newZoomScale = scrollView.zoomScale
        
        if (!isZoomedIn){
            newZoomScale = scrollView.zoomScale * 2
            isZoomedIn = true
        } else {
            newZoomScale = scrollView.zoomScale / 2
            isZoomedIn = false
        }
        
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)

        let rectToZoomTo = CGRectMake(x, y, w, h);
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
}
