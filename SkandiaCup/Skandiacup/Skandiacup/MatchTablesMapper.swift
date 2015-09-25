//
//  MatchTablesMapper.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 04/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class MatchTablesMapper: NSObject {
    static func mapMatchTables(xml: XMLIndexer) -> [MatchTable] {
        let arr: [MatchTable] = [MatchTable]()

        for elem in xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getTableResponse"]["getTableResult"]["item"]{
            var matchtable: MatchTable = MatchTable()
            matchtable.rows = [MatchTableRow]()
            
            if elem["Header"].element != nil {
                matchtable.header = mapMatchTableRow(elem["Header"])
            }
            
            var matchtablerow: MatchTableRow
            if elem["Rows"].element != nil{
                for row in elem["Rows"]["item"]{
                    matchtablerow = mapMatchTableRow(row)
                    matchtable.rows?.append(matchtablerow)
                }
            }
            
        }
        return arr
    }
    
    private static func mapMatchTableRow(xml: XMLIndexer) -> MatchTableRow{
        var row = MatchTableRow()
        
        for elem in xml.children{
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
        }
        return row
    }
}