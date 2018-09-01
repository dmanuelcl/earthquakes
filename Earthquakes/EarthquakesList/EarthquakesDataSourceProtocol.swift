//
//  EarthquakesDataSource.swift
//  Earthquakes
//
//  Created by Dani Manuel Céspedes Lara on 9/1/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import UIKit
import AppDomain
import MapKit


/// Allow fetch earquakes may be used from UIViewController
protocol EarthquakesDataSourceProtocol{
    
    /// The coordinate used in te most recent search
    var currentSearchCoordiate: CLLocationCoordinate2D? {get}
    
    /// The magnitude used in te most recent search
    var currentMagnitude: EarthquakeMagnitude? {get}
    
    /// Current earthquakes
    var earthquakes: [Earthquake] {get}
    
    /// Get every earthquakes who have taken place near the given location
    ///
    /// - Parameters:
    ///   - longitude: Longitude to create the search location
    ///   - latitude: Latitude to create the search location
    ///   - completion: Invoked with the results obtained
    func fetchEarthquakesIn(longitude: Double, latitude: Double, completion: @escaping([Earthquake]) -> Void)
    
    
    /// Get every earthquakes based on its magnitude
    ///
    /// - Parameters:
    ///   - maginute: Earthquakes magnitude to filter
    ///   - completion: Invoked with the results obtained
    func fetchEarthquakesFor(magnitude: EarthquakeMagnitude, completion: @escaping([Earthquake]) -> Void)
}
