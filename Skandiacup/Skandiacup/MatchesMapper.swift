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
            arr.append(TournamentMatch(id: Int((elem["id"].element?.text)!), matchTXID: Int(elem["matchTXID"].element!.text!), matchno: elem["matchno"].element?.text, classId: Int((elem["classid"].element!.text!)), homeTeamId: Int(elem["hometeamid"].element!.text!), homeTeamName: elem["hometeamname"].element?.text, awayTeamId: Int((elem["awayteamid"].element?.text)!), awayTeamName: elem["awayteamname"].element?.text, homeClubId: Int((elem["homeclubid"].element?.text)!), homeClubName: elem["homeclubname"].element?.text, awayClubId: Int((elem["awayclubid"].element?.text)!), awayClubName: elem["awayclubname"].element?.text, matchDate: elem["matchdate"].element?.text, matchComment: elem["matchcomment"].element?.text, homeTeamText: elem["hometeamnext"].element?.text, awayTeamText: elem["awayteamnext"].element?.text, homegoal: elem["homegoal"].element?.text, awaygoal: elem["awaygoal"].element?.text, fieldId: Int((elem["fieldid"].element?.text)!), endGameLevel: Int((elem["endgamelevel"].element?.text)!), sortOrder: elem["sortorder"].element?.text, reason: elem["reason"].element?.text, winner: elem["winner"].element?.text, periodLengthInMinutes: elem["PeriodLengthInMinutes"].element?.text, numberOfPeriodsInMatch: elem["NumberOfPeriodsInMatch"].element?.text, UpdateTimeStamp: elem["UpdateTimeStamp"].element?.text, matchGroupId: Int((elem["MatchGroupId"].element?.text)!)))
        }
        return arr
    }
}