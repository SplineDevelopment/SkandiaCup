//
//  File.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 04/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class FieldsMapper: NSObject {
    static func mapFields(xml: XMLIndexer) -> [Field] {
        var arr: [Field] = [Field]()
        
        for elem in xml["SOAP-ENV:Envelope"]["SOAP-ENV:Body"]["ns1:getFieldsResponse"]["getFieldsResult"]["item"]{
            var field: Field = Field()

            if elem["fieldId"].element?.text != nil{
                field.fieldID = Int((elem["fieldId"].element?.text)!)
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
        }
        return arr
    }
}