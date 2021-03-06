//
//  TournamentMatch.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

struct TournamentMatch{
    static let maxCacheTime = 60
    var id: Int?
    var matchTXID: Int?
    var matchno: String?
    var classId: Int?
    var homeTeamId :Int?
    var homeTeamName: String?
    var awayTeamId: Int?
    var awayTeamName: String?
    var homeClubId: Int?
    var homeClubName: String?
    var awayClubId: Int?
    var awayClubName: String?
    var matchDate: String?
    var matchComment: String?
    var homeTeamText: String?
    var awayTeamText: String?
    var homegoal: String?
    var awaygoal: String?
    var fieldId: Int?
    var endGameLevel: Int?
    var sortOrder: String?
    var reason: String?
    var winner: String?
    var periodLengthInMinutes: String?
    var numberOfPeriodsInMatch: String?
    var UpdateTimeStamp: String?
    var matchGroupId: Int?
}

func emptyMatch()-> TournamentMatch{
    return TournamentMatch()
}