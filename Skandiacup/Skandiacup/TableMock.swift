//
//  TableMock.swift
//  Skandiacup
//
//  Created by Eirik Sandberg on 26.09.15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation
class TableMock {
    var teams: [String] = []
    var points: [Int] = []
    var gamesPlayed: [Int] = []
    var goalsFor: [Int] = []
    var goalsAgainst: [Int] = []
    var wins: [Int] = []
    var draws: [Int] = []
    var losses: [Int] = []
    
    init(teams: [String], points: [Int], gamesPlayed: [Int], goalsFor: [Int], wins: [Int], goalsAgainst: [Int], draws: [Int], losses: [Int]){
        self.teams = teams
        self.points = points
        self.gamesPlayed = gamesPlayed
        self.goalsFor = goalsFor
        self.goalsAgainst = goalsAgainst
        self.wins = wins
        self.draws = draws
        self.losses = losses
    }
    
    static func generateAMock() -> TableMock{
        let teams = ["Vardal", "Gjøvik-lyn", "Vind", "Lensbygda"]
        let points = [9,6,6,0]
        let gamesPlayed = [3,3,3,3]
        let goalsScored = [20,12,11,7]
        let wins = [3,2,2,0]
        let goalsAgainst = [2,5,7,20]
        let draws = [0,0,0,0]
        let losses = [0,1,1,3]
        return TableMock(teams: teams, points: points, gamesPlayed: gamesPlayed, goalsFor: goalsScored, wins: wins, goalsAgainst: goalsAgainst, draws: draws, losses: losses)
    }
}
    