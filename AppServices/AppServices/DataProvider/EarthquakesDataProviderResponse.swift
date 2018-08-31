//
//  EarthquakesDataProviderResponse.swift
//  AppServices
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation
import AppDomain



/// Conformance to AppDomain.EarthquakesDataProvider to provide Earthquakes data
public class EarthquakesDataProvider: AppDomain.EarthquakesDataProvider {
    
    public var dataFilters: EarthquakesDataFilters
    
    internal var apiManager: ApiManager
    
    public init(apiManager: ApiManager) {
        self.dataFilters = EarthquakesDataFilters()
        self.apiManager = apiManager
    }
    
    public func getRecentEarthquakes(completion: @escaping EarthquakesDataProviderResponse) {
        
    }
    
    public func getEarthquakes(longitude: Double, latitude: Double, completion: @escaping EarthquakesDataProviderResponse) {
        
    }
    
    public func getEarthquakes(maginute: EarthquakeMagnitude, completion: @escaping EarthquakesDataProviderResponse) {
        
    }
    
}
