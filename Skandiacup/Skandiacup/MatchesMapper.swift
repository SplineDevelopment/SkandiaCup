//
//  MatchesMapper.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 04/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class MatchesMapper: NSObject{
    
    static func mapMatches(xml: XMLIndexer) -> [TournamentMatch] {
        var arr: [TournamentMatch] = [TournamentMatch]()
        
        for elem in xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getMatchesResponse"]["getMatchesResult"]["item"]{
            var tm: TournamentMatch = TournamentMatch()
            if elem["id"].element?.text != nil{
                tm.id = Int((elem["id"].element?.text)!)
            }
            
            if elem["matchTXID"].element?.text != nil{
                tm.matchTXID = Int((elem["matchTXID"].element?.text)!)
            }
            
            if elem["matchno"].element?.text != nil{
                tm.matchno = elem["matchno"].element?.text
            }
            
            if elem["classid"].element?.text != nil{
                tm.classId = Int((elem["classid"].element?.text)!)
            }
            
            if elem["hometeamid"].element?.text != nil{
                tm.homeTeamId = Int((elem["hometeamid"].element?.text)!)
            }
            
            if elem["hometeamname"].element?.text != nil{
                tm.homeTeamName = elem["hometeamname"].element?.text
            }
            
            if elem["awayteamid"].element?.text != nil{
                tm.awayTeamId = Int((elem["awayteamid"].element?.text)!)
            }
            
            if elem["awayteamname"].element?.text != nil{
                tm.awayTeamName = elem["awayteamname"].element?.text
            }
            
            if elem["homeclubid"].element?.text != nil{
                tm.homeClubId = Int((elem["homeclubid"].element?.text)!)
            }
            
            if elem["homeclubname"].element?.text != nil{
                tm.homeClubName = elem["homeclubname"].element?.text
            }
            
            if elem["awayclubid"].element?.text != nil{
                tm.awayClubId = Int((elem["awayclubid"].element?.text)!)
            }
            
            if elem["awayclubname"].element?.text != nil{
                tm.awayClubName = elem["awayclubname"].element?.text
            }
            
            if elem["matchdate"].element?.text != nil{
                tm.matchDate = elem["matchdate"].element?.text
            }
            
            if elem["matchcomment"].element?.text != nil{
                tm.matchComment = elem["matchcomment"].element?.text
            }
            
            if elem["hometeamnext"].element?.text != nil{
                tm.homeTeamText = elem["hometeamnext"].element?.text
            }
            
            if elem["awayteamnext"].element?.text != nil{
                tm.awayTeamText = elem["awayteamnext"].element?.text
            }
            if elem["homegoal"].element?.text != nil{
                tm.homegoal = elem["homegoal"].element?.text
                
            }
            
            if elem["awaygoal"].element?.text != nil{
                tm.awaygoal = elem["awaygoal"].element?.text
            }
            
            if elem["fieldid"].element?.text != nil{
                tm.fieldId = Int((elem["fieldid"].element?.text)!)
            }
            
            if elem["endgamelevel"].element?.text != nil{
                tm.endGameLevel = Int((elem["endgamelevel"].element?.text)!)
            }
            
            if elem["sortorder"].element?.text != nil{
                tm.sortOrder = elem["sortorder"].element?.text
            }
            
            if elem["reason"].element?.text != nil{
                tm.reason = elem["reason"].element?.text
            }
            
            if elem["winner"].element?.text != nil{
                tm.winner = elem["winner"].element?.text
            }
            
            if elem["PeriodLengthInMinutes"].element?.text != nil{
                tm.periodLengthInMinutes = elem["PeriodLengthInMinutes"].element?.text
            }
            
            if elem["NumberOfPeriodsInMatch"].element?.text != nil{
                tm.numberOfPeriodsInMatch = elem["NumberOfPeriodsInMatch"].element?.text
            }
            
            if elem["UpdateTimeStamp"].element?.text != nil{
                tm.UpdateTimeStamp = elem["UpdateTimeStamp"].element?.text
            }
            
            if elem["MatchGroupId"].element?.text != nil{
                tm.matchGroupId = Int((elem["MatchGroupId"].element?.text)!)
            }
            arr.append(tm)
            
//            
//            arr.append(TournamentMatch(id: Int((elem["id"].element?.text)!), matchTXID: Int(elem["matchTXID"].element!.text!), matchno: elem["matchno"].element?.text, classId: Int((elem["classid"].element!.text!)), homeTeamId: Int(elem["hometeamid"].element!.text!), homeTeamName: elem["hometeamname"].element?.text, awayTeamId: Int((elem["awayteamid"].element?.text)!), awayTeamName: elem["awayteamname"].element?.text, homeClubId: Int((elem["homeclubid"].element?.text)!), homeClubName: elem["homeclubname"].element?.text, awayClubId: Int((elem["awayclubid"].element?.text)!), awayClubName: elem["awayclubname"].element?.text, matchDate: elem["matchdate"].element?.text, matchComment: elem["matchcomment"].element?.text, homeTeamText: elem["hometeamnext"].element?.text, awayTeamText: elem["awayteamnext"].element?.text, homegoal: elem["homegoal"].element?.text, awaygoal: elem["awaygoal"].element?.text, fieldId: Int((elem["fieldid"].element?.text)!), endGameLevel: Int((elem["endgamelevel"].element?.text)!), sortOrder: elem["sortorder"].element?.text, reason: elem["reason"].element?.text, winner: elem["winner"].element?.text, periodLengthInMinutes: elem["PeriodLengthInMinutes"].element?.text, numberOfPeriodsInMatch: elem["NumberOfPeriodsInMatch"].element?.text, UpdateTimeStamp: elem["UpdateTimeStamp"].element?.text, matchGroupId: Int((elem["MatchGroupId"].element?.text)!)))
        }
        return arr
    }
}