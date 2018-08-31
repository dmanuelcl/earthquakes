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
    
    
    /// Create an instance of EarthquakeMagnitude usign the magnitude given
    ///
    public init?(magnitude: Double){
        guard magnitude > 0 else {
            return nil
        }
        if magnitude < 1.5{
            self = .low(magnitude)
            return
        }
        
        if magnitude <= 4.5{
            self = .moderate(magnitude)
            return
        }
        
        if magnitude <= 7{
            self = .high(magnitude)
            return
        }
        
        self = .extreme(magnitude)
    }
    
    
    /// Return the magnitude stored in the enum
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
