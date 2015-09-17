//
//  SoapMock.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class SoapMock: Soap {
    func getArena(id: [Int]?, completionHandler: (arenas: [Arena]) -> ()) {
        var arenaTab = [Arena]()
        arenaTab.append(Arena(arenaID: 1, arenaName: "Test1", arenaDescription: "Desc1", update_timestamp: "0"))
        arenaTab.append(Arena(arenaID: 2, arenaName: "Test2", arenaDescription: "Desc2", update_timestamp: "123"))
        arenaTab.append(Arena(arenaID: 3, arenaName: "Test3", arenaDescription: "Desc3", update_timestamp: "666"))
        arenaTab.append(Arena(arenaID: 4, arenaName: "Test4", arenaDescription: "Desc4", update_timestamp: "999"))
        completionHandler(arenas: id != nil ? arenaTab.filter({id!.contains($0.arenaID!)}) : arenaTab)
    }
    
    func getTournamentClub(id: [Int]?, countryCode: String?, completionHandler: (clubs: [TournamentClub]) -> ()) {
        var clubTab = [TournamentClub]()
        clubTab.append(TournamentClub(id: 1, name: "Club1", countryCode: "NO"))
        clubTab.append(TournamentClub(id: 2, name: "Club2", countryCode: "NO"))
        clubTab.append(TournamentClub(id: 3, name: "Club3", countryCode: "NO"))
        if id != nil {
            completionHandler(clubs: clubTab.filter({
                $0.id != nil ? id!.contains($0.id!) : false
            }))
        }
        else if countryCode != nil {
            completionHandler(clubs: clubTab.filter({$0.countryCode == countryCode}))
        }
        else {
            completionHandler(clubs: clubTab)
        }
    }
    
    func getField(arenaID: Int?, fieldID: Int?, completionHandler: (fields: [Field]) -> ()) {
        var field = [Field]()
        field.append(Field(fieldID: 1, arenaID: 1, fieldName: "Bane1", fieldDescription: "Bane1Nord", update_timestamp: ""))
        field.append(Field(fieldID: 2, arenaID: 1, fieldName: "Bane2", fieldDescription: "Bane2Nord", update_timestamp: ""))
        field.append(Field(fieldID: 3, arenaID: 1, fieldName: "Bane2", fieldDescription: "Bane3Nord", update_timestamp: ""))
        completionHandler(fields: field.filter({
            if arenaID != nil && fieldID != nil {
                return $0.arenaID == arenaID && $0.fieldID == fieldID
            }
            if arenaID != nil {
                return $0.arenaID == arenaID
            }
            if fieldID != nil {
                return $0.fieldID == fieldID
            }
            return false
        }))
    }
        
    func getMatchClass(id: [Int]) -> [MatchClass]?{
        var matchClass = [MatchClass]()
        
        matchClass.append(MatchClass(id: 1, code: "19", gender: "male", periodLengthInMinutes: "90", numberOfPeriodsInMatch: "2", matchGroups: getMatchGroup([1])));
        matchClass.append(MatchClass(id: 2, code: "15", gender: "male", periodLengthInMinutes: "90", numberOfPeriodsInMatch: "2", matchGroups: getMatchGroup([2])));
        matchClass.append(MatchClass(id: 3, code: "13", gender: "female", periodLengthInMinutes: "90", numberOfPeriodsInMatch: "2", matchGroups: getMatchGroup([3])));
        return matchClass
    }
    
    func getMatchGroup(id: [Int]) -> [MatchGroup]?{
        var matchGroup = [MatchGroup]()
        matchGroup.append(MatchGroup(id:1, name: "Gruppe1", matchClassId: "1", isPlayoff: true, playOffId: "1", endGameLevel: 1))
        matchGroup.append(MatchGroup(id:2, name: "Gruppe2", matchClassId: "2", isPlayoff: true, playOffId: "1", endGameLevel: 1))
        matchGroup.append(MatchGroup(id:3, name: "Gruppe3", matchClassId: "3", isPlayoff: true, playOffId: "1", endGameLevel: 1))
        return matchGroup
    }

    func getMatches(completionHandler: (matches: [TournamentMatch]) -> ()) {
        //completionHandler(matches: nil)
    }
    
    func getMatches(classID: Int?, groupID: Int?, teamID: Int?, completionHandler: (matches: [TournamentMatch]) -> ()) {
        
    }
    
    func getTeams(id: [Int]?, completionHandler: (teams: [TournamentTeam]) -> ()){
        var tournamentTeams = [TournamentTeam]()
        //tournamentTeams.append(TournamentTeam(id: 1, name: "Flint", clubId: 1, matchGroupId: 3, matchClassId: 3, tournamentTeamRegistrationId: 3, updateTimestamp: "nein", shirtColor: "Blå", countryCode: "NO"))
        //tournamentTeams.append(TournamentTeam(id: 2, name: "HISSI", clubId: 4, matchGroupId: 3, matchClassId: 3, tournamentTeamRegistrationId: 3, updateTimestamp: "nein", shirtColor: "Blå", countryCode: "NO"))
        //tournamentTeams.append(TournamentTeam(id: 3, name: "FKTonsberg", clubId: 1337, matchGroupId: 3, matchClassId: 3, tournamentTeamRegistrationId: 3, updateTimestamp: "nein", shirtColor: "Blå", countryCode: "NO"))
        //tournamentTeams.append(TournamentTeam(id: 4, name: "Rosenborg", clubId: 8, matchGroupId: 3, matchClassId: 3, tournamentTeamRegistrationId: 3, updateTimestamp: "nein", shirtColor: "Blå", countryCode: "NO"))
        
        completionHandler(teams: id != nil ? tournamentTeams.filter({id!.contains($0.id!)}) : tournamentTeams)
        
    }
    

}