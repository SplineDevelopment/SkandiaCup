//
//  MatchTable.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

struct MatchTable{
    static let maxCacheTime = 60 * 5
    var header: MatchTableRow?
    var rows: [MatchTableRow]?
}