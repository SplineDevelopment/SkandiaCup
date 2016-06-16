//
//  GetFromFTP.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 18/02/16.
//  Copyright © 2016 Spline Development. All rights reserved.
//

import Foundation
import UIKit

class GetFromFTP{
    static func openAndGetConfigJSON(completion: (() -> Void)){
        let defaults = NSUserDefaults.standardUserDefaults()
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
                    if let appkey = config!["config"]!!["application_key"], tournamentId = config!["config"]!!["tournamentID"], hashtag = config!["config"]!!["instagramHashtag"], fieldImage = config!["config"]!!["fieldImageUrl"], fieldversion = config!["config"]!!["version"]{
                        SharingManager.config.appKeyTournamentID = "<application_key>\(appkey!)</application_key><tournamentID>\(tournamentId!)</tournamentID>"
                        SharingManager.config.tag_name = hashtag! as! String
                        SharingManager.config.fieldImage = fieldImage as! String
                        
                        // Try to get config from disk
                        let configFromDisk = defaults.objectForKey("config") as? NSData
                        if(configFromDisk != nil){
                            if let config = NSKeyedUnarchiver.unarchiveObjectWithData(configFromDisk!) as? Config{
                                // If we have a differet imageversion, get the new one from the FTP repo.
                                if config.fieldImageVersion != fieldversion! as! String{
                                    getImageFromFTP({ (image) in
                                        SharingManager.config.fieldImageVersion = fieldversion! as! String
                                        defaults.setObject(UIImagePNGRepresentation(image), forKey: "fieldMapImage")
                                        completion()
                                    })
                                }
                            }
                            // Config is nil - get the image currently hosted on the FTP repo.
                        } else {
                            getImageFromFTP({ (image) in
                                SharingManager.config.fieldImageVersion = fieldversion! as! String
                                defaults.setObject(UIImagePNGRepresentation(image), forKey: "fieldMapImage")
                                completion()
                            })
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        CFReadStreamClose(ftpstream)
    }
    
    static func getImageFromFTP(completion: ((image: UIImage) -> Void)){
        if SharingManager.config.fieldImage != ""{
            var configuration = SessionConfiguration()
            configuration.host = HiddenConfig.ftpBaseUrl
            configuration.username = HiddenConfig.ftpUser
            configuration.password = HiddenConfig.ftpPass
            var session = Session(configuration: configuration)
            session.download(SharingManager.config.fieldImage, completionHandler: { (URL, error) in
                if let fileURL = URL {
                    do {
                        var imageurl = fileURL.absoluteString
                        imageurl.removeRange(imageurl.rangeOfString("file://")!)
                        completion(image: UIImage(contentsOfFile: imageurl)!)
                    } catch let error as NSError {
                        print("Error: \(error)")
                    }
                }
            })
        }
    }
}