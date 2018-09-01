//
//  EarthquakesDataProviderResponse.swift
//  AppServices
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation
import AppDomain
import MapKit

/// Conformance to AppDomain.EarthquakesDataProvider to provide Earthquakes data
public class EarthquakesDataProvider: AppDomain.EarthquakesDataProvider {
    
    internal var apiManager: ApiManager
    
    public init(apiManager: ApiManager) {
        self.apiManager = apiManager
    }
    
    var defaultParameters: [ApiParameter]{
        let settings = Settings.shared
        let now = Date()
        let starttime = now.addingTimeInterval(-TimeInterval(settings.hoursAgo * 60 * 60))
        return [
            .limit(settings.maxResults),
            .starttime(starttime),
            .maxradiuskm(settings.distance)
        ]
    }
    
    public func getRecentEarthquakes(completion: @escaping EarthquakesDataProviderResponse) {
        self.requestData(withParameters: self.defaultParameters, completion: completion)
    }
    
    public func getEarthquakes(longitude: Double, latitude: Double, completion: @escaping EarthquakesDataProviderResponse) {
        var parameters = self.defaultParameters
        parameters.append(.longitude(longitude))
        parameters.append(.latitude(latitude))
        self.requestData(withParameters: parameters, completion: completion)
    }
    
    public func getEarthquakes(maginute: EarthquakeMagnitude, completion: @escaping EarthquakesDataProviderResponse) {
        var parameters = self.defaultParameters
        parameters.append(.minmagnitude(maginute.magnitude))
        self.requestData(withParameters: parameters, completion: completion)
    }
    
    func requestData(withParameters parameters: [ApiParameterConvertible], completion: @escaping EarthquakesDataProviderResponse){
        self.apiManager.requestData(withParameters: parameters) { (error, data) in
            self.callCompletion(completion, mappingData: data)
        }
    }
    
    func callCompletion(_ completion: @escaping EarthquakesDataProviderResponse, mappingData data: Data?){
        guard let data = data else{
            completion([])
            return
        }
        let earthquakes = self.dataToEarthquakes(data: data)
        completion(earthquakes)
    }
    
    func dataToEarthquakes(data: Data) -> [Earthquake]{
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .millisecondsSince1970
        
        guard let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any] else {
            return []
        }
        guard let features = json["features"] else {
            return []
        }
        guard let featuresData = try? JSONSerialization.data(withJSONObject: features, options: []) else {
            return []
        }
        guard let results = try? jsonDecoder.decode([Earthquake].self, from: featuresData) else {
            return []
        }
        return results
    }
    
}
