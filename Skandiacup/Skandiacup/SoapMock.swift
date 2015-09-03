//
//  SoapMock.swift
//  Skandiacup
//
//  Created by Bjørn Hoxmark on 03/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class SoapMock: Soap {
    func getArena(id: [String]) -> [Arena]? {
        var arena = [Arena]()
        
        var a1 = Arena()
        a1.arenaID = 1
        a1.arenaName = "Bane 1"
        a1.arenaDescription = "Sor-Ost"
        arena.append(a1)

        var a2 = Arena()
        a2.arenaID = 2
        a2.arenaName = "Bane 2"
        a2.arenaDescription = "Nord"
        arena.append(a2)
        print(arena)
        return arena
    }
    

}