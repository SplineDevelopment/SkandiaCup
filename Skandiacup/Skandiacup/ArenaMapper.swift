//
//  ArenaMapper.swift
//  Skandiacup
//
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class ArenaMapper {
    static func mapArenas(xml: XMLIndexer) -> [Arena] {
        var arr = [Arena]()
        for elem in xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getArenasResponse"]["getArenasResult"]["item"] {
            var a = Arena()
            if elem["arenaID"].element?.text != nil {
                a.arenaID = Int((elem["arenaID"].element?.text)!)
            }
            if elem["arenaName"].element?.text != nil {
                a.arenaName = elem["arenaName"].element?.text
            }
            if elem["arenaDescription"].element?.text != nil {
                a.arenaDescription = elem["arenaDescription"].element?.text
            }
            if elem["update_timestamp"].element?.text != nil {
                a.update_timestamp = elem["update_timestamp"].element?.text
            }
            arr.append(a)
        }
        return arr
    }
}