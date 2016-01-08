//
//  MatchClass.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

struct MatchClass{
    static let maxCacheTime = 60 * 5
    var id: Int?
    var code: String?
    var name: String?
    var gender: String?
    var periodLengthInMinutes: String?
    var numberOfPeriodsInMatch: String?
    var matchGroups: [MatchGroup]?
}
