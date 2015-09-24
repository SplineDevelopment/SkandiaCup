//
//  SosialViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 04/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class SosialViewController: UICollectionViewController {
    @IBOutlet var viewOutlet: UICollectionView!
    private let reuseIdentifier = "InstaCell";
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    private var insta_photos = [InstagramPhotoObject]()
    
    override func viewDidLoad() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            SharingManager.data.getAllPhotoObjects() { (photoObjects) -> () in
                dispatch_async(dispatch_get_main_queue()) {
                    //print(photoObjects)
                    self.insta_photos.appendContentsOf(photoObjects)
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        /*
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            SharingManager.data.getAllPhotoObjects() { (photoObjects) -> () in
                dispatch_async(dispatch_get_main_queue()) {
                    //print(photoObjects)
                    self.insta_photos.appendContentsOf(photoObjects)
                }
            }
        }
        */
        // TODO::: wipe cells first?
        self.viewOutlet.reloadData()
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
            NSURLSession.sharedSession().dataTaskWithURL(self.insta_photos[indexPath.item].url!) { (data, response, error) in
                dispatch_async(dispatch_get_main_queue()) {
                    cell.imageView.image = UIImage(data: data!)
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
