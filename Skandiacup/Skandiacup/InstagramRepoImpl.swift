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
        print("using InstagramRepoImpl")
    }
    
    private func sendReceive(request: NSMutableURLRequest, completionHandler: (responseData: NSData) -> Void) -> Void {
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                print("error=\(error)")
                return
            }
//            let responseString = String(data: data!, encoding: NSUTF8StringEncoding)
            print("Sending data over network!")
//            if responseString != nil {
                //print(responseString)
            completionHandler(responseData: data!)
            /*
            } else {
                print("responseString is nil")
            }
            */
        }
        task.resume()
    }
    
    func getAllPhotoObjects(completionHandler: (photoObjects: [InstagramPhotoObject]) -> ()) {
        /*
        let url = NSURL(string: "http://images.freeimages.com/images/previews/23c/soccer-ball-and-grass-1550139.jpg")!
        let urlSmall = NSURL(string: "http://images.freeimages.com/images/previews/23c/soccer-ball-and-grass-1550139.jpg")!
        let published = Functions.getCurrentTimeInSeconds() - 1000
        let user = "Test User"
        let urlProfilePicture = NSURL(string: "http://images.freeimages.com/images/previews/a80/venetian-mask-1516474.jpg")!
        let obj = InstagramPhotoObject(url: url, urlSmall: urlSmall, published: published, user: user, urlProfilePicture: urlProfilePicture)
        let n = Int(arc4random_uniform(20))
        print(n)
        print("hei")
        for i in 0...n {
            arr.append(obj)
        }
        //arr.append(obj)
        //arr.append(obj)
        */
        
        let get_uri = "https://api.instagram.com/v1/tags/sun/media/recent?client_id=7b9d2e2f9ef04d81939c7c61f381184e"
        
        //var json = getJSON(get_uri)
        
        let req = NSMutableURLRequest(URL: NSURL(string: get_uri)!)
        
        sendReceive(req) { (responseData) -> Void in
//            var arr = [InstagramPhotoObject]()
            //print(responseData)
            //print(String(data: responseData, encoding: NSUTF8StringEncoding))
            print("heixxx")
            do {
                let anyObj: AnyObject? = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions(rawValue: 0))
                //print(anyObj)
                print("(------------)")
                // this is not safe!
                let test_o = anyObj as! NSDictionary
                //print(test_o["data"])
                // ANYOBJ then ["data"] before processing on
                // ALSO:: profile picture and usename is under ["caption"]["from"]
                // use anyObj
                print("parsing inc")
                let arr = self.parseJson(test_o["data"]!)
                completionHandler(photoObjects: arr)
            } catch let error as NSError {
                print(error)
            }
        }
        
        
//        completionHandler(photoObjects: arr)
    }
    
    func parseJson(anyObj:AnyObject) -> Array<InstagramPhotoObject>{
        
        var list:Array<InstagramPhotoObject> = []
        
        print("ARRAYYYY")
        
       // print
        
        //print(anyObj)
        
        if anyObj is Array<AnyObject> {
            print("test")
            //var b:InstagramPhotoObject = InstagramPhotoObject()
            
            for json in anyObj as! Array<AnyObject>{
                let b:InstagramPhotoObject = InstagramPhotoObject()
                print(json)
                var temp_url: String?
                if let jsonDict_url_1 = json["images"] as? NSDictionary {
                    if let jsonDict_url_2 = jsonDict_url_1["standard_resolution"] as? NSDictionary {
                        if let jsonDict_url_3 = jsonDict_url_2["url"] as? String {
                            temp_url = jsonDict_url_3
                            b.url = NSURL(string: temp_url!)
                        } else {
                            // how to handle this?
                            print("ERROR")
                            b.url = NSURL()
                        }
                    }
                }
                // mock
                
                let urlSmall = NSURL(string: "http://images.freeimages.com/images/previews/23c/soccer-ball-and-grass-1550139.jpg")!
                let published = Functions.getCurrentTimeInSeconds() - 1000
                let user = "Test User"
                let urlProfilePicture = NSURL(string: "http://images.freeimages.com/images/previews/a80/venetian-mask-1516474.jpg")!
                
                b.urlSmall = urlSmall
                b.published = published
                b.user = user
                b.urlProfilePicture = urlProfilePicture
                
                //
                /*
                var temp_url_1 = json["images"] as AnyObject!
                var temp_url_2 = temp_url_1["standard_resolution"] as AnyObject!
                var temp_url_3 = (temp_url_2["url"] as AnyObject? as? String) ?? ""
                */
//                b.url = NSURL(string: temp_url)
//                var temp_url_small = (json["images"]["thumbnail"]["url"] as AnyObject? as? String) ?? ""
//                b.urlSmall = NSURL(string: temp_url_small)
                //b.urlSmall = NSURL()
                // TODO!!
                //let tempProfilePic = (json["username"] as AnyObject? as? String) ?? "" // to get rid of null
                //b.urlProfilePicture = NSURL(string: tempProfilePic)
                //b.user = (json["username"] as AnyObject? as? String) ?? "" // to get rid of null
                //b.published = (json["created_time"] as AnyObject? as? Int) ?? 0
                
                list.append(b)
                // Max size on list
                
                if list.count == 15 {
                    break
                }
                
                print(list)
            }// for
            
        } // if
        
        return list
        
    }//func
    
    func getPhotoObject(id: Int, completionHandler: (photoObject: InstagramPhotoObject) -> ()) {
        // mock
        let url = NSURL(string: "http://images.freeimages.com/images/previews/23c/soccer-ball-and-grass-1550139.jpg")!
        let urlSmall = NSURL(string: "http://images.freeimages.com/images/previews/23c/soccer-ball-and-grass-1550139.jpg")!
        let published = Functions.getCurrentTimeInSeconds() - 1000
        let user = "Test User"
        let urlProfilePicture = NSURL(string: "http://images.freeimages.com/images/previews/a80/venetian-mask-1516474.jpg")!
        let obj = InstagramPhotoObject(url: url, urlSmall: urlSmall, published: published, user: user, urlProfilePicture: urlProfilePicture)
        completionHandler(photoObject: obj)
    }
}

