//
//  Soap.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

protocol Soap {
    func getArena(id: [Int]?, completionHandler: (arenas: [Arena]) -> ())
    func getTournamentClub(id: [Int]?, countryCode: String?, completionHandler: (clubs: [TournamentClub]) -> ())
    func getField(arenaID: Int?, fieldID: Int?, completionHandler: (fields: [Field]) -> ())
    func getMatchClass(completionHandler: (matchclasses: [MatchClass]) -> ())
    func getMatches(classID: Int?, groupID: Int?, teamID: Int?, endplay: Int?, completionHandler: (matches: [TournamentMatch]) -> ())
    func getTeams(completionHandler: (teams: [TournamentTeam]) -> ())
    func getTable(groupID: Int?, playOffId: Int?, teamId: Int?, completionHandler: (tables: [MatchTable]) -> ())
    func getTournamentMatchStatus(since: String, completionHandler: (status: TournamentMatchStatus) -> ())
}