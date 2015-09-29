//
//  RSSmapper.swift
//  Skandiacup
//
//  Created by Borgar Lie on 29/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class RSSmapper {
    static func mapRSS(xml: XMLIndexer) -> [RSSItem] {
        var arr = [RSSItem]()
        for elem in xml["rss"]["channel"]["item"] {
            let r = RSSItem()
            if elem["title"].element?.text != nil {
                r.title = elem["title"].element?.text
            }
            if elem["pubDate"].element?.text != nil {
                r.pubDate = elem["pubDate"].element?.text
            }
            if elem["category"].element?.text != nil {
                r.category = elem["category"].element?.text
            }
            if elem["description"].element?.text != nil {
                r.itemDescription = elem["description"].element?.text
            }
            arr.append(r)
        }
        return arr
    }
}