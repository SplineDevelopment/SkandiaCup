//
//  Functions.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

struct Date{
    static func getCurrentTimeInSoapFormat() -> String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let stringValue = formatter.stringFromDate(date)
        return stringValue
    }
    
    static func getTimeInSoapFormat(time : Int) -> String {
        let date = NSDate(timeIntervalSince1970: NSTimeInterval(time))
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let stringValue = formatter.stringFromDate(date)
        return stringValue
    }
    
    static func getDateMatchView(stringDateFromProfixio:String) -> String {
        let newString = stringDateFromProfixio.stringByReplacingOccurrencesOfString("T", withString: "")
        
        let date = NSDate(dateString: newString)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        
        return formatter.stringFromDate(date)
        
    }
    
    static func getKickoffTimeMatchView(stringDateFromProfixio:String) -> String {
        let newString = stringDateFromProfixio.stringByReplacingOccurrencesOfString("T", withString: "")
        
        let date = NSDate(dateString: newString)
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        
        return formatter.stringFromDate(date)
        
    }

    
    
    
}

struct Functions {
    static func getCurrentTimeInSeconds() -> Int {
        return Int(NSDate().timeIntervalSince1970)
    }
}
