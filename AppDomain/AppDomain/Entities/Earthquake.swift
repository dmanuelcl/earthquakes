//
//  Earthquake.swift
//  AppDomain
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation


/// Represents the information of an earthquake
public struct Earthquake {
    public let magnitude: EarthquakeMagnitude
    public let place: String
    public let time: Date
    public let latitude: Double
    public let longitude: Double
    public let depth: Double
    
    public init(magnitude: EarthquakeMagnitude, place: String, time: Date, latitude: Double, longitude: Double, depth: Double){
        self.magnitude = magnitude
        self.place = place
        self.time = time
        self.latitude = latitude
        self.longitude = longitude
        self.depth = depth
    }
}
