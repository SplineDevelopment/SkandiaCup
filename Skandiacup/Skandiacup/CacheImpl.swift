//
//  CacheImpl.swift
//  Skandiacup
//
//  Created by Borgar Lie on 07/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class CacheImpl : Cache {
    var arenas : ArenaTableCacheObject
    var tournamentMatches : TournamentMatchTableCacheObject
    var tournamentClubs : TournamentClubCacheObject
    
    init() {
//        let defaults = NSUserDefaults.standardUserDefaults()
        
        let a = [Int : CacheObject<Arena>]()
        self.arenas = ArenaTableCacheObject(objects: a)
        
        let tc = [Int: CacheObject<TournamentClub>]()
        self.tournamentClubs = TournamentClubCacheObject(objects: tc)
        
//        test load matches from disk
//        if let tournamentMatchesFromDisk = defaults.dataForKey("tournamentMatches") {
//            self.tournamentMatches = NSKeyedUnarchiver.unarchiveObjectWithData(tournamentMatchesFromDisk) as! TournamentMatchTableCacheObject
//        } else {
//            self.tournamentMatches = TournamentMatchTableCacheObject(objects: [Int : CacheObject<TournamentMatch>]())
//        }
        
        self.tournamentMatches = TournamentMatchTableCacheObject(objects: [Int : CacheObject<TournamentMatch>]())
    }
    
    func getArena(id: [Int]?) -> [Arena] {
        let a = self.arenas.getArenas(id)
        var arenasUpToDate = [Arena]()
        for elem in a {
            if elem.cacheSetTime + Arena.maxCacheTime < Functions.getCurrentTimeInSeconds() {
                arenasUpToDate.append(elem.value)
            }
        }
        return arenasUpToDate
    }
    
    func getTournamentClub(id: [Int]?, countryCode: String?) -> [TournamentClub] {
        let tc = self.tournamentClubs.getTournamentClub(id, countryCode: countryCode)
        var clubsUpToDate = [TournamentClub]()
        
        for elem in tc{
            if elem.cacheSetTime + TournamentClub.maxCacheTime > Functions.getCurrentTimeInSeconds() {
                clubsUpToDate.append(elem.value)
            }
        }
        return clubsUpToDate
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
        let m = self.tournamentMatches.getMatches(classID, groupID: groupID, teamID: teamID)
        var matchesUpToDate = [TournamentMatch]()
        for elem in m {
            if elem.cacheSetTime + TournamentMatch.maxCacheTime > Functions.getCurrentTimeInSeconds() {
                matchesUpToDate.append(elem.value)
            }
        }
        return matchesUpToDate
    }
    
    func getTeams(id: [Int]?) -> [TournamentTeam] {
        return [TournamentTeam]()
    }
    
    func setArena(arenas : [Arena]) {
        self.arenas.setArenas(arenas)
    }
    
    func setTournamentClub(clubs : [TournamentClub]) {
        self.tournamentClubs.setTournamentClubs(clubs)
    }
    func setField(fields: [Field]) {
        
    }
    func setMatchClass(matchClasses : [MatchClass]) {
        
    }
    func setMatchGroup(matchGroups : [MatchGroup]) {
        
    }
    
    func setMatches(matches : [TournamentMatch]) {
        self.tournamentMatches.setMatches(matches)
//        let defaults = NSUserDefaults.standardUserDefaults()
//        let archiveData = NSKeyedArchiver.archivedDataWithRootObject(Wrap(dict: self.tournamentMatches))
//        defaults.setObject(archiveData, forKey: "tournamentMatches")
    }
    
    func setTeams(teams : [TournamentTeam]) {
        
    }
}