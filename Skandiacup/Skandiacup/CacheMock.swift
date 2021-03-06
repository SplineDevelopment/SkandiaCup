//
//  CacheMock.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
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
    func getMatches(classID: Int?, groupID: Int?, teamID: Int?, endplay: Int?) -> [TournamentMatch] {
        return [TournamentMatch]()
    }
    func getTeams(completionHandler: (teams : [TournamentTeam], error: Bool) -> ()) {
        completionHandler(teams: [TournamentTeam](), error: true)
    }
    
    func setArena(arenas : [Arena]) {
        
    }
    func setTournamentClub(clubs : [TournamentClub]) {
        
    }
    func setField(fields: [Field]) {
        
    }
    func setMatchClass(matchClasses : [MatchClass]) {
        
    }
    func setMatches(matches : [TournamentMatch]) {
        
    }
    func setTeams(teams : [TournamentTeam]) {
        
    }
}