//
//  SosialViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 04/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class SosialViewController: UICollectionViewController, SegmentChangeProto {
    @IBOutlet var viewOutlet: UICollectionView!
    private let reuseIdentifier = "InstaCell"
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    private var insta_photos = [InstagramPhotoObject]()
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "cellSegueInstaPopover") {
            let svc = segue.destinationViewController as! InstaPopover
            let cell = sender as! InstaPhotoCell
            svc.toPass = cell.instaPhotoObject
            svc.instaPhotoTable = insta_photos
            svc.index = cell.index
        }
    }
    
    func viewChangedTo() {
        print("Changed to sosial view")

        // remove -> replace with timer
        if self.insta_photos.count > 0 {
            print("insta photos already initialized")
            return
        }
        
        // TODO::: remove list and replace? or something else?
        // need to be able to update based on a timer!
        
        print("Loading data from instagram")
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            SharingManager.data.getAllPhotoObjects() { (photoObjects, error) -> () in
                dispatch_async(dispatch_get_main_queue()) {
                    if error {
                        print("ERROR IN SOSIAL VIEW GETTING INSTA PHOTOS")
                        /*
                        let alertController = UIAlertController(title: "Error", message:
                            "Instagram not available atm", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        */
                        //let vc = self.storyboard?.instantiateViewControllerWithIdentifier("error_view") as! ErrorView
                        
                        //self.showViewController(vc as UIViewController, sender: vc)
                        //vc.error_label.text = "Instagram not available atm"
                    }
                    else {
                        self.insta_photos.appendContentsOf(photoObjects)
                        self.viewOutlet.reloadData()
                    }
                }
            }
        }
    }
    
}

extension SosialViewController {
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
        
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return insta_photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) ->UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as!InstaPhotoCell
        cell.backgroundColor = UIColor.whiteColor()
        if indexPath.item < insta_photos.count {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            cell.instaPhotoObject = self.insta_photos[indexPath.item]
            NSURLSession.sharedSession().dataTaskWithURL(self.insta_photos[indexPath.item].urlSmall!) { (data, response, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    cell.imageView.image = UIImage(data: data!)
                    cell.index = indexPath.item
                }
            }.resume()
        }
        }
        return cell
    }
}

extension SosialViewController {
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 85, height: 85)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}
