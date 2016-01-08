//
//  SoapImpl.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class SoapImpl: Soap {
    private func sendReceive(request: NSMutableURLRequest, completionHandler: (responseData: String?, error: Bool) -> Void) -> Void {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error=\(error)")
                completionHandler(responseData: nil, error: true)
                return
            }
            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            if responseString != nil {
                completionHandler(responseData: responseString!, error: false)
            } else {
                completionHandler(responseData: nil, error: true)
            }
        }
        task.resume()
    }
    
    func getArena(completionHandler: (arenas: [Arena], error: Bool) -> ()) {
        let request = Generator.generateGetArenasXML()
        self.sendReceive(request) { (responseData, responseError) -> Void in
            if responseError || responseData == nil {
                completionHandler(arenas: [Arena](), error: true)
                return
            }
            let xml = SWXMLHash.parse(responseData!)
            let arenaTab = ArenaMapper.mapArenas(xml)
            completionHandler(arenas: arenaTab, error: false)
        }
    }
    
    func getTournamentClub(completionHandler: (clubs: [TournamentClub], error: Bool) -> ()) {
        let request = Generator.generateGetClubsXML()
        self.sendReceive(request) { (responseData, responseError) -> Void in
            if responseError || responseData == nil {
                completionHandler(clubs: [TournamentClub](), error: true)
                return
            }
            let xml = SWXMLHash.parse(responseData!)
            let clubTab = TournamentClubsMapper.mapClubs(xml)
            completionHandler(clubs: clubTab, error: false)
        }
    }
    
    func getField(arenaID: Int?, completionHandler: (fields: [Field], error: Bool) -> ()) {
        let request = Generator.generateGetFieldsXML(arenaID)
        self.sendReceive(request) { (responseData, responseError) -> Void in
            if responseError || responseData == nil {
                completionHandler(fields: [Field](), error: true)
                return
            }
            let xml = SWXMLHash.parse(responseData!)
            let fieldTab = FieldsMapper.mapFields(xml)
            completionHandler(fields: fieldTab, error: false)
        }
    }

    func getMatchClass(completionHandler: (matchclasses: [MatchClass], error: Bool) -> ()){
        let request = Generator.generateGetMatchClassesXML()
        self.sendReceive(request) { (responseData, responseError) -> () in
            if responseError || responseData == nil {
                completionHandler(matchclasses: [MatchClass](), error: true)
                return
            }
            let xml = SWXMLHash.config {
                config in
                config.shouldProcessNamespaces = false
                }.parse(responseData!)
            let matchClasses = MatchClassesMapper.mapMatchClasses(xml)
            completionHandler(matchclasses: matchClasses, error: false)
        }
    }
    
    func getMatches(classID: Int?, groupID: Int?, endplay: Int?, completionHandler: (matches: [TournamentMatch], error: Bool) -> ()) {
        let request = Generator.generateGetMatchesXML(classID, groupID: groupID, endplay: endplay != nil ? endplay > 0 ? 1 : nil : nil)
        self.sendReceive(request) { (responseData, responseError) -> () in
            if responseError || responseData == nil {
                completionHandler(matches: [TournamentMatch](), error: true)
                return
            }
            let xml = SWXMLHash.config {
                config in
                config.shouldProcessNamespaces = false
                }.parse(responseData!)
            let matches = MatchesMapper.mapMatches(xml)
            completionHandler(matches: matches, error: false)
        }
    }
    
    func getTeams(completionHandler: (teams: [TournamentTeam], error: Bool)-> ()) {
        let request = Generator.generateGetTeamsXML()
        self.sendReceive(request) { (responseData, responseError) -> Void in
            if responseError || responseData == nil {
                completionHandler(teams: [TournamentTeam](), error: true)
                return
            }
            let xml = SWXMLHash.parse(responseData!)
            let teams = TournamentTeamMapper.mapTeams(xml)
            completionHandler(teams: teams, error: false)
        }
    }
    
    func getTable(groupID: Int?, playOffId: Int?, teamId: Int?, completionHandler: (tables: [MatchTable], error: Bool) -> ()) {
        let request = Generator.generateGetTableXML(groupID, playoffID: playOffId, teamID: teamId)
        self.sendReceive(request) { (responseData, responseError) -> () in
            if responseError || responseData == nil {
                completionHandler(tables: [MatchTable](), error: true)
                return
            }
            let xml = SWXMLHash.parse(responseData!)
            let tables = MatchTablesMapper.mapMatchTables(xml)
            completionHandler(tables: tables, error: false)
        }
    }
    
    func getTournamentMatchStatus(since: String, completionHandler: (status: TournamentMatchStatus, error: Bool) -> ()) {
        let request = Generator.generateGetTournamentMatchStatusXML(since)
        self.sendReceive(request) { (responseData, responseError) -> () in
            if responseError || responseData == nil {
                completionHandler(status: TournamentMatchStatus(), error: true)
                return
            }
            let xml = SWXMLHash.parse(responseData!)
            let status = TournamentMatchStatusMapper.mapTournamentMatchStatus(xml)
            completionHandler(status: status, error: false)
        }
    }
}



