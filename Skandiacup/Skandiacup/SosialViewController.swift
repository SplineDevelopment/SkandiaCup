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
    private let sectionInsets = UIEdgeInsets(top: 0.0, left: 11.0, bottom: 0.0, right: 0.0)
    private var insta_photos = [InstagramPhotoObject]()
    
    var insta_timer = 0.0
    
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
        // 2 min timer
        if CACurrentMediaTime() < self.insta_timer + (60*2) {
//            print("insta photos already initialized")
            return
        }
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            SharingManager.data.getAllPhotoObjects() { (photoObjects, error) -> () in
                dispatch_async(dispatch_get_main_queue()) {
                    if error {
                        print("ERROR IN SOSIAL VIEW GETTING INSTA PHOTOS")
                        
                        let alertController = UIAlertController(title: "Error", message:
                            "Instagram not available atm", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)

                        //let vc = self.storyboard?.instantiateViewControllerWithIdentifier("error_view") as! ErrorView
                        
                        //self.showViewController(vc as UIViewController, sender: vc)
                        //vc.error_label.text = "Instagram not available atm"
                    }
                    else {
                        self.insta_timer = CACurrentMediaTime()
                        self.insta_photos = photoObjects
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
                    cell.imageView.contentMode = .ScaleAspectFill
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
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let width = screenSize.width * 0.28
            // 85
            return CGSize(width: width, height: width)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}

class CustomViewFlowLayout : UICollectionViewFlowLayout {
    let cellSpacing:CGFloat = 5
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if let attributes = super.layoutAttributesForElementsInRect(rect) {
            for (index, attribute) in attributes.enumerate() {
                if index == 0 { continue }
                let prevLayoutAttributes = attributes[index - 1]
                let origin = CGRectGetMaxX(prevLayoutAttributes.frame)
                if(origin + cellSpacing + attribute.frame.size.width < self.collectionViewContentSize().width) {
                    attribute.frame.origin.x = origin + cellSpacing
                }
            }
            return attributes
        }
        return nil
    }
}
