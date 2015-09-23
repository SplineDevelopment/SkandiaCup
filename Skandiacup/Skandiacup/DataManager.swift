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
    func getField(arenaID: Int?, fieldID: Int?, completionHandler: (fields: [Field]) -> ()) {
        
    }
    func getMatchClass(id: [Int]) -> [MatchClass]? {
        return [MatchClass()]
    }
    func getMatchGroup(id: [Int]) -> [MatchGroup]? {
        return [MatchGroup()]
    }
    
    func getMatches(classID: Int?, groupID: Int?, teamID: Int?, completionHandler: (matches: [TournamentMatch]) -> ()) {
        let cachedMatches = SharingManager.cache.getMatches(classID, groupID: groupID, teamID: teamID)
        // TODO: how to figure out what needs to be loaded from soap??
        if cachedMatches.isEmpty {
            print("getting matches from SOAP")
            SharingManager.soap.getMatches(classID, groupID: groupID, teamID: teamID, completionHandler: { (matches) -> () in
                SharingManager.cache.setMatches(matches)
                completionHandler(matches: matches)
            })
            return
        }
        print("Getting matches from cache")
        completionHandler(matches: cachedMatches)
    }
    
    func getTeams(id: [Int]?, completionHandler: (teams: [TournamentTeam]) -> ()) {
        
    }
    
    // cache with insta?
    
    func getAllPhotoObjects(completionHandler: (photoObjects: [InstagramPhotoObject]) -> ()) {
        SharingManager.insta.getAllPhotoObjects { (photoObjects) -> () in
            completionHandler(photoObjects: photoObjects)
        }
    }
    
    func getPhotoObject(id: Int, completionHandler: (photoObject: InstagramPhotoObject) -> ()) {
        SharingManager.insta.getPhotoObject(id) { (photoObject) -> () in
            completionHandler(photoObject: photoObject)
        }
    }
}


