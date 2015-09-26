//
//  TournamentMatchStatus.swift
//  Skandiacup
//
//  Created by Borgar Lie on 26/09/15.
//  Copyright © 2015 Spline Development. All rights reserved.
//

import Foundation

class TournamentMatchStatus {
    var needTotalRefresh : Bool
    var existsNewOrUpdatedMatches : Bool
    
    init() {
        self.needTotalRefresh = false
        self.existsNewOrUpdatedMatches = false
    }
    
    /*
    <xsd:complexType name="TournamentMatchStatus">
    <xsd:all>
    <xsd:element name="needTotalRefresh" type="xsd:boolean" nillable="true"/>
    <xsd:element name="existsNewOrUpdatedMatches" type="xsd:boolean" nillable="true"/>
    <xsd:element name="existsDeletedMatches" type="xsd:boolean" nillable="true"/>
    <xsd:element name="matchesCount" type="xsd:int" nillable="true"/>
    <xsd:element name="teamCount" type="xsd:int" nillable="true"/>
    <xsd:element name="DeletedMatches" type="tns:ArrayOfTournamentmatchdeleted" nillable="true"/>
    </xsd:all>
    </xsd:complexType>
    */
}