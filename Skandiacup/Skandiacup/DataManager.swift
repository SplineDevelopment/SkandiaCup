//
//  DataManager.swift
//  Skandiacup
//
//  Created by Borgar Lie on 07/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class DataManager {
    
    func getArena(id: [Int]?, completionHandler: (arenas: [Arena]) -> ()) {
        if id == nil {
            // check cache.. somehow
            // timer for get everything
            SharingManager.soap.getArena(nil, completionHandler: { (arenas) -> () in
                SharingManager.cache.setArena(arenas)
                completionHandler(arenas: arenas)
            })
            return
        }
        let cachedArenas = SharingManager.cache.getArena(id)
        let notInCache = cachedArenas.filter {
            $0.arenaID != nil ? !id!.contains($0.arenaID!) : false
        }
        var notInCacheIds = [Int]()
        notInCache.forEach { (element) -> () in
            notInCacheIds.append(element.arenaID!)
        }
        SharingManager.soap.getArena(notInCacheIds) { (arenas) -> () in
            SharingManager.cache.setArena(arenas)
            completionHandler(arenas: cachedArenas+arenas)
        }
    }
    
    func getField(arenaID: Int?, fieldID: Int?, completionHandler: (fields: [Field]) -> ()) {
        if arenaID == nil && fieldID == nil {
            SharingManager.soap.getField(nil, fieldID: nil, completionHandler: { (fields) -> () in
                SharingManager.cache.setField(fields)
                completionHandler(fields: fields)
            })
        }
        let cachedFields = SharingManager.cache.getField(arenaID, fieldID: fieldID)
        completionHandler(fields: cachedFields)
    }
    
    func getTournamentClub(id: [Int]?, countryCode: String?, completionHandler: (clubs: [TournamentClub]) -> ()) {
        if id == nil && countryCode == nil{
            //What to do here
        }
        
        let cachedTournamentClubs = SharingManager.cache.getTournamentClub(id, countryCode: countryCode)
        if cachedTournamentClubs.isEmpty{
            print("Getting clubs from soap")
            SharingManager.soap.getTournamentClub(id, countryCode: countryCode, completionHandler: { (clubs) -> () in
                SharingManager.cache.setTournamentClub(clubs)
                completionHandler(clubs: clubs)
            })
            return
        }
        
        print("Getting clubs from cache")
        completionHandler(clubs: cachedTournamentClubs)
    }

    func getMatchClass(completionHandler: (matchclasses: [MatchClass]) -> ()) {
        SharingManager.soap.getMatchClass { (matchclasses) -> () in
            completionHandler(matchclasses: matchclasses)
        }
    }
    
    func getMatchGroup(id: [Int]) -> [MatchGroup]? {
        return [MatchGroup()]
    }
    
    func getMatches(classID: Int?, groupID: Int?, teamID: Int?, completionHandler: (matches: [TournamentMatch]) -> ()) {
        let cachedMatches = SharingManager.cache.getMatches(classID, groupID: groupID, teamID: teamID)
        // TODO: how to figure out what needs to be loaded from soap??
        if cachedMatches.isEmpty {
            print("getting matches from SOAP")
            SharingManager.soap.getMatches(classID, groupID: groupID, teamID: teamID, endplay: nil, completionHandler: { (matches) -> () in
                SharingManager.cache.setMatches(matches)
                completionHandler(matches: matches)
            })
            return
        }
        print("Getting matches from cache")
        completionHandler(matches: cachedMatches)
    }
    
    // need to check if filter works as intended
    func getTeams(id: [Int]?, completionHandler: (teams: [TournamentTeam]) -> ()) {
        SharingManager.cache.getTeams { (teamsFromCache) -> () in
            // teams is empty if refresh is needed
            if teamsFromCache.isEmpty {
                print("Getting teams from soap")
                SharingManager.soap.getTeams({ (teams) -> () in
                    SharingManager.cache.setTeams(teams)
                    if id == nil {
                        completionHandler(teams: teams)
                    } else {
                        completionHandler(teams: teams.filter {
                            $0.id != nil ? id!.contains($0.id!) : false
                        })
                    }
                })
            } else {
                print("Getting teams from cache")
                if id == nil {
                    completionHandler(teams: teamsFromCache)
                } else {
                    completionHandler(teams: teamsFromCache.filter {
                        $0.id != nil ? id!.contains($0.id!) : false
                    })
                }
            }
        }
    }
    
    // cache with insta? -> probably just use a timer in the GUI (already saved state in the view cells)
    func getAllPhotoObjects(completionHandler: (photoObjects: [InstagramPhotoObject], error: Bool) -> ()) {
        SharingManager.insta.getAllPhotoObjects { (photoObjects, error) -> () in
            completionHandler(photoObjects: photoObjects, error: error)
        }
    }
    
    // not used
    func getPhotoObject(id: Int, completionHandler: (photoObject: InstagramPhotoObject, error: Bool) -> ()) {
        SharingManager.insta.getPhotoObject(id) { (photoObject, error) -> () in
            completionHandler(photoObject: photoObject, error: error)
        }
    }
}


