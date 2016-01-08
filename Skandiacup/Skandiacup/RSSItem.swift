//
//  RSSItem.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
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
