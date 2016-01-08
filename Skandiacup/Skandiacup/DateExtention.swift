//
//  DateExtention.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
        
        let d = dateStringFormatter.dateFromString(dateString)!
        
        self.init(timeInterval:0, sinceDate:d)
    }
}
