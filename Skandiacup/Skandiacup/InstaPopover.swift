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
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        BigImage.contentMode = UIViewContentMode.ScaleAspectFit
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            NSURLSession.sharedSession().dataTaskWithURL(self.toPass.urlProfilePicture!) { (data, response, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.profileImage.image = UIImage(data: data!)
                }
                }.resume()
        }
        
        let date_temp = NSDate(timeIntervalSince1970: NSTimeInterval(self.toPass.published!))
        let dataFormatter:NSDateFormatter = NSDateFormatter()
        dataFormatter.dateFormat = "dd MMMM YYYY"
        self.timestamp.text = dataFormatter.stringFromDate(date_temp)
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            NSURLSession.sharedSession().dataTaskWithURL(self.toPass.url!) { (data, response, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    self.BigImage.image = UIImage(data: data!)
                }
                }.resume()
        }
    }
    
}
