//
//  Soap.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

protocol Soap {
    func getArena(completionHandler: (arenas: [Arena], error: Bool) -> ())
    func getTournamentClub(completionHandler: (clubs: [TournamentClub], error: Bool) -> ())
    func getField(arenaID: Int?, completionHandler: (fields: [Field], error: Bool) -> ())
    func getMatchClass(completionHandler: (matchclasses: [MatchClass], error: Bool) -> ())
    func getMatches(classID: Int?, groupID: Int?, endplay: Int?, completionHandler: (matches: [TournamentMatch], error: Bool) -> ())
    func getTeams(completionHandler: (teams: [TournamentTeam], error: Bool) -> ())
    func getTable(groupID: Int?, playOffId: Int?, teamId: Int?, completionHandler: (tables: [MatchTable], error: Bool) -> ())
    func getTournamentMatchStatus(since: String, completionHandler: (status: TournamentMatchStatus, error: Bool) -> ())
}