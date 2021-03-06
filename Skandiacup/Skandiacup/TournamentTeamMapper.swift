//
//  TournamentTeamMapper.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class TournamentTeamMapper: NSObject {
    static func mapTeams(xml: XMLIndexer) -> [TournamentTeam]{
        var arr = [TournamentTeam]()
        for elem in xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getTeamsResponse"]["getTeamsResult"]["item"] {
            let team = TournamentTeam()
            
            if elem["id"].element?.text != nil{
                team.id = Int((elem["id"].element?.text)!)
            }
            
            if elem["name"].element?.text != nil{
                team.name = elem["name"].element?.text
            }
            
            if elem["clubid"].element?.text != nil{
                team.clubId = Int((elem["clubid"].element?.text)!)
            }
            
            if elem["MatchGroupId"].element?.text != nil{
                team.matchGroupId = Int((elem["MatchGroupId"].element?.text)!)
            }
            
            if elem["MatchClassId"].element?.text != nil{
                team.matchClassId = Int((elem["MatchClassId"].element?.text)!)
            }
            
            if elem["TournamentTeamRegistrationId"].element?.text != nil{
                team.tournamentTeamRegistrationId = Int((elem["TournamentTeamRegistrationId"].element?.text)!)
            }
            
            if elem["UpdateTimestamp"].element?.text != nil {
                team.updateTimestamp = elem["UpdateTimestamp"].element?.text
            }
            
            if elem["ShirtColor"].element?.text != nil{
                team.shirtColor = elem["ShirtColor"].element?.text
            }
            
            if elem["countryCode"].element?.text != nil{
                team.countryCode = elem["countryCode"].element?.text
            }
            arr.append(team)
        }
        return arr
    }
}