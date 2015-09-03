//
//  Parser.swift
//  Skandiacup
//
//  Created by Borgar Lie on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class Parser : NSObject, NSXMLParserDelegate {
    
    static let instance: Parser = Parser()
    
    let soapMessage = "<soapenv:Envelope xmlns:soapenv='http://schemas.xmlsoap.org/soap/envelope/' xmlns:for='http://profixio.com/soap/tournament/ForTournamentExt.php'><soapenv:Header/><soapenv:Body><for:getTournamentMatchStatus><application_key>demo2015uefa</application_key><tournamentID>11</tournamentID><since>2015-09-03 09:00:00</since></for:getTournamentMatchStatus></soapenv:Body></soapenv:Envelope>"
    
    func parseTestArena() -> Arena? {
        let a = Arena()
        return a
    }
    
    func test1() {
        let request = NSMutableURLRequest(URL: NSURL(string: "http://profixio.com/soap/tournament/ForTournamentExt.php")!)
        request.HTTPMethod = "POST"
    
        request.addValue("text/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue(String(soapMessage.characters.count), forHTTPHeaderField: "Content-Length")
    
        let postString = soapMessage
    
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let data = (responseString! ).dataUsingEncoding(NSUTF8StringEncoding)
            let xmlparser = NSXMLParser(data: data!)
            xmlparser.delegate = self
            xmlparser.parse()
        }
        task.resume()
    }
    
    func parser(parser: NSXMLParser,didStartElement elementName: String, namespaceURI: String?,
        qualifiedName qName: String?,attributes attributeDict: [String : String])
    {
        print("Element's name is \(elementName)")
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        print("Elements value is \(string)")
        print("\n\n")
    }

}