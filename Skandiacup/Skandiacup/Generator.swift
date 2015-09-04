//
//  Generator.swift
//  Skandiacup
//
//  Created by Borgar Lie on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class Generator {
    
    static let instance: Generator = Generator()
    
    let soapMessage = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:for='http://profixio.com/soap/tournament/ForTournamentExt.php'><soapenv:Header/><soapenv:Body><for:getTournamentMatchStatus><application_key>demo2015uefa</application_key><tournamentID>11</tournamentID><since>2015-09-03 09:00:00</since></for:getTournamentMatchStatus></soapenv:Body></soapenv:Envelope>"
    
    let getArenasMessage = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:for='http://profixio.com/soap/tournament/ForTournamentExt.php'><soapenv:Header/><soapenv:Body><for:getArenas><application_key>demo2015uefa</application_key><tournamentID>11</tournamentID><since>2015-09-03 09:00:00</since></for:getArenas></soapenv:Body></soapenv:Envelope>"
    
    let getTournamentMatches = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:for='http://profixio.com/soap/tournament/ForTournamentExt.php'><soapenv:Header/><soapenv:Body><for:getMatches><application_key>demo2015uefa</application_key><tournamentID>11</tournamentID><since>2014-09-03 09:00:00</since></for:getMatches></soapenv:Body></soapenv:Envelope>"
    
    func testArenaGenerator() -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://profixio.com/soap/tournament/ForTournamentExt.php")!)
        request.HTTPMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String(soapMessage.characters.count), forHTTPHeaderField: "Content-Length")
        let postString = getArenasMessage
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        return request
    }
    
    func generateGetMatchesXML() -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://profixio.com/soap/tournament/ForTournamentExt.php")!)
        request.HTTPMethod = "POST"
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String(soapMessage.characters.count), forHTTPHeaderField: "Content-Length")
        let postString = getTournamentMatches
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        return request
    }
    
}
