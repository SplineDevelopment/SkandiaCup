//
//  InstagramRepoImpl.swift
//  Skandiacup
//
//  Created by Borgar Lie on 23/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation


// static let maxCacheTime = 60 * 60 * 24

class InstagramRepoImpl : InstagramRepo {
    init() {
//        print("using InstagramRepoImpl")
    }
    
    private func sendReceive(request: NSMutableURLRequest, completionHandler: (responseData: NSData?, error: Bool) -> Void) -> Void {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error=\(error)")
                completionHandler(responseData: nil, error: true)
                return
            }
            completionHandler(responseData: data, error: false)
        }
        task.resume()
    }
    
    func getAllPhotoObjects(completionHandler: (photoObjects: [InstagramPhotoObject], error: Bool) -> ()) {
        let tag = Config.tag_name
        let id = Config.client_id_insta
        let get_uri = "https://api.instagram.com/v1/tags/" + tag + "/media/recent?client_id=" + id
        let req = NSMutableURLRequest(URL: NSURL(string: get_uri)!)
        
        sendReceive(req) { (responseData, response_error) -> Void in
            do {
                if response_error {
                    completionHandler(photoObjects: [InstagramPhotoObject](), error: true)
                    return
                }
                let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(responseData!, options: NSJSONReadingOptions(rawValue: 0))
                // this is not safe!
                let test_o = anyObj as! NSDictionary
//                print(test_o)
                let arr = self.parseJson(test_o["data"]!)
                completionHandler(photoObjects: arr, error: false)
            } catch let error as NSError {
                print(error)
            }
        }
        
        
    }
    
    func parseJson(anyObj:AnyObject) -> Array<InstagramPhotoObject>{
        var list:Array<InstagramPhotoObject> = []
        if anyObj is Array<AnyObject> {
            for json in anyObj as! Array<AnyObject>{
                
                let b:InstagramPhotoObject = InstagramPhotoObject()
                
                var temp_url: String?
                if let jsonDict_url_1 = json["images"] as? NSDictionary {
                    if let jsonDict_url_2 = jsonDict_url_1["standard_resolution"] as? NSDictionary {
                        if let jsonDict_url_3 = jsonDict_url_2["url"] as? String {
                            temp_url = jsonDict_url_3
                            b.url = NSURL(string: temp_url!)
                        } else {
                            // how to handle this?
                            print("ERROR standard res url")
                            b.url = NSURL()
                        }
                    }
                }
                
                var temp_url_th: String?
                if let jsonDict_url_th1 = json["images"] as? NSDictionary {
                    if let jsonDict_url_th2 = jsonDict_url_th1["thumbnail"] as? NSDictionary {
                        if let jsonDict_url_th3 = jsonDict_url_th2["url"] as? String {
                            temp_url_th = jsonDict_url_th3
                            b.urlSmall = NSURL(string: temp_url_th!)
                        } else {
                            // how to handle this?
                            print("ERROR thumbnail")
                            b.urlSmall = NSURL()
                        }
                    }
                }
                
                var temp_profile_picture_url: String?
                if let jsonDict_url_p1 = json["caption"] as? NSDictionary {
                    if let jsonDict_url_p2 = jsonDict_url_p1["from"] as? NSDictionary {
                        if let jsonDict_url_p3 = jsonDict_url_p2["profile_picture"] as? String {
                            temp_profile_picture_url = jsonDict_url_p3
                            b.urlProfilePicture = NSURL(string: temp_profile_picture_url!)
                        } else {
                            // how to handle this?
                            print("ERROR profile pic url")
                            b.urlProfilePicture = NSURL()
                        }
                    }
                }
                
                var temp_username: String?
                if let jsonDict_url_u1 = json["caption"] as? NSDictionary {
                    if let jsonDict_url_u2 = jsonDict_url_u1["from"] as? NSDictionary {
                        if let jsonDict_url_u3 = jsonDict_url_u2["username"] as? String {
                            temp_username = jsonDict_url_u3
                            b.user = temp_username
                        } else {
                            // how to handle this?
                            print("ERROR username")
                            b.user = "Anonymous"
                        }
                    }
                }
                
                if let jsonDict_url_t1 = json["caption"] as? NSDictionary {
                    if let jsonDict_url_t2 = jsonDict_url_t1["created_time"] as? String {
                        if let temp_int_timestamp = Int(jsonDict_url_t2) {
                            b.published = temp_int_timestamp
                        } else {
                            // how to handle this?
                            print("ERROR (inner) timestamp")
                            b.published = 0
                        }
                    } else {
                        // how to handle this?
                        print("ERROR timestamp")
                        b.published = 0
                    }
                }
                
                list.append(b)
                
                // Max size on list
                if list.count == 25 {
                    break
                }
            }
        }
        return list
    }
    
    func getPhotoObject(id: Int, completionHandler: (photoObject: InstagramPhotoObject, error: Bool) -> ()) {
        // mock
        let url = NSURL(string: "http://images.freeimages.com/images/previews/23c/soccer-ball-and-grass-1550139.jpg")!
        let urlSmall = NSURL(string: "http://images.freeimages.com/images/previews/23c/soccer-ball-and-grass-1550139.jpg")!
        let published = Functions.getCurrentTimeInSeconds() - 1000
        let user = "Test User"
        let urlProfilePicture = NSURL(string: "http://images.freeimages.com/images/previews/a80/venetian-mask-1516474.jpg")!
        let obj = InstagramPhotoObject(url: url, urlSmall: urlSmall, published: published, user: user, urlProfilePicture: urlProfilePicture)
        completionHandler(photoObject: obj, error: false)
    }
}

//