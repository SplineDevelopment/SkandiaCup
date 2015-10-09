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
    var tournamentTeams : TeamsTableCacheObject
    
    // save to disk::
    // teams
    
    init() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let a = [Int : CacheObject<Arena>]()
        self.arenas = ArenaTableCacheObject(objects: a)
        
        let tc = [Int: CacheObject<TournamentClub>]()
        self.tournamentClubs = TournamentClubCacheObject(objects: tc)
        
        if let tournamentTeamsFromDisk = defaults.dataForKey("tournamentTeams") {
            self.tournamentTeams = NSKeyedUnarchiver.unarchiveObjectWithData(tournamentTeamsFromDisk) as! TeamsTableCacheObject
        } else {
            // replace 0 with something? 
            // does it have to be a real date? need to be able to use with getTournamentMatchStatus??
            self.tournamentTeams = TeamsTableCacheObject(cacheSetTime: 0, teams: [TournamentTeam]())
        }
        
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
    
    func getTeams(completionHandler: (teams : [TournamentTeam]) -> ()) {
        let lastSaved = self.tournamentTeams.cacheSetTime
        let since = Date.getTimeInSoapFormat(lastSaved!)
        print(since)
        SharingManager.soap.getTournamentMatchStatus(since) { (status) -> () in
            if status.needTotalRefresh {
                print("Need total refresh!!! (teams)")
                completionHandler(teams: [TournamentTeam]())
            }
            // safe unwrapping here?
            completionHandler(teams: self.tournamentTeams.teams!)
        }
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
    }
    
    func setTeams(teams : [TournamentTeam]) {
        self.tournamentTeams.setTeamsCache(teams)
        let defaults = NSUserDefaults.standardUserDefaults()
        let archiveData = NSKeyedArchiver.archivedDataWithRootObject(self.tournamentTeams)
        defaults.setObject(archiveData, forKey: "tournamentTeams")
    }
}




