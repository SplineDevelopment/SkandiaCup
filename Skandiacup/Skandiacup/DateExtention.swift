//
//  DateExtention.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 07/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
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
