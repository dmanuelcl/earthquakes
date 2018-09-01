//
//  ApiParameterConvertible.swift
//  AppServices
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation


/// Allowed to be used in api request
public protocol ApiParameterConvertible {
    
    /// Receiver's api parameter representation
    ///
    /// - Returns: Api parameter representation
    func apiParameters() -> String
}
