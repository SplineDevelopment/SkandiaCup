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
    
    func getAllPhotoObjects(completionHandler: (photoObjects: [InstagramPhotoObject]) -> ()) {
        let arr = [InstagramPhotoObject]()
        completionHandler(photoObjects: arr)
    }
    
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
