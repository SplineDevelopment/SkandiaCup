//
//  FavoritesViewController.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var favoriteTableView: UITableView!
    var favorites: [String] = ["Lag1", "Lag2", "Lag3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        var xmlToParse = "<root><catalog><book><author>Bob</author></book><book><author>John</author></book><book><author>Mark</author></book><catalog></root>"
        
        var arenastring = "<SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/' xmlns:ns1='http://profixio.com/soap/tournament/ForTournamentExt.php'><SOAP-ENV:Body><ns1:getArenasResponse><getArenasResult><item><arenaID>1111111</arenaID><arenaName></arenaName><arenaDescription></arenaDescription><update_timestamp>2015-09-01 10:16:02</update_timestamp></item><item><arenaID>22222</arenaID><arenaName></arenaName><arenaDescription></arenaDescription><update_timestamp>2015-09-01 10:16:02</update_timestamp></item><item><arenaID>182256</arenaID><arenaName></arenaName><arenaDescription></arenaDescription><update_timestamp>2015-09-01 10:16:02</update_timestamp></item></getArenasResult></ns1:getArenasResponse></SOAP-ENV:Body></SOAP-ENV:Envelope>"
        
        let xml = SWXMLHash.config {
            config in
            // set any config options here
            }.parse(arenastring)
        
//        print(xml["root"]["catalog"]["book"][1]["author"].element?.text)
        print(xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getArenasResponse"]["getArenasResult"]["item"][1])
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("favoriteCell") as UITableViewCell!
        cell.textLabel?.text = favorites[indexPath.row]
        return cell
    }
    
    //    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //
    //    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
