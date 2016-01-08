//
//  MatchGroup.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
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