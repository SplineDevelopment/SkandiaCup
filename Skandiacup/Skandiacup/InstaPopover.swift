//
//  InstaPopover.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation
import UIKit

class InstaPopover : UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
        
    @IBOutlet weak var timestamp: UILabel!
    
    @IBOutlet weak var BigImage: UIImageView!
    @IBOutlet weak var pageControll: UIPageControl!

    
    @IBAction func cancelPopoverTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func cancelPopoverSwipe(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func toInstagram(sender: AnyObject) {
        if (UIApplication.sharedApplication().openURL(NSURL(string: "instagram://media?id=\(toPass.id!)")!)){
        } else {
            let alertController = UIAlertController(title: SharingManager.locale.openInInstagramErrorName , message:
                SharingManager.locale.openInInstagramErrorText, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }
        

    }
    var toPass : InstagramPhotoObject!
    var instaPhotoTable : [InstagramPhotoObject]!
    var index : Int!
    
    override func viewDidLoad() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Left) {
            var temp_index : Int
            if index == instaPhotoTable.count-1 {
                temp_index = 0
            }
            else {
                temp_index = index + 1
            }
            self.index = temp_index
            self.toPass = self.instaPhotoTable[temp_index]
            self.viewDidAppear(false)
        }
        
        if (sender.direction == .Right) {
            var temp_index : Int
            if index == 0 {
                temp_index = instaPhotoTable.count-1
            }
            else {
                temp_index = index - 1
            }
            self.index = temp_index
            self.toPass = self.instaPhotoTable[temp_index]
            self.viewDidAppear(false)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        pageControll.hidden = false
        pageControll.numberOfPages = instaPhotoTable.count
        pageControll.currentPage = self.index
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
