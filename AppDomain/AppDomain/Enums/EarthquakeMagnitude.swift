//
//  EarthquakeMagnitude.swift
//  AppDomain
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation


/// Define the available earthquakes magnitude
///
public enum EarthquakeMagnitude {
    case extreme(Double)
    case high(Double)
    case moderate(Double)
    case low(Double)
    
    init?(magnitude: Double){
        return nil
    }
    
    public var magnitude: Double{
        switch self {
        case .low(let magnitude):
            return magnitude
        case .moderate(let magnitude):
            return magnitude
        case .high(let magnitude):
            return magnitude
        case .extreme(let magnitude):
            return magnitude
        }
    }
}
