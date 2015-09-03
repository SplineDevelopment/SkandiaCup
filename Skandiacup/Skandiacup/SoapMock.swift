//
//  SoapMock.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class SoapMock: Soap {
    func getArena(id: [Int]) -> [Arena]? {
        var arena = [Arena]()
        arena.append(Arena(arenaID: 1, arenaName: "Test1", arenaDescription: "Desc1", update_timestamp: "0"))
        arena.append(Arena(arenaID: 2, arenaName: "Test2", arenaDescription: "Desc2", update_timestamp: "123"))
        arena.append(Arena(arenaID: 3, arenaName: "Test3", arenaDescription: "Desc3", update_timestamp: "666"))
        return arena.filter({id.contains($0.arenaID!)})
    }
    

}