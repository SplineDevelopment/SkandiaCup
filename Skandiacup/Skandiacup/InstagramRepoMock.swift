//
//  InstagramRepoMock.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class InstagramRepoMock : InstagramRepo {
    func getAllPhotoObjects(completionHandler: (photoObjects: [InstagramPhotoObject], error: Bool) -> ()) {
        var arr = [InstagramPhotoObject]()
        let url = NSURL(string: "http://images.freeimages.com/images/previews/23c/soccer-ball-and-grass-1550139.jpg")!
        let urlSmall = NSURL(string: "http://images.freeimages.com/images/previews/23c/soccer-ball-and-grass-1550139.jpg")!
        let published = Functions.getCurrentTimeInSeconds() - 1000
        let user = "Test User"
        let urlProfilePicture = NSURL(string: "http://images.freeimages.com/images/previews/a80/venetian-mask-1516474.jpg")!
        let obj = InstagramPhotoObject(url: url, urlSmall: urlSmall, published: published, user: user, urlProfilePicture: urlProfilePicture)
        let n = Int(arc4random_uniform(20))
        for _ in 0...n {
            arr.append(obj)
        }
        //arr.append(obj)
        //arr.append(obj)
        completionHandler(photoObjects: arr, error: false)
    }
    
    func getPhotoObject(id: Int, completionHandler: (photoObject: InstagramPhotoObject, error: Bool) -> ()) {
        // mock
        let url = NSURL(fileURLWithPath: "http://images.freeimages.com/images/previews/23c/soccer-ball-and-grass-1550139.jpg")
        let urlSmall = NSURL(fileURLWithPath: "http://images.freeimages.com/images/previews/23c/soccer-ball-and-grass-1550139.jpg")
        let published = Functions.getCurrentTimeInSeconds() - 1000
        let user = "Test User"
        let urlProfilePicture = NSURL(fileURLWithPath: "http://images.freeimages.com/images/previews/a80/venetian-mask-1516474.jpg")
        let obj = InstagramPhotoObject(url: url, urlSmall: urlSmall, published: published, user: user, urlProfilePicture: urlProfilePicture)
        completionHandler(photoObject: obj, error: false)
    }
}
