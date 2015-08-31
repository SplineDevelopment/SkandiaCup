//
//  TableDataSource.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit
import UIKit


public class TableDataSource: NSObject, UITableViewDataSource {
    
//    var items: [AnyObject]
    var items = ["lag1", "lag2"]
    var cellIdentifier = "teamCell"
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel?.text = items[indexPath.row] as String
        
        return cell
    }
    
}