//
//  Generator.swift
//  Skandiacup
//
//  Created by Borgar Lie on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class Generator {
    
    private static func generateMessage(messageFor: String, innerXML: String?) -> String {
        let start = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:for='http://profixio.com/soap/tournament/ForTournamentExt.php'><soapenv:Header/><soapenv:Body>"
        let forXML = "<for:" + messageFor + ">"
        let appKeyTournamentID = Config.appKeyTournamentID
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
        let innerXML = "<since>2015-09-03 09:00:00</since>"
        let getArenaMessage = generateMessage(messageFor, innerXML: innerXML)
        return generateRequest(getArenaMessage)
    }
    
    static func generateGetMatchesXML(classID: Int?, groupID: Int?) -> NSMutableURLRequest {
        let messageFor = "getMatches"
        var innerXML = ""
        if classID != nil {
            innerXML += "<classID>" + String(classID!) + "</classID>"
        }
        if groupID != nil {
            innerXML += "<groupID>" + String(groupID!) + "</groupID>"
        }
        let since = "<since>2014-09-03 09:00:00</since>"
        innerXML += since
        let getTournamentMatches = generateMessage(messageFor, innerXML: innerXML)
        return generateRequest(getTournamentMatches)
    }
    
    static func generateGetClubsXML() -> NSMutableURLRequest {
        let messageFor = "getClubs"
        let innerXML : String? = nil
        let getClubs = generateMessage(messageFor, innerXML: innerXML)
        return generateRequest(getClubs)
    }
}