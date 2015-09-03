//
//  Parser.swift
//  Skandiacup
//
//  Created by Borgar Lie on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class Parser : NSObject, NSXMLParserDelegate {
    private var dict : Dictionary<Int, Dictionary<String, String>>!
    private var currentKey : Int!
    private var currentElement : String?
    
    static let instance: Parser = Parser()
    
    override init() {
        super.init()
        dict = Dictionary<Int, Dictionary<String, String>>()
        currentKey = 0
    }
    
    func getCurrentKey() -> Int {
        return self.currentKey
    }
    
    func getValue(key key: Int) -> Dictionary<String, String>? {
        //print(key)
        //print(self.dict)
        //print(self.currentKey)
        //print(self.dict[key])
        return self.dict[key]
    }
    
    func parserDidStartDocument(parser: NSXMLParser) {
        self.dict[self.currentKey] = Dictionary<String, String>()
    }
    
    func parserDidEndDocument(parser: NSXMLParser) {
        self.currentKey = self.currentKey + 1
    }
    
    func parser(parser: NSXMLParser,didStartElement elementName: String, namespaceURI: String?,
        qualifiedName qName: String?,attributes attributeDict: [String : String])
    {
        //print("Element's name is \(elementName)")
        self.currentElement = elementName
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        //print("Elements value is \(string)")
        //print("\n\n")
        if (currentElement != nil) {
            self.dict[self.currentKey]![self.currentElement!] = string
        }
        self.currentElement = nil
    }
    
    

}