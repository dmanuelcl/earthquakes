//
//  ApiParameter.swift
//  AppServices
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation


/// Avalibale paramaters to use in api calls
///
/// - starttime: Limit to events on or after the specified start time.
/// - latitude: Specify the latitude to be used for a radius search
/// - longitude: Specify the longitude to be used for a radius search
/// - maxradiuskm: Limit to events within the specified maximum number of kilometers from the geographic point defined by the latitude and longitude parameters
/// - limit: Limit the results to the specified number of events
/// - minmagnitude: Limit to events with a magnitude larger than the specified minimum
enum ApiParameter: ApiParameterConvertible {
    case starttime(Date)
    case latitude(Double)
    case longitude(Double)
    case maxradiuskm(Int)
    case limit(Int)
    case minmagnitude(Double)
    
    func apiParameters() -> String {
        switch self {
        case .starttime(let date):
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZ"
            return "starttime=\(dateFormatter.string(from: date))"
        case .latitude(let latitude):
            return "latitude=\(latitude)" 
        case .longitude(let longitude):
            return "longitude=\(longitude)"
        case .maxradiuskm(let km):
            return "maxradiuskm=\(km)"
        case .limit(let limit):
            return "limit=\(limit)"
        case .minmagnitude(let magnitude):
            return "minmagnitude=\(magnitude)"
        }
    }
}
