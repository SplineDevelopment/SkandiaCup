//
//  FavoriteTeams.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
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