//
//  InstaPhotoCell.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation
import UIKit

class InstaPhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var instaPhotoObject : InstagramPhotoObject?
    var index : Int?
}
