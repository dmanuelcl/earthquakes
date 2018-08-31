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
    
    func apiParameters() -> [AnyHashable : Any] {
        return [:]
    }
}

extension Array: ApiParameterConvertible where Element: ApiParameterConvertible{
    public func apiParameters() -> [AnyHashable : Any] {
        var parameters: [AnyHashable : Any] = [:]
        for element in self{
            element.apiParameters().forEach { (args) in
                let (key, value) = args
                parameters[key] = value
            }
        }
        return parameters
    }
}
