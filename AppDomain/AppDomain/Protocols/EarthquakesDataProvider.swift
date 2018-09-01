//
//  EarthquakesDataProvider.swift
//  AppDomain
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation

/// alias for all EarthquakesDataProvider responses
public typealias EarthquakesDataProviderResponse = ([Earthquake]) -> Void

/// Allow obtain earthquakes based on location or magnitude
public protocol EarthquakesDataProvider{

    /// Get every earthquakes who have taken place near the current user location
    ///
    /// - Parameter completion: Invoked with the results obtained
    func getRecentEarthquakes(completion: @escaping EarthquakesDataProviderResponse)
    
    
    /// Get every earthquakes who have taken place near the given location
    ///
    /// - Parameters:
    ///   - longitude: Longitude to create the search location
    ///   - latitude: Latitude to create the search location
    ///   - completion: Invoked with the results obtained
    func getEarthquakes(longitude: Double, latitude: Double, completion: @escaping EarthquakesDataProviderResponse)
    
    
    /// Get every earthquakes based on its magnitude
    ///
    /// - Parameters:
    ///   - maginute: Earthquakes magnitude to filter
    ///   - completion: Invoked with the results obtained
    func getEarthquakes(maginute: EarthquakeMagnitude, completion: @escaping EarthquakesDataProviderResponse)
}
