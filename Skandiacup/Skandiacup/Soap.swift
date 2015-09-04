//
//  Soap.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

protocol Soap {
    func getArena(id: [Int], completionHandler: (arenas: [Arena]?) -> ())
    func getTournamentClub(id: [Int]) -> [TournamentClub]?
    func getField(id: [Int]) -> [Field]?
    func getMatchClass(id: [Int]) -> [MatchClass]?
    func getMatchGroup(id: [Int]) -> [MatchGroup]?
    func getMatches(completionHandler: (matches: [TournamentMatch]?) -> ())
}