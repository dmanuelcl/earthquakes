//
//  Earthquake.swift
//  Earthquakes
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import UIKit
import AppDomain

extension Earthquake{
    var magnitudeColor: UIColor{
        guard let magnitude = self.magnitude else {
            return UIColor.gray
        }
        switch magnitude {
        case .low:
            return UIColor.green
        case .moderate:
            return UIColor.yellow
        case .high:
            return UIColor.orange
        case .extreme:
            return UIColor.red
        }
    }
    
    var magnitudeImage: UIImage{
        guard let magnitude = self.magnitude else {
            return #imageLiteral(resourceName: "map_pin_gray")
        }
        switch magnitude {
        case .low:
            return #imageLiteral(resourceName: "map_pin_green")
        case .moderate:
            return #imageLiteral(resourceName: "map_pin_yellow")
        case .high:
            return #imageLiteral(resourceName: "map_pin_orange")
        case .extreme:
            return #imageLiteral(resourceName: "map_pin_red")
        }
    }
}
