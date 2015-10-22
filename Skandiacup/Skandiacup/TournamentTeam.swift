//
//  TournamentTeam.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 31/08/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class TournamentTeam : NSObject, NSCoding {
    var id: Int?
    var name: String?
    var clubId: Int?
    var matchGroupId: Int?
    var matchClassId: Int?
    var tournamentTeamRegistrationId: Int?
    var updateTimestamp: String?
    var shirtColor: String?
    var countryCode: String?
    
    override init() {
        super.init()
    }
    
    init(id: Int, name: String, clubId: Int, matchGroupId: Int, matchClassId: Int, tournamentTeamRegistrationId: Int, updateTimestamp: String, shirtColor: String, countryCode: String) {
        self.id = id
        self.name = name
        self.clubId = clubId
        self.matchGroupId = matchGroupId
        self.matchClassId = matchClassId
        self.tournamentTeamRegistrationId = tournamentTeamRegistrationId
        self.updateTimestamp = updateTimestamp
        self.shirtColor = shirtColor
        self.countryCode = countryCode
    }
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        self.id = decoder.decodeObjectForKey("TournamentTeamId") as? Int
        self.name = decoder.decodeObjectForKey("TournamentTeamName") as? String
        self.clubId = decoder.decodeObjectForKey("TournamentTeamClubId") as? Int
        self.matchGroupId = decoder.decodeObjectForKey("TournamentTeamMatchGroupId") as? Int
        self.matchClassId = decoder.decodeObjectForKey("TournamentTeamMatchClassId") as? Int
        self.tournamentTeamRegistrationId = decoder.decodeObjectForKey("TournamentTeamTournamentTeamRegistrationId") as? Int
        self.updateTimestamp = decoder.decodeObjectForKey("TournamentTeamUpdateTimestamp") as? String
        self.shirtColor = decoder.decodeObjectForKey("TournamentTeamShirtColor") as? String
        self.countryCode = decoder.decodeObjectForKey("TournamentTeamCountryCode") as? String
    }
    
    func encodeWithCoder(coder: NSCoder) {
        coder.encodeObject(self.id, forKey: "TournamentTeamId")
        coder.encodeObject(self.name, forKey: "TournamentTeamName")
        coder.encodeObject(self.clubId, forKey: "TournamentTeamClubId")
        coder.encodeObject(self.matchGroupId, forKey: "TournamentTeamMatchGroupId")
        coder.encodeObject(self.matchClassId, forKey: "TournamentTeamMatchClassId")
        coder.encodeObject(self.tournamentTeamRegistrationId, forKey: "TournamentTeamTournamentTeamRegistrationId")
        coder.encodeObject(self.updateTimestamp, forKey: "TournamentTeamUpdateTimestamp")
        coder.encodeObject(self.shirtColor, forKey: "TournamentTeamShirtColor")
        coder.encodeObject(self.countryCode, forKey: "TournamentTeamCountryCode")
    }
}
