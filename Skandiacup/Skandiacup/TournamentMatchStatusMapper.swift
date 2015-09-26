//
//  TournamentMatchStatusMapper.swift
//  Skandiacup
//
//  Created by Borgar Lie on 26/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
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
        return status
    }
}