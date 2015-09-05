//
//  SoapImpl.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class SoapImpl: Soap {
    
    private func sendReceive(request: NSMutableURLRequest, completionHandler: (responseData: String) -> Void) -> Void {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            if responseString != nil {
                //print(responseString)
                completionHandler(responseData: responseString!)
            } else {
                print("responseString is nil")
            }
        }
        task.resume()
    }
    
    func getArena(id: [Int]?, completionHandler: (arenas: [Arena]) -> ()) {
        let request = Generator.generateGetArenasXML()
        self.sendReceive(request) { (responseData) -> Void in
            let xml = SWXMLHash.parse(responseData)
            let arenaTab = ArenaMapper.mapArenas(xml)
            completionHandler(arenas: id != nil ? arenaTab.filter({id!.contains($0.arenaID!)}) : arenaTab)
        }
    }
    
    func getTournamentClub(id: [Int]?, countryCode: String?, completionHandler: (clubs: [TournamentClub]) -> ()) {
        let request = Generator.generateGetClubsXML()
        self.sendReceive(request) { (responseData) -> Void in
            let xml = SWXMLHash.parse(responseData)
            let clubTab = TournamentClubsMapper.mapClubs(xml)
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
    }
    
    func getField(id: [Int]) -> [Field]?{
        return nil
    }

    func getMatchClass(id: [Int]) -> [MatchClass]?{
        return nil
    }
    
    func getMatchGroup(id: [Int]) -> [MatchGroup]?{
        return nil
    }
    
    func getMatches(classID: Int?, groupID: Int?, teamID: Int?, completionHandler: (matches: [TournamentMatch]) -> ()) {
        let request = Generator.generateGetMatchesXML(classID, groupID: groupID)
        self.sendReceive(request) { (responseString) -> () in
            let xml = SWXMLHash.config {
                config in
                config.shouldProcessNamespaces = false
                }.parse(responseString)
            let matches = MatchesMapper.mapMatches(xml)
            completionHandler(matches: teamID != nil ? matches.filter({
                $0.homeTeamId! == teamID! || teamID! == $0.awayTeamId!
            }) : matches)
        }
    }
    
    func getTeams(id: [Int]?, completionHandler: (teams: [TournamentTeam])-> ()){
        let request = Generator.generateGetTeamsXML()
        self.sendReceive(request) { (responseString) -> Void in
            let xml = SWXMLHash.parse(responseString)
            let teams = TournamentTeamMapper.mapTeams(xml)
            completionHandler(teams: id != nil ? teams.filter({id!.contains($0.id!)}) : teams)
        }
    }
}