//
//  InstagramRepo.swift
//  Skandiacup
//
//  Created by Borgar Lie on 23/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

protocol InstagramRepo {
    func getAllPhotoObjects(completionHandler: (photoObjects: [InstagramPhotoObject]) -> ())
    func getPhotoObject(id: Int, completionHandler: (photoObject: InstagramPhotoObject) -> ())
}