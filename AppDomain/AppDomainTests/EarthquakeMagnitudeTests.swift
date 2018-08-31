//
//  EarthquakeMagnitudeTests.swift
//  AppDomainTests
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import XCTest

@testable import AppDomain

class EarthquakeMagnitudeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    @discardableResult
    func earthquakeMagnitude(with magnitude: Double) -> EarthquakeMagnitude?{
        guard let earthquakeMagnitude = EarthquakeMagnitude(magnitude: magnitude) else {
            XCTFail("Magnitudes greater than 0 must result in a EarthquakeMagnitude")
            return nil
        }
        return earthquakeMagnitude
    }
    
    func testFailableInit(){
        let earthquakeMagnitude = EarthquakeMagnitude(magnitude: 0)
        XCTAssertNil(earthquakeMagnitude, "The magnitudes must be greater than 0")
        
        let earthquakeMagnitudeNegative = EarthquakeMagnitude(magnitude: -1)
        XCTAssertNil(earthquakeMagnitudeNegative, "The magnitudes must be greater than 0")
    }
    
    func testValidInit(){
        let magnitude = 1.4
        self.earthquakeMagnitude(with: magnitude)
    }
    
    func testMagnitudePropertyEqualToProvidedInInit(){
        let magnitude = 1.4
        guard let earthquakeMagnitude = self.earthquakeMagnitude(with: magnitude) else {
            return
        }
        XCTAssertEqual(earthquakeMagnitude.magnitude, magnitude, "The EarthquakeMagnitude.magintude must be equal to magnitude provided in init")
    }
    
    func testLowMagnitudeInit(){
        let magnitude = 1.4
        guard let earthquakeLowMagnitude = self.earthquakeMagnitude(with: magnitude) else {
            return
        }
        switch earthquakeLowMagnitude {
        case .low:
            break
        default:
            XCTFail("Magnitudes smaller than 1.5 should result in  EarthquakeMagnitude.low")
        }
    }
    
    func testModerateMagnitudeInit(){
        let magnitude = 4.5
        guard let earthquakeLowMagnitude = self.earthquakeMagnitude(with: magnitude) else {
            return
        }
        switch earthquakeLowMagnitude {
        case .moderate:
            break
        default:
            XCTFail("Magnitudes smaller than 1.5 should result in  EarthquakeMagnitude.moderate")
        }
    }
    
    func testHightMagnitudeInit(){
        let magnitude = 7.0
        guard let earthquakeLowMagnitude = self.earthquakeMagnitude(with: magnitude) else {
            return
        }
        switch earthquakeLowMagnitude {
        case .high:
            break
        default:
            XCTFail("Magnitudes smaller than 7 should result in  EarthquakeMagnitude.high")
        }
    }
    
    func testExtremeMagnitudeInit(){
        let magnitude = 8.0
        guard let earthquakeLowMagnitude = self.earthquakeMagnitude(with: magnitude) else {
            return
        }
        switch earthquakeLowMagnitude {
        case .extreme:
            break
        default:
            XCTFail("Magnitudes greater than 7 should result in  EarthquakeMagnitude.extreme")
        }
    }
    
}
