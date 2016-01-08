//
//  TournamentClubsMapper.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class TournamentClubsMapper {
    static func mapClubs(xml: XMLIndexer) -> [TournamentClub] {
        var arr = [TournamentClub]()
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