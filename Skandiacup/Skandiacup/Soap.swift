//
//  Soap.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

protocol Soap {
    func getArena(id: [Int]) -> [Arena]?
}