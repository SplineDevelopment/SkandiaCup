//
//  Tournament.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

struct Tournament{
    static let maxCacheTime = 60 * 60 * 24 * 2
    var id: Int?
    var tournamentName: String?
    var tournamentShortName: String?
    var tournamentClub: String?
    var tournamentURL: String?
    var startDate: String?
    var endDate: String?
    var countryCode: String?
    var accessLevel: Int?
    var updateTimestamp: String
}