//
//  NewsViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 29/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var feed: [RSSItem]?
    
    var view_is_loaded = false
    
    var RSS_timer = 0.0

    @IBOutlet var newTableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        
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
                        self.newTableView.reloadData()
                        if !self.view_is_loaded {
                            self.view_is_loaded = true
                            (self.parentViewController?.parentViewController as! HomeViewController).activityIndicator.stopAnimating()
                            (self.parentViewController?.parentViewController as! HomeViewController).newsView.hidden = false
                        }
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.translucent = true
        newTableView.backgroundColor = UIColor.clearColor()
        //HomeViewController.activityIndicator.stopAnitmation()
        self.newTableView.delegate = self
        self.newTableView.dataSource = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let feed = self.feed
        {
            return feed.count
        }
        
        return 0

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("newsCell", forIndexPath: indexPath) as! newsCellView
        let bodytext: NSAttributedString
        
        if let feed = self.feed{
            let item = feed[indexPath.row] as RSSItem
            cell.headerLabel.text = item.title
            //cell.headerLabel.font = UIFont(
            
            do{
                bodytext =  try NSAttributedString(data: item.itemDescription!.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!, options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                cell.bodyText.attributedText = bodytext
                cell.bodyText.font = UIFont (name: "Helvetica Neue", size: 12)
                //cell.bodyText.font = UIFont (name: "Adelle sans", size: 12)
                cell.bodyText.textColor = UIColor.blackColor()
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            } catch _ as NSError{
            }
        }
        
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
                self.navigationController?.navigationBarHidden = true
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "newsToNewsItemSegue") {
            if let indexPath = self.newTableView.indexPathForSelectedRow{
                let item = self.feed?[indexPath.row]
                (segue.destinationViewController as! NewsItemViewController).currentItem = item
            }
        }
        
    }
}