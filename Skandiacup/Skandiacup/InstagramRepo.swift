//
//  InstagramRepo.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

protocol InstagramRepo {
    func getAllPhotoObjects(completionHandler: (photoObjects: [InstagramPhotoObject], error: Bool) -> ())
    func getPhotoObject(id: Int, completionHandler: (photoObject: InstagramPhotoObject, error: Bool) -> ())
}