//
//  InfoViewController.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 04/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class InfoViewController: UITableViewController, SegmentChangeProto {
    
    @IBOutlet var infoTableView: UITableView!
    var feed: [RSSItem]?
    
    var view_is_loaded = false
    
    var RSS_timer = 0.0
    
    
    func viewChangedTo() {
        print("ViewChangedTo")
        if CACurrentMediaTime() > self.RSS_timer + 60 {
            SharingManager.rssfeed.getRSSfeed { (RSSfeed, error) -> () in
                if error {
                    print("Error loading RSS")
                    (self.parentViewController?.parentViewController as! HomeViewController).activityIndicator.stopAnimating()
                    let alertController = UIAlertController(title: "Error", message:
                        "RSS feed not available atm", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    // needs to be handled properly
                } else {
                    self.RSS_timer = CACurrentMediaTime()
                    self.feed = RSSfeed
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.infoTableView.reloadData()
                        if !self.view_is_loaded {
                            self.view_is_loaded = true
                            (self.parentViewController?.parentViewController as! HomeViewController).activityIndicator.stopAnimating()
                            (self.parentViewController?.parentViewController as! HomeViewController).infoView.hidden = false
                        }
                    })
                }
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("infoCell", forIndexPath: indexPath) as! InfoCellView
        
        let bodytext: NSAttributedString
        
        if let feed = self.feed{
            let item = feed[indexPath.row] as RSSItem
            cell.headerLabel.text = item.title
            do{
                bodytext =  try NSAttributedString(data: item.itemDescription!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                cell.bodyText.attributedText = bodytext
                cell.bodyText.font = UIFont (name: "Helvetica Neue", size: 12)
                cell.bodyText.textColor = UIColor.blackColor()
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } catch _ as NSError{
            }
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "infoToInfoItemSeque") {
            if let indexPath = self.infoTableView.indexPathForSelectedRow{
                let item = self.feed?[indexPath.row]
                (segue.destinationViewController as! InfoItemViewController).currentItem = item
            }
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let feed = self.feed
        {
            return feed.count
        }
        
        return 0
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.translucent = true
        infoTableView.backgroundColor = UIColor.clearColor()
        self.infoTableView.delegate = self
        self.infoTableView.dataSource = self
        
        
    }
    
}
