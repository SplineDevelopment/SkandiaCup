//
//  RSS.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
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
    
    func getRSSfeed(uri:String, completionHandler: (RSSfeed: [RSSItem], error: Bool) -> ()) {
        //let uri = "http://skandiacup.no/category/nyheter/feed/"
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



