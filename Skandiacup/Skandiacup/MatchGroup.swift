//
//  MatchGroup.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

struct MatchGroup{
    static let maxCacheTime = 60 * 5
    var id: Int?
    var name: String?
    var matchClassId: String?
    var isPlayoff: Bool?
    var playOffId: String?
    var endGameLevel: Int?
}