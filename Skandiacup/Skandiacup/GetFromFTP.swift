//
//  GetFromFTP.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 18/02/16.
//  Copyright © 2016 Spline Development. All rights reserved.
//

import Foundation


class GetFromFTP{
    static func openAndGetConfigJSON(completion: (() -> Void)){
        let urlstring = HiddenConfig.ftpUrl
        var url: CFURLRef
        url = NSURL(string: urlstring)!
        let ftpstream = CFReadStreamCreateWithFTPURL(nil, url).takeRetainedValue();
        var user: CFStringRef
        user = HiddenConfig.ftpUser as NSString
        var pass: CFStringRef
        pass = HiddenConfig.ftpPass as NSString
        CFReadStreamSetProperty(ftpstream, kCFStreamPropertyFTPPassword, pass)
        CFReadStreamSetProperty(ftpstream, kCFStreamPropertyFTPUserName, user)
        var numBytesRead = 0
        let bufSize = 4096
        var buf = [UInt8](count: bufSize, repeatedValue: 0)
        
        let state = CFReadStreamOpen(ftpstream)
        
        repeat{
            numBytesRead = CFReadStreamRead(ftpstream, &buf, bufSize)
        } while (numBytesRead > 0);
        
        
        if let jsonstring = NSString(bytes: buf, length: buf.count, encoding: NSUTF8StringEncoding){
            var jsonproper = jsonstring.stringByReplacingOccurrencesOfString("\t", withString: "");
            jsonproper = jsonproper.stringByReplacingOccurrencesOfString("\0", withString: "");
            if let data = (jsonproper as NSString).dataUsingEncoding(NSUTF8StringEncoding){
                do {
                    let config: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(rawValue: 0))
                    if let appkey = config!["config"]!!["application_key"], tournamentId = config!["config"]!!["tournamentID"], hashtag = config!["config"]!!["instagramHashtag"]{
                        SharingManager.config.appKeyTournamentID = "<application_key>\(appkey!)</application_key><tournamentID>\(tournamentId!)</tournamentID>"
                        SharingManager.config.tag_name = hashtag! as! String
                        completion()
                        print("successfully got config from FTP. Appkey id : \(SharingManager.config.appKeyTournamentID), hashtag is: \(SharingManager.config.tag_name) ");
                    }
                } catch {
                    print(error)
                }
            }
        }
        CFReadStreamClose(ftpstream)
    }
    
    static func getImageFromFTP(completion: (() -> Void)){
        
    }
}