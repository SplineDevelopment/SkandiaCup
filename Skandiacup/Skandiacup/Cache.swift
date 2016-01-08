//
//  Cache.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

protocol Cache {
    func getArena(id: [Int]?) -> [Arena]
    func getTournamentClub(id: [Int]?, countryCode: String?) -> [TournamentClub]
    func getField(arenaID: Int?, fieldID: Int?) -> [Field]
    func getMatchClass(id: [Int]) -> [MatchClass]
    func getMatches(classID: Int?, groupID: Int?, teamID: Int?, endplay: Int?) -> [TournamentMatch]
    func getTeams(completionHandler: (teams : [TournamentTeam], error: Bool) -> ())
    
    func setArena(arenas : [Arena])
    func setTournamentClub(clubs : [TournamentClub])
    func setField(fields: [Field])
    func setMatchClass(matchClasses : [MatchClass])
    func setMatches(matches : [TournamentMatch])
    func setTeams(teams : [TournamentTeam])
}