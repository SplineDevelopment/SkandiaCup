//
//  TournamentMatchStatusMapper.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class TournamentMatchStatusMapper {
    static func mapTournamentMatchStatus(xml: XMLIndexer) -> TournamentMatchStatus {
        let status = TournamentMatchStatus()
        if let needTotalRefresh_status = xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getTournamentMatchStatusResponse"]["getTournamentMatchStatusResult"]["needTotalRefresh"].element?.text {
            if needTotalRefresh_status == "true" {
                status.needTotalRefresh = true
            }
        }
        
        if let existsNewOrUpdatedMatches_status = xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getTournamentMatchStatusResponse"]["getTournamentMatchStatusResult"]["existsNewOrUpdatedMatches"].element?.text {
            if existsNewOrUpdatedMatches_status == "true" {
                status.existsNewOrUpdatedMatches = true
            }
        }
        
        if let teamCount_number = xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getTournamentMatchStatusResponse"]["getTournamentMatchStatusResult"]["teamCount"].element?.text {
            status.teamCount = Int(teamCount_number)!
        }
        
        return status
    }
}