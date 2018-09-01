//
//  ApiParameter.swift
//  AppServices
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation

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
