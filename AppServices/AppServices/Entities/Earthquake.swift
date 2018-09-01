//
//  Earthquake.swift
//  AppServices
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation
import AppDomain



// MARK: - Add conformance to Decodable to allow map the api response to Earthquake objects
extension Earthquake: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        enum NestedCodingKeys: String, CodingKey {
            case properties
            case geometry
        }
        
        case magnitude = "mag"
        case place
        case time
        case coordinates
    }
    
    public init(from decoder: Decoder) throws{
        let decoderContainer = try decoder.container(keyedBy: CodingKeys.NestedCodingKeys.self)
        let propertiesContainer = try decoderContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .properties)
        
        var magnitude: EarthquakeMagnitude?
        if let _magnitude = try? propertiesContainer.decode(Double?.self, forKey: .magnitude){
            magnitude = EarthquakeMagnitude(magnitude: _magnitude ?? 1.0)
        }
        
        let place: String = try propertiesContainer.decode(String.self, forKey: .place)
        let time: Date = try propertiesContainer.decode(Date.self, forKey: .time)
        
        let geometryContainer = try decoderContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .geometry)
        var coordinatesContainer = try geometryContainer.nestedUnkeyedContainer(forKey: .coordinates)
        let longitude: Double = try coordinatesContainer.decode(Double.self)
        let latitude: Double = try coordinatesContainer.decode(Double.self)
        let depth: Double = try coordinatesContainer.decode(Double.self)
        self.init(magnitude: magnitude, place: place, time: time, latitude: latitude, longitude: longitude, depth: depth)
    }
}
