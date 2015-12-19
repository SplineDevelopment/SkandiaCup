//
//  InstagramPhotoObject.swift
//  Skandiacup
//
//  Created by Borgar Lie on 23/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class InstagramPhotoObject : NSObject, NSCoding {
    var id: String?
    var url : NSURL?
    var urlSmall : NSURL?
    var published : Int?
    var user : String?
    var urlProfilePicture : NSURL?
    
    // likes?
    
    override init() {
        super.init()
    }
    
    init(url : NSURL, urlSmall : NSURL, published : Int, user : String, urlProfilePicture : NSURL) {
        self.url = url
        self.urlSmall = urlSmall
        self.published = published
        self.user = user
        self.urlProfilePicture = urlProfilePicture
    }
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        let tempUrl = decoder.decodeObjectForKey("InstagramPhotoUrl") as! String
        self.url = NSURL(fileURLWithPath: tempUrl)
        let tempUrlSmall = decoder.decodeObjectForKey("InstagramPhotoSmallUrl") as! String
        self.urlSmall = NSURL(fileURLWithPath: tempUrlSmall)
        self.published = decoder.decodeObjectForKey("InstagramPublished") as? Int
        self.user = decoder.decodeObjectForKey("InstagramUser") as? String
        let tempurlProfilePicture = decoder.decodeObjectForKey("InstagramProfilePictureUrl") as! String
        self.urlProfilePicture = NSURL(fileURLWithPath: tempurlProfilePicture)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(url!.absoluteString, forKey: "InstagramPhotoUrl")
        coder.encodeObject(urlSmall!.absoluteString, forKey: "InstagramPhotoSmallUrl")
        coder.encodeObject(published, forKey: "InstagramPublished")
        coder.encodeObject(user, forKey: "InstagramUser")
        coder.encodeObject(urlProfilePicture!.absoluteString, forKey: "InstagramProfilePictureUrl")
    }
}