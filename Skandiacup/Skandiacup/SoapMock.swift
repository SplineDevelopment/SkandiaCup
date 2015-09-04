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
    
    func getField(id: [Int]) -> [Field]?{
        var field = [Field]()
        field.append(Field(fieldID: 1, arenaID: 1, fieldName: "Bane1", fieldDescription: "Bane1Nord", update_timestamp: ""))
        field.append(Field(fieldID: 2, arenaID: 1, fieldName: "Bane2", fieldDescription: "Bane2Nord", update_timestamp: ""))
        field.append(Field(fieldID: 3, arenaID: 1, fieldName: "Bane2", fieldDescription: "Bane3Nord", update_timestamp: ""))
        return field.filter({id.contains($0.fieldID!)})
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

    func getMatches(classID: Int?, groupID: Int?, teamID: Int?, completionHandler: (matches: [TournamentMatch]) -> ()) {
        let matchesTab = [TournamentMatch]()
        completionHandler(matches: matchesTab)
    }
    

}