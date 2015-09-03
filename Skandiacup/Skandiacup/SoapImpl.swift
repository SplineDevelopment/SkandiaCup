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
    
    func getArena(id: [Int], completionHandler: (arenas: [Arena]?) -> Void) -> Void {
        let request = Generator.instance.testArenaGenerator()
        
        //let data : Dictionary<String, String>
        
        self.sendReceive(request) { (responseData) -> Void in
            let xmlparser = NSXMLParser(data: responseData!)
            xmlparser.delegate = Parser.instance
            let key = Parser.instance.getCurrentKey()
            xmlparser.parse()
            let arenaDict = Parser.instance.getValue(key: key)!
            //print(arenaDict)
            
            var arenaTab = [Arena]()
            
            //let arenaDict1 = arenaDict[0]
            
            let a1 = arenaDict["update_timestamp"]
            let a2 = Int(arenaDict["arenaID"]!)
                
            let arena1 = Arena(arenaID: a2, arenaName: "test", arenaDescription: "Test", update_timestamp: a1)
            
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
    
}