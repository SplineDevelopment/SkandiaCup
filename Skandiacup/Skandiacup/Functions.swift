//
//  Functions.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
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
}

struct Functions {
    static func getCurrentTimeInSeconds() -> Int {
        return Int(NSDate().timeIntervalSince1970)
    }
}
