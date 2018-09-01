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
    
    private let dataProvider: EarthquakesDataProvider
    
    init(dataProvider: EarthquakesDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchEarthquakesIn(longitude: Double, latitude: Double, completion: @escaping ([Earthquake]) -> Void) {
        self.currentSearchCoordiate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.dataProvider.getEarthquakes(longitude: longitude, latitude: latitude) { (earthquakes) in
            self.earthquakes = earthquakes
            completion(earthquakes)
        }
    }
    
    func fetchEarthquakesFor(magnitude: EarthquakeMagnitude, completion: @escaping ([Earthquake]) -> Void) {
        self.currentMagnitude = magnitude
        self.dataProvider.getEarthquakes(maginute: magnitude) { (earthquakes) in
            self.earthquakes = earthquakes
            completion(earthquakes)
        }
    }
    
}
