//
//  Settings.swift
//  AppServices
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation


/// Define the setings to filter the result
struct Settings {
    
    static let shared: Settings = Settings()
    
    /// maximum number of results to fetch, can be udated in App Settings > Earthquakes > Results
    var maxResults: Int{
        let defaultValue = 20
        var maxResults = UserDefaults.standard.integer(forKey: "search_max_results_preference")
        if maxResults == 0{
            UserDefaults.standard.set(defaultValue, forKey: "search_max_results_preference")
            maxResults = defaultValue
        }
        return maxResults
    }
    
    
    /// Distance maximum for the searches, can be udated in App Settings > Earthquakes > Disatnce
    var distance: Int{
        let defaultValue = 1000
        var distance = UserDefaults.standard.integer(forKey: "search_distance_preference")
        if distance == 0{
            UserDefaults.standard.set(defaultValue, forKey: "search_distance_preference")
            distance = defaultValue
        }
        return distance
    }
    
    
    /// The maximum antiquity of events, can be udated in App Settings > Earthquakes > Hours ago
    var hoursAgo: Int{
        let defaultValue = 35000
        var hoursAgo = UserDefaults.standard.integer(forKey: "search_hours_preference")
        if hoursAgo == 0{
            UserDefaults.standard.set(defaultValue, forKey: "search_hours_preference")
            hoursAgo = defaultValue
        }
        return hoursAgo
    }
}
