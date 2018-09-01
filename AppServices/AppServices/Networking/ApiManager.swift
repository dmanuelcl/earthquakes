//
//  ApiManager.swift
//  AppServices
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation


/// Classes conforming this protocol can be used to make api calls
public protocol ApiManager {
    
    /// Make and Http request with the parameters provided
    ///
    /// - Parameters:
    ///   - parameters: Parameter to use in the request
    ///   - completion: Appi call result
    func requestData(withParameters parameters: [ApiParameterConvertible], completion: @escaping (Error?, Data?) -> Void)
}
