//
//  File.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class FieldsMapper: NSObject {
    static func mapFields(xml: XMLIndexer) -> [Field] {
        var arr = [Field]()
        for elem in xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getFieldsResponse"]["getFieldsResult"]["item"]{
            var field: Field = Field()
            if elem["fieldID"].element?.text != nil{
                field.fieldID = Int((elem["fieldID"].element?.text)!)
            }
            
            if elem["arenaID"].element?.text != nil{
                field.arenaID = Int((elem["arenaID"].element?.text)!)
            }
            
            if elem["fieldName"].element?.text != nil{
                field.fieldName = elem["fieldName"].element?.text
            }
            
            if elem["fieldDescription"].element?.text != nil{
                field.fieldDescription = elem["fieldDescription"].element?.text
            }
            
            if elem["update_timestamp"].element?.text != nil{
                field.update_timestamp = elem["update_timestamp"].element?.text
            }
            arr.append(field)
        }
        return arr
    }
}