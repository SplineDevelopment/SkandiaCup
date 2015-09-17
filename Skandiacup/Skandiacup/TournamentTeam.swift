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
    
    required convenience init?(coder decoder: NSCoder) {
        self.init()
        self.id = decoder.decodeObjectForKey("TournamentTeamId") as? Int
        self.name = decoder.decodeObjectForKey("TournamentTeamName") as? String
        self.clubId = decoder.decodeObjectForKey("TournamentTeamClubId") as? Int
        self.matchGroupId = decoder.decodeObjectForKey("TournamentTeamMatchGroupId") as? Int
        self.matchClassId = decoder.decodeObjectForKey("TournamentTeamMatchClassId") as? Int
        self.tournamentTeamRegistrationId = decoder.decodeObjectForKey("TournamentTeamRegistrationId") as? Int
        self.updateTimestamp = decoder.decodeObjectForKey("TournamentTeamUpdateTimeStamp") as? String
        self.shirtColor = decoder.decodeObjectForKey("TournamentTeamShirtColor") as? String
        self.countryCode = decoder.decodeObjectForKey("TournamentTeamUpdateCountryCode") as? String
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
