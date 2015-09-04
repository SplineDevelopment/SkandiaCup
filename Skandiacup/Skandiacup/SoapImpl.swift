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
                print(responseString)
                completionHandler(responseData: responseString!)
            } else {
                print("responseString is nil")
            }
        }
        task.resume()
    }
    
    func getArena(id: [Int], completionHandler: (arenas: [Arena]) -> ()) {
        let request = Generator.instance.testArenaGenerator()
        self.sendReceive(request) { (responseData) -> Void in
            let xml = SWXMLHash.parse(responseData)
            let arenaTab = ArenaMapper.mapArenas(xml)
            completionHandler(arenas: arenaTab)
        }
    }
    
    func getTournamentClub(id: [Int]) -> [TournamentClub]?{
        return nil
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
    
    func getMatches(completionHandler: (matches: [TournamentMatch]) -> ()) {
        let request = Generator.instance.generateGetMatchesXML()
        self.sendReceive(request) { (responseString) -> () in
            let xml = SWXMLHash.config {
                config in
                config.shouldProcessNamespaces = false
                }.parse(responseString)
            let matches = MatchesMapper.mapMatches(xml)
            completionHandler(matches: matches)
        }
    }
    
}