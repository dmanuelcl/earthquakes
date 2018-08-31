//
//  ApiParameterConvertible.swift
//  AppServices
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation

public protocol ApiParameterConvertible {
    func apiParameters() -> [AnyHashable: Any]
}
