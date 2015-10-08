//
//  CacheMock.swift
//  Skandiacup
//
//  Created by Borgar Lie on 07/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class CacheMock : Cache {
    func getArena(id: [Int]?) -> [Arena] {
        return [Arena]()
    }
    func getTournamentClub(id: [Int]?, countryCode: String?) -> [TournamentClub] {
        return [TournamentClub]()
    }
    func getField(arenaID: Int?, fieldID: Int?) -> [Field] {
        return [Field]()
    }
    func getMatchClass(id: [Int]) -> [MatchClass] {
        return [MatchClass]()
    }
    func getMatchGroup(id: [Int]) -> [MatchGroup] {
        return [MatchGroup]()
    }
    func getMatches(classID: Int?, groupID: Int?, teamID: Int?) -> [TournamentMatch] {
        return [TournamentMatch]()
    }
    func getTeams(completionHandler: (teams : [TournamentTeam]) -> ()) {
        completionHandler(teams: [TournamentTeam]())
    }
    
    func setArena(arenas : [Arena]) {
        
    }
    func setTournamentClub(clubs : [TournamentClub]) {
        
    }
    func setField(fields: [Field]) {
        
    }
    func setMatchClass(matchClasses : [MatchClass]) {
        
    }
    func setMatchGroup(matchGroups : [MatchGroup]) {
        
    }
    func setMatches(matches : [TournamentMatch]) {
        
    }
    func setTeams(teams : [TournamentTeam]) {
        
    }
}