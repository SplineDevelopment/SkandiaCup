//
//  Field.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

struct Field{
    static let maxCacheTime = 60 * 60 * 24
    var fieldID: Int?
    var arenaID: Int?
    var fieldName: String?
    var fieldDescription: String?
    var update_timestamp: String?
}
