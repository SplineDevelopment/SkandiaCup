//
//  MatchTable.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

struct MatchTable{
    static let maxCacheTime = 60 * 60 * 4
    var header: MatchTableRow?
    var rows: [MatchTableRow]?
}