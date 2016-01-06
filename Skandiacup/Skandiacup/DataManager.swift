//
//  DataManager.swift
//  Skandiacup
//
//  Created by Borgar Lie on 07/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class DataManager {
    func getArena(id: [Int]?, completionHandler: (arenas: [Arena], error: Bool) -> ()) {
        if id == nil {
            // can not know if arena is in cache, if no ID is given. need to get all!
            SharingManager.soap.getArena({ (arenas, soapError) -> () in
                if soapError {
                    completionHandler(arenas: arenas, error: true)
                } else {
                    SharingManager.cache.setArena(arenas)
                    completionHandler(arenas: arenas, error: false)
                }
            })
            return
        }
        let cachedArenas = SharingManager.cache.getArena(id)
        let notInCache = cachedArenas.filter {
            $0.arenaID != nil ? !id!.contains($0.arenaID!) : false
        }
        if notInCache.count > 0 {
            SharingManager.soap.getArena({ (arenas, soapError) -> () in
                if soapError {
                    completionHandler(arenas: arenas, error: true)
                } else {
                    SharingManager.cache.setArena(arenas)
                    completionHandler(arenas: arenas, error: false)
                }
            })
        } else {
            completionHandler(arenas: cachedArenas, error: false)
        }
    }
    
    func getField(arenaID: Int?, fieldID: Int?, completionHandler: (fields: [Field], error: Bool) -> ()) {
        if arenaID == nil && fieldID == nil {
            SharingManager.soap.getField(nil, completionHandler: { (fields, soapError) -> () in
                if soapError {
                    completionHandler(fields: fields, error: true)
                } else {
                    SharingManager.cache.setField(fields)
                    completionHandler(fields: fields, error: false)
                }
            })
            return
        }
        // what if cache is empty and arenaID & fieldID is nil?
        let cachedFields = SharingManager.cache.getField(arenaID, fieldID: fieldID)
        if cachedFields.isEmpty {
            SharingManager.soap.getField(arenaID, completionHandler: { (fields, soapError) -> () in
                if soapError {
                    completionHandler(fields: fields, error: true)
                } else {
                    SharingManager.cache.setField(fields)
                    // filtering after getting new, NEEDS TESTING
                    let cachedFieldsNew = SharingManager.cache.getField(arenaID, fieldID: fieldID)
                    completionHandler(fields: cachedFieldsNew, error: false)
                }
            })
            return
        }
        completionHandler(fields: cachedFields, error: false)
    }
    
    func getTournamentClub(id: [Int]?, countryCode: String?, completionHandler: (clubs: [TournamentClub], error: Bool) -> ()) {
        if id == nil && countryCode == nil{
            // can not know if it is in cache, need to fetch all
            SharingManager.soap.getTournamentClub({ (clubs, soapError) -> () in
                if soapError {
                    completionHandler(clubs: clubs, error: true)
                } else {
                    SharingManager.cache.setTournamentClub(clubs)
                    completionHandler(clubs: clubs, error: false)
                }
            })
        }
        let cachedTournamentClubs = SharingManager.cache.getTournamentClub(id, countryCode: countryCode)
        if cachedTournamentClubs.isEmpty{
            SharingManager.soap.getTournamentClub({ (clubs, soapError) -> () in
                if soapError {
                    completionHandler(clubs: clubs, error: true)
                } else {
                    SharingManager.cache.setTournamentClub(clubs)
                    completionHandler(clubs: clubs, error: false)
                }
            })
            return
        }
        completionHandler(clubs: cachedTournamentClubs, error: false)
    }
    
    
    // implement RAM cache
    func getMatchClass(completionHandler: (matchclasses: [MatchClass], error: Bool) -> ()) {
        SharingManager.soap.getMatchClass { (matchclasses, soapError) -> () in
            if soapError {
                completionHandler(matchclasses: matchclasses, error: true)
            } else {
                completionHandler(matchclasses: matchclasses, error: false)
            }
        }
    }
    
    func getMatches(classID: Int?, groupID: Int?, teamID: Int?, endplay: Int?, completionHandler: (matches: [TournamentMatch], error: Bool) -> ()) {
        let cachedMatches = SharingManager.cache.getMatches(classID, groupID: groupID, teamID: teamID, endplay: endplay)
        if cachedMatches.isEmpty {
            SharingManager.soap.getMatches(classID, groupID: groupID, endplay: endplay, completionHandler: { (matches, soapError) -> () in
                if soapError {
                    completionHandler(matches: matches, error: true)
                }

                var m = matches
                if teamID != nil {
                    m = m.filter({
                        $0.homeTeamId! == teamID! || teamID! == $0.awayTeamId!
                    })
                }
                if endplay != nil {
                    m = m.filter({
                        $0.endGameLevel! == endplay!
                    })
                }
                completionHandler(matches: m, error: false)
                SharingManager.cache.setMatches(matches)
            })
            return
        }
        completionHandler(matches: cachedMatches, error: false)
    }
    
    // need to check if filter works as intended
    func getTeams(id: [Int]?, completionHandler: (teams: [TournamentTeam], error: Bool) -> ()) {
        SharingManager.cache.getTeams { (teamsFromCache, cacheError) -> () in
            // teams is empty if refresh is needed
            if teamsFromCache.isEmpty || cacheError {
                SharingManager.soap.getTeams({ (teams, soapError) -> () in
                    if soapError {
                        completionHandler(teams: teams, error: true)
                        return
                    }
                    SharingManager.cache.setTeams(teams)
                    if id == nil {
                        completionHandler(teams: teams, error: false)
                    } else {
                        completionHandler(teams: teams.filter {
                            $0.id != nil ? id!.contains($0.id!) : false
                            }, error: false)
                    }
                })
            } else {
                if id == nil {
                    completionHandler(teams: teamsFromCache, error: false)
                } else {
                    completionHandler(teams: teamsFromCache.filter {
                        $0.id != nil ? id!.contains($0.id!) : false
                        }, error: false)
                }
            }
        }
    }
    
    // implement RAM cache
    func getTable(groupID: Int?, playOffId: Int?, teamId: Int?, completionHandler: (tables: [MatchTable], error: Bool) -> ()) {
        SharingManager.soap.getTable(groupID, playOffId: playOffId, teamId: teamId) { (tables, soapError) -> () in
            if soapError {
                completionHandler(tables: tables, error: true)
            } else {
                completionHandler(tables: tables, error: false)
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


