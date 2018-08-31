//
//  ApiParameterTests.swift
//  AppServicesTests
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import XCTest

@testable import AppServices

class ApiParameterTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testApiParametersShouldNotBeEmpty() {
        let parameters: [ApiParameter] = [
            .starttime(Date()),
            .latitude(1.0),
            .longitude(1.0),
            .maxradiuskm(100),
            .limit(5),
            .minmagnitude(1.5)
            ]
        
        for parameter in parameters{
            XCTAssertFalse(parameter.apiParameters().isEmpty, "Api parameter should no be empty")
        }
    }

    
}
