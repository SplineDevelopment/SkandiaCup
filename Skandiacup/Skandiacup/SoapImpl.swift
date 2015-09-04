//
//  SoapImpl.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class SoapImpl: Soap {
    
    private func sendReceive(request: NSMutableURLRequest, completionHandler: (responseData: NSData?) -> Void) -> Void {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //print(responseString)
            let responseData = (responseString! ).dataUsingEncoding(NSUTF8StringEncoding)!
            //print(responseData)
            completionHandler(responseData: responseData)
        }
        task.resume()
    }
    
    func getArena(id: [Int], completionHandler: (arenas: [Arena]?) -> ()) {
        let request = Generator.instance.testArenaGenerator()
        self.sendReceive(request) { (responseData) -> Void in
            let xmlparser = NSXMLParser(data: responseData!)
            xmlparser.delegate = Parser.instance
            let key = Parser.instance.getCurrentKey()
            xmlparser.parse()
            let arenaDict = Parser.instance.getValue(key: key)!
            
            // DO SOMETHING HERE ::: TODO
            var arenaTab = [Arena]()
            
            //let arenaDict1 = arenaDict[0]
            
            let a1 = Int(arenaDict["arenaID"]!)
            let a3 = arenaDict["arenaDescription"]
            let a2 = arenaDict["arenaName"]
            let a4 = arenaDict["update_timestamp"]
                
            let arena1 = Arena(arenaID: a1, arenaName: a2, arenaDescription: a3, update_timestamp: a4)
            
            arenaTab.append(arena1)
            
            completionHandler(arenas: arenaTab)
        }
        
        
        //print(response)
        //let xmlparser = NSXMLParser(data: response!)
        //xmlparser.delegate = Parser.instance
        //xmlparser.parse()
        //let key = Parser.instance.getCurrentKey()
        
        //let arenaDict = Parser.instance.getValue(key: key)
        //print(arenaDict)
        
        //return nil
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
    
    func getMatches(completionHandler: (matches: [TournamentMatch]?) -> ()) {
        let request = Generator.instance.generateGetMatchesXML()
        self.sendReceive(request) { (responseData) -> () in
            
            let xmlparser = NSXMLParser(data: responseData!)
            xmlparser.delegate = Parser.instance
            let key = Parser.instance.getCurrentKey()
            xmlparser.parse()
            let tournamentDict = Parser.instance.getValue(key: key)!
            print(tournamentDict)
            completionHandler(matches: nil)
        }
    }
    
}