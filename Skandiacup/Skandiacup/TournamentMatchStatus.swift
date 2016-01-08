//
//  TournamentMatchStatus.swift
//  Skandiacup
//
//  Copyright 2016 Bjørn Hoxmark, Borgar Lie, Eirik Sandberg, Jørgen Wilhelmsen
//

import Foundation

class TournamentMatchStatus {
    var needTotalRefresh : Bool
    var existsNewOrUpdatedMatches : Bool
    var teamCount : Int
    
    init() {
        self.needTotalRefresh = false
        self.existsNewOrUpdatedMatches = false
        self.teamCount = 0
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