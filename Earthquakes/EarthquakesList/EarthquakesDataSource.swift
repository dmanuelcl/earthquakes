//
//  EarthquakesDataSource.swift
//  Earthquakes
//
//  Created by Dani Manuel Céspedes Lara on 9/1/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation
import AppDomain
import MapKit

class EarthquakesDataSource: EarthquakesDataSourceProtocol{
    
    var currentSearchCoordiate: CLLocationCoordinate2D? = nil
    
    var currentMagnitude: EarthquakeMagnitude? = nil
    
    var earthquakes: [Earthquake] = []
    
    func fetchEarthquakesIn(longitude: Double, latitude: Double, completion: @escaping ([Earthquake]) -> Void) {
        
    }
    
    func fetchEarthquakesFor(magnitude: EarthquakeMagnitude, completion: @escaping ([Earthquake]) -> Void) {
        
    }
    
}
