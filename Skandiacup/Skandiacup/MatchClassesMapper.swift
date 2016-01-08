//
//  MatchClassesMapper.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class MatchClassesMapper {
    static func mapMatchClasses(xml: XMLIndexer) -> [MatchClass] {
        var arr = [MatchClass]()
        
        for elem in xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getMatchClassesResponse"]["getMatchClassesResult"]["item"] {
            var a = MatchClass()
            a.matchGroups = [MatchGroup]()
            if elem["id"].element?.text != nil {
                a.id = Int((elem["id"].element?.text)!)
            }
            if elem["Code"].element?.text != nil {
                a.code = elem["Code"].element?.text
            }
            if elem["Name"].element?.text != nil{
                a.name = elem["Name"].element?.text
            }
            if elem["Gender"].element?.text != nil{
                a.gender = elem["Gender"].element?.text
            }
            if elem["PeriodLengthInMinutes"].element?.text != nil{
                a.periodLengthInMinutes = elem["PeriodLengthInMinutes"].element?.text
            }
            if elem["NumberOfPeriodsInMatch"].element?.text != nil{
                a.numberOfPeriodsInMatch = elem["NumberOfPeriodsInMatch"].element?.text
            }
            if elem["MatchGroups"].element != nil{
                if (elem["MatchGroups"]["item"]){
                    for e in elem["MatchGroups"]["item"]{
                        var b = MatchGroup()
                        if e["id"].element?.text != nil {
                            b.id = Int((e["id"].element?.text)!)
                        }
                        if e["Name"].element?.text != nil {
                            b.name = e["Name"].element?.text
                        }
                        if e["MatchClassId"].element?.text != nil {
                            b.matchClassId = e["MatchClassId"].element?.text
                        }
                        if e["IsPlayoff"].element?.text != nil {
                            let checkBool = e["IsPlayoff"].element?.text
                            if (checkBool == "true"){
                                b.isPlayoff = true
                            } else {
                                b.isPlayoff = false
                            }
                        }
                        if e["PlayoffId"].element?.text != nil {
                            b.playOffId = e["PlayoffId"].element?.text
                        }
                        if e["EndGameLevel"].element?.text != nil {
                            b.endGameLevel = Int((e["EndGameLevel"].element?.text)!)
                        }
                        a.matchGroups?.append(b)
                    }
                }
            }




            /*
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
            */
            arr.append(a)
        }

        return arr
    }
}