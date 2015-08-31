//
//  datasource2.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit


class Datasource2: NSObject, UITableViewDelegate, UITableViewDataSource{
    var teams = ["lag1", "lag2"]
    
    //datasource funcitons
    @objc func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    @objc func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->   UITableViewCell{
        //        let cell = UITableViewCell()
        //        let label = UILabel(frame: CGRect(x:0, y:0, width:200, height:50))
        //        label.text = classes[indexPath.row]
        //        cell.addSubview(label)
        let cell = tableView.dequeueReusableCellWithIdentifier("teamCell") as UITableViewCell!
        cell.textLabel?.text = teams[indexPath.row]
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
}
