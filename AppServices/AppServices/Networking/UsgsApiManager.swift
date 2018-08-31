//
//  UsgsApiManager.swift
//  AppServices
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import Foundation

public struct UsgsApiManager: ApiManager {
    
    public static let shared: UsgsApiManager = UsgsApiManager()
    
    private let baseURL = "https://earthquake.usgs.gov/fdsnws/event/1/"
    let webServiceEndPoint = "query"
    let format = "?format=geojson&"
    
    public func requestData(withParameters parameter: [ApiParameterConvertible], completion: @escaping (Error?, Data?) -> Void){
        
    }
}