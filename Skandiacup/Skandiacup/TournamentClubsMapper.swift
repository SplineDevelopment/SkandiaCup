//
//  TournamentClubsMapper.swift
//  Skandiacup
//
//  Created by Borgar Lie on 04/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class TournamentClubsMapper {
    static func mapClubs(xml: XMLIndexer) -> [TournamentClub] {
        var arr = [TournamentClub]()
        print(xml)
        for elem in xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getClubsResponse"]["getClubsResult"]["item"] {
            var c = TournamentClub()
            if elem["id"].element?.text != nil {
                c.id = Int((elem["id"].element?.text)!)
            }
            if elem["name"].element?.text != nil {
                c.name = elem["name"].element?.text
            }
            if elem["CountryCode"].element?.text != nil {
                c.countryCode = elem["id"].element?.text
            }
            arr.append(c)
        }
        return arr
    }
}