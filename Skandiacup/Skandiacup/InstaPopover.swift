//
//  InstaPopover.swift
//  Skandiacup
//
//  Created by Borgar Lie on 24/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation
import UIKit

class InstaPopover : UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var timestamp: UILabel!
    
    @IBOutlet weak var BigImage: UIImageView!
    
    @IBAction func cancelPopoverTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    var toPass : InstagramPhotoObject!
    
    override func viewDidAppear(animated: Bool) {
        self.userName.text = self.toPass.user
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            NSURLSession.sharedSession().dataTaskWithURL(self.toPass.urlProfilePicture!) { (data, response, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.profileImage.image = UIImage(data: data!)
                }
                }.resume()
        }
        
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(self.toPass.published!))
        self.timestamp.text = String(date)
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            NSURLSession.sharedSession().dataTaskWithURL(self.toPass.url!) { (data, response, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.BigImage.image = UIImage(data: data!)
                }
                }.resume()
        }
    }
    
}
