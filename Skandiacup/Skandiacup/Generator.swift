//
//  Generator.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class Generator {
    
    private static func generateMessage(messageFor: String, innerXML: String?) -> String {
        let start = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:for='http://profixio.com/soap/tournament/ForTournamentExt.php'><soapenv:Header/><soapenv:Body>"
        let forXML = "<for:" + messageFor + ">"
        let appKeyTournamentID = SharingManager.config.appKeyTournamentID
        let endForXML = "</for:" + messageFor + ">"
        let end = "</soapenv:Body></soapenv:Envelope>"
        if innerXML != nil {
            return start + forXML + appKeyTournamentID + innerXML! + endForXML + end
        }
        return start + forXML + appKeyTournamentID + endForXML + end
    }
    
    private static func generateRequest(message: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://profixio.com/soap/tournament/ForTournamentExt.php")!)
        request.HTTPMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String(message.characters.count), forHTTPHeaderField: "Content-Length")
        request.HTTPBody = message.dataUsingEncoding(NSUTF8StringEncoding)
        return request
    }
    
    static func generateGetArenasXML() -> NSMutableURLRequest {
        let messageFor = "getArenas"
        let getArenaMessage = generateMessage(messageFor, innerXML: nil)
        return generateRequest(getArenaMessage)
    }
    
    static func generateGetMatchesXML(classID: Int?, groupID: Int?, endplay: Int?) -> NSMutableURLRequest {
        let messageFor = "getMatches"
        var innerXML = ""
        if classID != nil {
            innerXML += "<classID>" + String(classID!) + "</classID>"
        }
        if groupID != nil {
            innerXML += "<groupID>" + String(groupID!) + "</groupID>"
        }
        if endplay != nil{
            innerXML += "<endplay>\(endplay!)</endplay>"
        }
        let getTournamentMatches = generateMessage(messageFor, innerXML: innerXML)
        return generateRequest(getTournamentMatches)
    }
    
    static func generateGetClubsXML() -> NSMutableURLRequest {
        let messageFor = "getClubs"
        let innerXML : String? = nil
        let getClubs = generateMessage(messageFor, innerXML: innerXML)
        return generateRequest(getClubs)
    }
    
    static func generateGetMatchClassesXML() -> NSMutableURLRequest {
        let messageFor = "getMatchClasses"
        let innerXML : String? = nil
        let getMatchClasses = generateMessage(messageFor, innerXML: innerXML)
        return generateRequest(getMatchClasses)
    }
    
    static func generateGetTeamsXML() -> NSMutableURLRequest {
        let messageFor = "getTeams"
        let getTeamsMessage = generateMessage(messageFor, innerXML: nil)
        return generateRequest(getTeamsMessage)
    }
    
    static func generateGetFieldsXML(arenaID: Int?) -> NSMutableURLRequest {
        let messageFor = "getFields"
        var innerXML = ""
        if arenaID != nil {
            innerXML += "<arenaID>" + String(arenaID) + "</arenaID>"
        }
        let getFieldsMessage = generateMessage(messageFor, innerXML: innerXML)
        return generateRequest(getFieldsMessage)
    }
    
    static func generateGetTournamentMatchStatusXML(since: String) -> NSMutableURLRequest {
        let messageFor = "getTournamentMatchStatus"
        let getTournamentMatchStatusMessage = generateMessage(messageFor, innerXML: nil)
        return generateRequest(getTournamentMatchStatusMessage)
    }
    
    static func generateGetTableXML(groupID: Int?, playoffID: Int?, teamID: Int?) -> NSMutableURLRequest{
        let messageFor = "getTable"
        var innerXML = ""
        if groupID != nil{
            innerXML += "<groupID>\(groupID!)</groupID>"
        }
        
        if playoffID != nil{
            innerXML += "<playoffID>\(playoffID!)</playoffID>"
        }
        
        if teamID != nil{
            innerXML += "<teamID>\(teamID!)</teamID>"
        }
        
        let getTableMessage = generateMessage(messageFor, innerXML: innerXML)
        return generateRequest(getTableMessage)
    }
}
