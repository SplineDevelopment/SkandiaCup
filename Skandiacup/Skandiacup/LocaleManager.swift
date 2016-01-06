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
    
    return default: ->  locale == "en"
    */
    
   
    var teamCellClass: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Klasse"
            }
            return "Class"
        }
    }
    
    var teamCellGroup: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Gruppe"
            }
            return "Group"
        }
    }
    
    
    /*
    Sex picker values
    */
    
    var male: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Gutter"
            }
            return "Boys"
        }
    }
    
    var female: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Jenter"
            }
            return "Girls"
        }
    }
    
    var all: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Alle"
            }
            return "All"
        }
    }
    
    /*
    MatchViewController
    */
    var penaltyReason: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "vant etter straffesparkkonkurranse"
            }
            return "won after a penalty shootout"
        }
    }
    
    var walkoverReason: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "vant på walkover"
            }
            return "won by walkover"
        }
    }
    
    /*
    EndPlayGamesViewController
    */
    var matchHeaders: [String: String] {
        get{
            if(locale == "nb" || locale == "nn"){
                return ["1.0000": "Finale", "2.0000": "Semifinaler", "4.0000": "Kvartfinaler", "8.0000": "Åttendedelsfinaler", "16.0000": "Sekstensdelsfinaler", "32.0000": "32-delsfinale", "64.0000": "64-delsfinaler", "128.0000": "128-delsfinaler", "256.0000": "256-delsfinaler"]
            }
            return ["1.0000": "Final", "2.0000": "Semi-finals", "4.0000": "Quarter-finals", "8.0000": "8th-finals", "16.0000": "16th-finals", "32.0000": "32nd-finals", "64.0000": "64th-finals", "128.0000": "128th-finals", "256.0000": "256th-finals"]
        }
    }
    
    /*
    TeamViewController
    */
    var tableHeader: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Tabell"
            }
            return "Table"
        }
    }
    
    var upcomingMatches: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Kommende kamper"
            }
            return "Upcoming matches"
        }
    }
    
    var playedMatches: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Kamper spilt"
            }
            return "Matches played"
        }
    }
    
    var otherMatches: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Andre"
            }
            return "Other"
        }
    }
    
    var noUpcomingMatches: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Ingen kommende kamper"
            }
            return "No upcoming matches"
        }
    }
    
    var openInInstagramErrorName: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Oops!"
            }
            return "Oops!"
        }
    }
    var openInInstagramErrorText: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Instagram er ikke installert på denne enheten"
            }
            return "Instagram is not installed on this device"
        }
    }
    
    var countryLabel: String {
        get{
            if(locale == "nb" || locale == "nn"){
                return "Land"
            }
            return "Country"
        }
    }
    
    var genderLabel: String{
        get{
            if(locale == "nb" || locale == "nn"){
                return "Kjønn"
            }
            return "Gender"
        }
    }
    
    var searchBoxPlaceholder: String{
        get{
            if(locale == "nb" || locale == "nn"){
                return "Søk etter lagnavn"
            }
            return "Search for team name"
        }
    }
}

