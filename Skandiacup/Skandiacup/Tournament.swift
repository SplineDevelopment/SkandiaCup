//
//  Tournament.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

struct Tournament{
    static let maxCacheTime = 60 * 60 * 24
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