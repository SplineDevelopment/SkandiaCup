//
//  RSS.swift
//  Skandiacup
//
//  Created by Borgar Lie on 29/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class RSS {
    private func sendReceive(request: NSMutableURLRequest, completionHandler: (responseData: NSData?, error: Bool) -> Void) -> Void {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error=\(error)")
                completionHandler(responseData: nil, error: true)
                return
            }
            completionHandler(responseData: data!, error: false)
        }
        task.resume()
    }
    
    func getRSSfeed(completionHandler: (RSSfeed: [RSSItem], error: Bool) -> ()) {
        let uri = "http://skandiacup.no/?feed=rss"
        let req = NSMutableURLRequest(URL: NSURL(string: uri)!)
        self.sendReceive(req) { (responseData, responseError) -> Void in
            if responseError || responseData == nil {
                completionHandler(RSSfeed: [RSSItem](), error: true)
                return
            }
            let xml = SWXMLHash.parse(responseData!)
            let feed = RSSmapper.mapRSS(xml)
            completionHandler(RSSfeed: feed, error: false)
        }
    }
}



