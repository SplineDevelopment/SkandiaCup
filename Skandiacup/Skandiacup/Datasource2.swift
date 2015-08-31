//
//  datasource2.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation
import UIKit


class Datasource2: NSObject, UITableViewDataSource{
    var teams : [String]!
    
    override init(){
        teams = ["lag1", "lag2"]
    }
//    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
        cell.textLabel?.text = teams[indexPath.row]
        return cell
    }
}