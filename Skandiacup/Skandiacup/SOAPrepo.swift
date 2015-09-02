//
//  SOAPrepo.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 02/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import UIKit

class SOAPrepo: NSObject, NSXMLParserDelegate {
    var parser = NSXMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var title1 = NSMutableString()
    var date = NSMutableString()
//    
//    var xmlstring: String = "<?xml version='1.0' encoding='UTF-8'?><SOAP-ENV:Envelope xmlns:SOAP-ENV='http://schemas.xmlsoap.org/soap/envelope/'><SOAP-ENV:Body><SOAP-ENV:Fault><faultcode>SOAP-ENV:Client</faultcode><faultstring>Application key is not valid</faultstring></SOAP-ENV:Fault></SOAP-ENV:Body></SOAP-ENV:Envelope>"
//    
////    let data = xmlstring.dataUsingEncoding(NSUTF8StringEncoding)
//    
//    override init(){
//        super.init()
//        var data = (xmlstring as NSString).dataUsingEncoding(NSUTF8StringEncoding)
//        var xmlparser = NSXMLParser(data: data!)
//        xmlparser.delegate = self
//        xmlparser.parse()
//    }
//    
//    func parser(parser: NSXMLParser!, _didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: NSDictionary!) {
//        print("Element's name is \(elementName)")
//        print("Element's attributes are \(attributeDict)")
//    }
  }
