//
//  LocaleManager.swift
//  Skandiacup
//
//  Created by Jørgen Wilhelmsen on 04/01/16.
//  Copyright © 2016 Spline Development. All rights reserved.
//

import Foundation


class LocaleManager{
    var locale = ""
    init(){
        locale = NSLocale.preferredLanguages()[0].componentsSeparatedByString("-")[0]
    }
    
    /*
    Locale-specific names for use in TeamsViewController
    */
    
   
    var teamCellClass: String {
        get{
            if(locale == "en"){
                return "Class"
            }
            
            if(locale == "nb"){
                return "Klasse"
            }
            return ""
        }
    }
    
    var teamCellGroup: String {
        get{
            if(locale == "en"){
                return "Group"
            }
            
            if(locale == "nb"){
                return "Gruppe"
            }
            return ""
        }
    }
    
    
    /*
    Sex picker values
    */
    
    var male: String {
        get{
            if(locale == "en"){
                return "Boys"
            }
            
            if(locale == "nb"){
                return "Gutter"
            }
            return ""
        }
    }
    
    var female: String {
        get{
            if(locale == "en"){
                return "Girls"
            }
            
            if(locale == "nb"){
                return "Jenter"
            }
            return ""
        }
    }
    
    var all: String {
        get{
            if(locale == "en"){
                return "All"
            }
            
            if(locale == "nb"){
                return "Alle"
            }
            return ""
        }
    }
    
    /*
    MatchViewController
    */
    var penaltyReason: String {
        get{
            if(locale == "en"){
                return "won after a penalty shootout"
            }
            
            if(locale == "nb"){
                return "vant etter straffesparkkonkurranse"
            }
            return ""
        }
    }
    
    var walkoverReason: String {
        get{
            if(locale == "en"){
                return "won by walkover"
            }
            
            if(locale == "nb"){
                return "vant på walkover"
            }
            return ""
        }
    }
    
    /*
    EndPlayGamesViewController
    */
    var matchHeaders: [String: String] {
        get{
            if(locale == "en"){
                return ["1.0000": "Final", "2.0000": "Semi-finals", "4.0000": "Quarter-finals", "8.0000": "8th-finals", "16.0000": "16th-finals", "32.0000": "32nd-finals", "64.0000": "64th-finals", "128.0000": "128th-finals", "256.0000": "256th-finals"]
            }
            
            if(locale == "nb"){
                return ["1.0000": "Finale", "2.0000": "Semifinaler", "4.0000": "Kvartfinaler", "8.0000": "Åttendedelsfinaler", "16.0000": "Sekstensdelsfinaler", "32.0000": "32-delsfinale", "64.0000": "64-delsfinaler", "128.0000": "128-delsfinaler", "256.0000": "256-delsfinaler"]
            }
            return ["":""]
        }
    }
    
    /*
    TeamViewController
    */
    var tableHeader: String {
        get{
            if(locale == "en"){
                return "Table"
            }
            
            if(locale == "nb"){
                return "Tabell"
            }
            return ""
        }
    }
    
    var upcomingMatches: String {
        get{
            if(locale == "en"){
                return "Upcoming matches"
            }
            
            if(locale == "nb"){
                return "Kommende kamper"
            }
            return ""
        }
    }
    
    var playedMatches: String {
        get{
            if(locale == "en"){
                return "Matches played"
            }
            
            if(locale == "nb"){
                return "Kamper spilt"
            }
            return ""
        }
    }
    
    var otherMatches: String {
        get{
            if(locale == "en"){
                return "Other"
            }
            
            if(locale == "nb"){
                return "Andre"
            }
            return ""
        }
    }
    
    var noUpcomingMatches: String {
        get{
            if(locale == "en"){
                return "No upcoming matches"
            }
            
            if(locale == "nb"){
                return "Ingen kommende kamper"
            }
            return ""
        }
    }
    
    
}

