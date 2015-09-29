//
//  RSS.swift
//  Skandiacup
//
//  Created by Borgar Lie on 29/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class RSS {
    private func sendReceive(request: NSMutableURLRequest, completionHandler: (responseData: NSData) -> Void) -> Void {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            completionHandler(responseData: data!)
        }
        task.resume()
    }
    
    func getRSSfeed(completionHandler: (RSSfeed: [RSSItem]) -> ()) {
        let uri = "http://skandiacup.no/?feed=rss"
        let req = NSMutableURLRequest(URL: NSURL(string: uri)!)
        self.sendReceive(req) { (responseData) -> Void in
            let xml = SWXMLHash.parse(responseData)
            let feed = RSSmapper.mapRSS(xml)
            completionHandler(RSSfeed: feed)
        }
    }
}



