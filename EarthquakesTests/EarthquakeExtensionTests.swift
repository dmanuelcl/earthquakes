//
//  EarthquakeExtensionTests.swift
//  EarthquakesTests
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import XCTest

@testable import Earthquakes
import AppDomain

class EarthquakeExtensionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testColorBasedOnmagnitude() {
        let magnitudes: [EarthquakeMagnitude?] = [nil, .low(1.5), .moderate(2.0), .high(5), .extreme(8)]
        let expectedColors: [UIColor] = [.gray, .green, .yellow, .orange, .red]
        
        for (index, magnitude) in magnitudes.enumerated(){
            let earthquake = Earthquake(magnitude: magnitude, place: "", time: Date(), latitude: 1.0, longitude: 1.0, depth: 1.0)
            let expectedColor = expectedColors[index]
            XCTAssertEqual(earthquake.magnitudeColor.cgColor, expectedColor.cgColor, "The earthquake magnitude \(String(describing: magnitude)) must have the color \(expectedColor)")
        }
    }
    
    
    func testImageBasedOnmagnitude() {
        let magnitudes: [EarthquakeMagnitude?] = [nil, .low(1.5), .moderate(2.0), .high(5), .extreme(8)]
        let expectedImages: [UIImage] = [#imageLiteral(resourceName: "map_pin_gray"), #imageLiteral(resourceName: "map_pin_green"), #imageLiteral(resourceName: "map_pin_yellow"), #imageLiteral(resourceName: "map_pin_orange"), #imageLiteral(resourceName: "map_pin_red")]
        
        for (index, magnitude) in magnitudes.enumerated(){
            let earthquake = Earthquake(magnitude: magnitude, place: "", time: Date(), latitude: 1.0, longitude: 1.0, depth: 1.0)
            let expectedImage = expectedImages[index]
            XCTAssertEqual(earthquake.magnitudeImage, expectedImage, "The earthquake magnitude \(String(describing: magnitude)) must have the image \(expectedImage)")
        }
    }
}
