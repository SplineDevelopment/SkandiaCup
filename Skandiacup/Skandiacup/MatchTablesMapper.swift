//
//  MatchTablesMapper.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class MatchTablesMapper: NSObject {
    static func mapMatchTables(xml: XMLIndexer) -> [MatchTable] {
        var arr: [MatchTable] = [MatchTable]()

        for elem in xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getTableResponse"]["getTableResult"]["item"]{
            var matchtable: MatchTable = MatchTable()
            matchtable.rows = [MatchTableRow]()
            
            if elem["Header"].element != nil {
                matchtable.header = mapMatchTableRow(elem["Header"])
            }
            
            if elem["Rows"].element != nil{
                for row in elem["Rows"]["item"]{
                    matchtable.rows?.append(mapMatchTableRow(row))
                }
            }
            arr.append(matchtable)
        }
        return arr
    }
    
    private static func mapMatchTableRow(elem: XMLIndexer) -> MatchTableRow{
        var row = MatchTableRow()
        if elem["id"].element?.text != nil{
            row.id = Int((elem["id"].element?.text )!)
        }
        
        if elem["MatchClassId"].element?.text != nil{
            row.matchClassId = elem["MatchClassId"].element?.text
        }
        
        if elem["MatchGroupId"].element?.text != nil{
            row.matchGroupId = elem["MatchGroupId"].element?.text
        }
        
        if elem["DisplayOrder"].element?.text != nil{
            row.displayOrder = elem["DisplayOrder"].element?.text
        }
        
        if elem["Position"].element?.text != nil{
            row.position = elem["Position"].element?.text
        }
        
        if elem["PlayOffId"].element?.text != nil{
            row.playoffId = Int((elem["PlayOffId"].element?.text)!)
        }
        
        if elem["PlayoffLevel"].element?.text != nil{
            row.playOffLevel = Int((elem["PlayoffLevel"].element?.text)!)
        }
        
        if elem["a"].element?.text != nil{
            row.a = elem["a"].element?.text
        }
        
        if elem["b"].element?.text != nil{
            row.b = elem["b"].element?.text
        }
        
        if elem["c"].element?.text != nil{
            row.c = elem["c"].element?.text
        }
        
        if elem["d"].element?.text != nil{
            row.d = elem["d"].element?.text
        }
        
        if elem["e"].element?.text != nil{
            row.e = elem["e"].element?.text
        }
        
        if elem["f"].element?.text != nil{
            row.f = elem["f"].element?.text
        }
        
        if elem["g"].element?.text != nil{
            row.g = elem["g"].element?.text
        }
        return row
    }
}