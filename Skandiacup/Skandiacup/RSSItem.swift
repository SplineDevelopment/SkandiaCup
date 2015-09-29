//
//  RSSItem.swift
//  Skandiacup
//
//  Created by Borgar Lie on 29/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class RSSItem {
    var title: String?
    var pubDate : String?
    var category : String?
    var itemDescription : String?
    
    init() {
        title = "";
        pubDate = "";
        category = "";
        itemDescription = "";
    }
    
    init(title : String, pubDate : String, category : String, itemDescription : String) {
        self.title = title
        self.pubDate = pubDate
        self.category = category
        self.itemDescription = itemDescription
    }
}
