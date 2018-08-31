//
//  Earthquake.swift
//  AppServices
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation
import AppDomain



// MARK: - Add conformance to Decodable
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
        let _magnitude: Double = try propertiesContainer.decode(Double.self, forKey: .magnitude)
        
        guard let magnitude = EarthquakeMagnitude(magnitude: _magnitude) else {
            throw DecodingError.dataCorrupted(DecodingError.Context.init(codingPath: [CodingKeys.magnitude], debugDescription: "Invalid magnitude"))
        }
        
        let place: String = try propertiesContainer.decode(String.self, forKey: .place)
        let time: Date = try propertiesContainer.decode(Date.self, forKey: .time)
        
        let geometryContainer = try decoderContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .geometry)
        var coordinatesContainer = try geometryContainer.nestedUnkeyedContainer(forKey: .coordinates)
        let latitude: Double = try coordinatesContainer.decode(Double.self)
        let longitude: Double = try coordinatesContainer.decode(Double.self)
        let depth: Double = try coordinatesContainer.decode(Double.self)
        self.init(magnitude: magnitude, place: place, time: time, latitude: latitude, longitude: longitude, depth: depth)
    }
}
