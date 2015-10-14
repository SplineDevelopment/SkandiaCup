//
//  CacheObjects.swift
//  Skandiacup
//
//  Created by Borgar Lie on 08/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

struct CacheObject<T> {
    var cacheSetTime : Int
    var value : T
}

class GenericTableCacheObject<T> {
    var objects : [Int : CacheObject<T>]
    
    required init(objects : [Int : CacheObject<T>]?) {
        self.objects = objects != nil ? objects! : [Int : CacheObject<T>]()
    }
}

class ArenaTableCacheObject : GenericTableCacheObject<Arena> {
    init (objects: [Int : CacheObject<Arena>]) {
        super.init(objects: objects)
    }
    
    func getArenas(id : [Int]?) -> [CacheObject<Arena>] {
        if id != nil {
            return self.objects.values.filter({
                id!.contains($0.value.arenaID!)
            })
        }
        return Array(self.objects.values)
    }
    
    func setArenas(arenas : [Arena]) {
        let currentTime = Functions.getCurrentTimeInSeconds()
        arenas.forEach { (element) -> () in
            self.objects[element.arenaID!] = CacheObject<Arena>(cacheSetTime: currentTime, value: element)
        }
    }
}

class FieldTableCacheObject : GenericTableCacheObject<Field> {
    init (objects: [Int : CacheObject<Field>]) {
        super.init(objects: objects)
    }
    
    func getFields(fieldID : Int?, arenaID : Int?) -> [CacheObject<Field>] {
        if fieldID != nil {
            return self.objects.values.filter({
                $0.value.fieldID != nil ? $0.value.fieldID! == fieldID : false
            })
        }
        if arenaID != nil {
            return self.objects.values.filter({
                $0.value.arenaID != nil ? $0.value.arenaID! == arenaID : false
            })
        }
        return Array(self.objects.values)
    }
    
    func setFields(fields : [Field]) {
        let currentTime = Functions.getCurrentTimeInSeconds()
        fields.forEach { (element) -> () in
            // what to do here if fieldID is nil ??
            self.objects[element.fieldID!] = CacheObject<Field>(cacheSetTime: currentTime, value: element)
        }
    }
}

class TournamentClubCacheObject: GenericTableCacheObject<TournamentClub>{
    init(objects: [Int: CacheObject<TournamentClub>]){
        super.init(objects: objects)
    }
    
    func getTournamentClub(id: [Int]?, countryCode: String?) -> [CacheObject<TournamentClub>]{
        var modifiedArray = Array(self.objects.values)
        
        if id != nil{
            modifiedArray = modifiedArray.filter({
                id!.contains($0.value.id!)
            })
        }
        
        if countryCode != nil{
            modifiedArray = modifiedArray.filter({
                $0.value.countryCode! == countryCode!
            })
        }
        return modifiedArray
    }
    
    func setTournamentClubs(clubs : [TournamentClub]) {
        let currentTime = Functions.getCurrentTimeInSeconds()
        clubs.forEach { (element) -> () in
            var elementFound = false
            for (key, dictValue) in self.objects {
                // can matchID be nil ?
                //print(dictValue.value)
                if element.id == dictValue.value.id {
                    elementFound = true
                    self.objects[key] = CacheObject<TournamentClub>(cacheSetTime: currentTime, value: element)
                    break
                }
            }
            if !elementFound {
                self.objects[self.objects.count+1] = CacheObject<TournamentClub>(cacheSetTime: currentTime, value: element)
            }
        }
    }
}

class TournamentMatchTableCacheObject : GenericTableCacheObject<TournamentMatch> {
    init (objects: [Int : CacheObject<TournamentMatch>]) {
        super.init(objects: objects)
    }
    
    func getMatches(classID: Int?, groupID: Int?, teamID: Int?, endplay: Int?) -> [CacheObject<TournamentMatch>] {
        var modifiedArray = Array(self.objects.values)
        if classID != nil {
            modifiedArray = modifiedArray.filter({
                $0.value.classId! == classID!
            })
        }
        if groupID != nil {
            modifiedArray = modifiedArray.filter({
                $0.value.matchGroupId! == groupID!
            })
        }
        if teamID != nil {
            modifiedArray = modifiedArray.filter({
                $0.value.homeTeamId! == teamID! || teamID! == $0.value.awayTeamId!
            })
        }
        if endplay != nil {
            modifiedArray = modifiedArray.filter({
                $0.value.endGameLevel! == endplay!
            })
        }
        return modifiedArray
    }
    
    func setMatches(matches : [TournamentMatch]) {
        let currentTime = Functions.getCurrentTimeInSeconds()
        matches.forEach { (element) -> () in
            var elementFound = false
            for (key, dictValue) in self.objects {
                // can matchID be nil ?
                //print(dictValue.value)
                if element.id == dictValue.value.id {
                    elementFound = true
                    self.objects[key] = CacheObject<TournamentMatch>(cacheSetTime: currentTime, value: element)
                    break
                }
            }
            if !elementFound {
                self.objects[self.objects.count+1] = CacheObject<TournamentMatch>(cacheSetTime: currentTime, value: element)
            }
        }
    }
}

class TeamsTableCacheObject : NSObject, NSCoding {
    var cacheSetTime : Int?
    var teams : [TournamentTeam]?
    
    init (cacheSetTime : Int, teams: [TournamentTeam]) {
        self.cacheSetTime = cacheSetTime
        self.teams = teams
    }
    
    override init() {
        super.init()
    }
    
    func getTeamsCache() -> [TournamentTeam] {
        return self.teams!
    }
    
    func setTeamsCache(teams : [TournamentTeam]) {
        let currentTime = Functions.getCurrentTimeInSeconds()
        self.cacheSetTime = currentTime
        self.teams = teams
    }
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        self.cacheSetTime = decoder.decodeObjectForKey("TeamsCacheSetTime") as? Int
        self.teams = decoder.decodeObjectForKey("TeamsCacheTeamTable") as? [TournamentTeam]
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.cacheSetTime, forKey: "TeamsCacheSetTime")
        coder.encodeObject(self.teams, forKey: "TeamsCacheTeamTable")
    }
}













