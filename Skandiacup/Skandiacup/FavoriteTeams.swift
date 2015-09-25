//
//  FavoriteTeams.swift
//  Skandiacup
//
//  Created by Eirik Sandberg on 10.09.15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class FavoriteTeams: NSObject, NSCoding {
    var favorites: NSMutableArray = NSMutableArray()
    
    func addFav(team: TournamentTeam){
           // favorites.append(team)
            favorites.addObject(team)
    }
    
    func removeFav(index: Int){
        favorites.removeObjectAtIndex(index)
    }
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        //self.available = decoder.decodeBoolForKey("available")
        let temp = decoder.decodeObjectForKey("favList")
        self.favorites = NSMutableArray(array: (temp as! NSArray) as Array)
    }
    
    func encodeWithCoder(coder: NSCoder) {
        //coder.encodeBool(self.available, forKey: "available")
        coder.encodeObject(favorites, forKey: "favList")
    }
}