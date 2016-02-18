////
////  Config.swift
////  Skandiacup
////
////  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
////
//
//import Foundation
//import UIKit
//
//class Config{
//    static let soapMock = false //True = mock
//    static var appKeyTournamentID = ""
//    static let filterViewHeight:CGFloat = 133
//    static let teamCellHeight:CGFloat = 44
//    static let matchCellViewHeight:CGFloat = 124
//    static var tag_name = ""
//    static let client_id_insta = "7b9d2e2f9ef04d81939c7c61f381184e"
//    static let rss_info = "http://skandiacup.no/category/info/feed/"
//    static let rss_news = "http://skandiacup.no/category/nyheter/feed/"
//}

import Foundation
import UIKit
class Config : NSObject, NSCoding{
    let soapMock = false
    var appKeyTournamentID: String = ""
    let filterViewHeight:CGFloat = 133
    let teamCellHeight:CGFloat = 44
    let matchCellViewHeight:CGFloat = 124
    var tag_name: String = ""
    let client_id_insta = "7b9d2e2f9ef04d81939c7c61f381184e"
    let rss_info = "http://skandiacup.no/category/info/feed/"
    let rss_news = "http://skandiacup.no/category/nyheter/feed/"
    var lastdate: NSDate?
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        self.appKeyTournamentID = (decoder.decodeObjectForKey("ConfigAppkeyTournamentID") as? String)!
        self.tag_name = (decoder.decodeObjectForKey("ConfigTagName") as? String)!
        self.lastdate = (decoder.decodeObjectForKey("lastdate") as? NSDate)!
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.appKeyTournamentID, forKey: "ConfigAppkeyTournamentID")
        coder.encodeObject(self.tag_name, forKey: "ConfigTagName")
        coder.encodeObject(self.lastdate, forKey: "lastdate")
    }
}