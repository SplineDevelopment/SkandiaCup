//
//  Parser.swift
//  Skandiacup
//
//  Created by Borgar Lie on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class Parser : NSObject, NSXMLParserDelegate {
    
    static let instance: Parser = Parser()
    
    func parseTestArena() -> Arena? {
        let a = Arena()
        return a
    }
    
    func parser(parser: NSXMLParser,didStartElement elementName: String, namespaceURI: String?,
        qualifiedName qName: String?,attributes attributeDict: [String : String])
    {
        print("Element's name is \(elementName)")
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        print("Elements value is \(string)")
        print("\n\n")
    }

}