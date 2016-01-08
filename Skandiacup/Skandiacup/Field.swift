//
//  Field.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
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
