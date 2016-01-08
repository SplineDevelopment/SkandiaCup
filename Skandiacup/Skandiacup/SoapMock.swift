//
//  SoapMock.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class SoapMock: Soap {
    func getArena(completionHandler: (arenas: [Arena], error: Bool) -> ()) {
        var arenaTab = [Arena]()
        arenaTab.append(Arena(arenaID: 1, arenaName: "Test1", arenaDescription: "Desc1", update_timestamp: "0"))
        arenaTab.append(Arena(arenaID: 2, arenaName: "Test2", arenaDescription: "Desc2", update_timestamp: "123"))
        arenaTab.append(Arena(arenaID: 3, arenaName: "Test3", arenaDescription: "Desc3", update_timestamp: "666"))
        arenaTab.append(Arena(arenaID: 4, arenaName: "Test4", arenaDescription: "Desc4", update_timestamp: "999"))
        completionHandler(arenas: arenaTab, error: false)
    }
    
    func getTournamentClub(completionHandler: (clubs: [TournamentClub], error: Bool) -> ()) {
        var clubTab = [TournamentClub]()
        clubTab.append(TournamentClub(id: 1, name: "Club1", countryCode: "NO"))
        clubTab.append(TournamentClub(id: 2, name: "Club2", countryCode: "NO"))
        clubTab.append(TournamentClub(id: 3, name: "Club3", countryCode: "NO"))
        completionHandler(clubs: clubTab, error: false)
    }
    
    func getField(arenaID: Int?, completionHandler: (fields: [Field], error: Bool) -> ()) {
        var field = [Field]()
        field.append(Field(fieldID: 1, arenaID: 1, fieldName: "Bane1", fieldDescription: "Bane1Nord", update_timestamp: ""))
        field.append(Field(fieldID: 2, arenaID: 1, fieldName: "Bane2", fieldDescription: "Bane2Nord", update_timestamp: ""))
        field.append(Field(fieldID: 3, arenaID: 1, fieldName: "Bane2", fieldDescription: "Bane3Nord", update_timestamp: ""))
        completionHandler(fields: field.filter({
            if arenaID != nil {
                return $0.arenaID == arenaID
            }
            return false
        }), error: false)
    }
        
    func getMatchClass(completionHandler: (matchclasses: [MatchClass], error: Bool) -> ()){
        var matchClass = [MatchClass]()
        matchClass.append(MatchClass(id: 1, code: "19", name: "Class 1", gender: "male", periodLengthInMinutes: "90", numberOfPeriodsInMatch: "2", matchGroups: getMatchGroup([1])));
        matchClass.append(MatchClass(id: 2, code: "15", name: "Class 2", gender: "male", periodLengthInMinutes: "90", numberOfPeriodsInMatch: "2", matchGroups: getMatchGroup([2])));
        matchClass.append(MatchClass(id: 3, code: "13", name: "Class 3", gender: "female", periodLengthInMinutes: "90", numberOfPeriodsInMatch: "2", matchGroups: getMatchGroup([3])));
        completionHandler(matchclasses: matchClass, error: false)
    }
    
    // not used (not in protocol)
    func getMatchGroup(id: [Int]) -> [MatchGroup]?{
        var matchGroup = [MatchGroup]()
        matchGroup.append(MatchGroup(id:1, name: "Gruppe1", matchClassId: "1", isPlayoff: true, playOffId: "1", endGameLevel: 1))
        matchGroup.append(MatchGroup(id:2, name: "Gruppe2", matchClassId: "2", isPlayoff: true, playOffId: "1", endGameLevel: 1))
        matchGroup.append(MatchGroup(id:3, name: "Gruppe3", matchClassId: "3", isPlayoff: true, playOffId: "1", endGameLevel: 1))
        return matchGroup
    }
    
    func getMatches(classID: Int?, groupID: Int?, endplay: Int?, completionHandler: (matches: [TournamentMatch], error: Bool) -> ()) {
        completionHandler(matches: [TournamentMatch](), error: true)
    }
    
    func getTeams(completionHandler: (teams: [TournamentTeam], error: Bool) -> ()){
        var tournamentTeams = [TournamentTeam]()
        /*
        tournamentTeams.append(TournamentTeam(id: 1, name: "Flint", clubId: 1, matchGroupId: 3, matchClassId: 3, tournamentTeamRegistrationId: 3, updateTimestamp: "nein", shirtColor: "Blå", countryCode: "NO"))
        tournamentTeams.append(TournamentTeam(id: 2, name: "HISSI", clubId: 4, matchGroupId: 3, matchClassId: 3, tournamentTeamRegistrationId: 3, updateTimestamp: "nein", shirtColor: "Blå", countryCode: "NO"))
        tournamentTeams.append(TournamentTeam(id: 3, name: "FKTonsberg", clubId: 1337, matchGroupId: 3, matchClassId: 3, tournamentTeamRegistrationId: 3, updateTimestamp: "nein", shirtColor: "Blå", countryCode: "NO"))
        tournamentTeams.append(TournamentTeam(id: 4, name: "Rosenborg", clubId: 8, matchGroupId: 3, matchClassId: 3, tournamentTeamRegistrationId: 3, updateTimestamp: "nein", shirtColor: "Blå", countryCode: "NO"))
        */
        for x in 1...900 {
            tournamentTeams.append(TournamentTeam(id: x, name: "Flint\(x)", clubId: x, matchGroupId: 3, matchClassId: 3, tournamentTeamRegistrationId: x, updateTimestamp: "nein", shirtColor: "Blå", countryCode: "NO"))
        }
        completionHandler(teams: tournamentTeams, error: false)
        
    }
    
    func getTable(groupID: Int?, playOffId: Int?, teamId: Int?, completionHandler: (tables: [MatchTable], error: Bool) -> ()) {
        completionHandler(tables: [MatchTable](), error: true)
    }
    
    func getTournamentMatchStatus(since: String, completionHandler: (status: TournamentMatchStatus, error: Bool) -> ()) {
        completionHandler(status: TournamentMatchStatus(), error: true)
    }
}


