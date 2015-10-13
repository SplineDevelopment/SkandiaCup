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
//            print("Sending data over network!")
            if responseString != nil {
//                print(responseString)
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
    
    func getField(arenaID: Int?, fieldID: Int?, completionHandler: (fields: [Field]) -> ()) {
        let request = Generator.generateGetFieldsXML(arenaID)
        self.sendReceive(request) { (responseData) -> Void in
            let xml = SWXMLHash.parse(responseData)
            let fieldTab = FieldsMapper.mapFields(xml)
            if fieldID != nil {
                completionHandler(fields: fieldTab.filter({$0.fieldID == fieldID}))
            }
            else {
                completionHandler(fields: fieldTab)
            }
        }
    }

    func getMatchClass(completionHandler: (matchclasses: [MatchClass]) -> ()){
        let request = Generator.generateGetMatchClassesXML()
        self.sendReceive(request) { (responseString) -> () in
            let xml = SWXMLHash.config {
                config in
                config.shouldProcessNamespaces = false
                }.parse(responseString)
            let matchClasses = MatchClassesMapper.mapMatchClasses(xml)
            completionHandler(matchclasses: matchClasses)
        }
    }
    
    func getMatches(classID: Int?, groupID: Int?, teamID: Int?, endplay: Int?, completionHandler: (matches: [TournamentMatch]) -> ()) {
        let request = Generator.generateGetMatchesXML(classID, groupID: groupID, endplay: endplay)
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
    
    func getTeams(completionHandler: (teams: [TournamentTeam])-> ()) {
        let request = Generator.generateGetTeamsXML()
        self.sendReceive(request) { (responseString) -> Void in
            let xml = SWXMLHash.parse(responseString)
            let teams = TournamentTeamMapper.mapTeams(xml)
            completionHandler(teams: teams)
        }
    }
    
    func getTable(groupID: Int?, playOffId: Int?, teamId: Int?, completionHandler: (tables: [MatchTable]) -> ()) {
        let request = Generator.generateGetTableXML(groupID, playoffID: playOffId, teamID: teamId)
        self.sendReceive(request) { (responseString) -> () in
            let xml = SWXMLHash.parse(responseString)
            let tables = MatchTablesMapper.mapMatchTables(xml)
            completionHandler(tables: tables)
        }
    }
    
    func getTournamentMatchStatus(since: String, completionHandler: (status: TournamentMatchStatus) -> ()) {
        let request = Generator.generateGetTournamentMatchStatusXML(since)
        self.sendReceive(request) { (responseString) -> () in
            let xml = SWXMLHash.parse(responseString)
            let status = TournamentMatchStatusMapper.mapTournamentMatchStatus(xml)
            completionHandler(status: status)
        }
    }
}



