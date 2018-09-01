//
//  EarthquakesDataSourceTests.swift
//  EarthquakesTests
//
//  Created by Dani Manuel Céspedes Lara on 9/1/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import XCTest
import AppDomain
import MapKit

@testable import Earthquakes


class EarthquakesDataProviderSpy: EarthquakesDataProvider{
    
    var isGetRecentEarthquakesCalled: Bool = false
    var isGetEarthquakesCalled: Bool = false
    var isGetEarthquakesForMagnitudeCalled: Bool = false
    
    var results: [Earthquake] = []
    
    func getRecentEarthquakes(completion: @escaping EarthquakesDataProviderResponse) {
        self.isGetRecentEarthquakesCalled = true
        completion(self.results)
    }
    
    func getEarthquakes(longitude: Double, latitude: Double, completion: @escaping EarthquakesDataProviderResponse) {
        self.isGetEarthquakesCalled = true
        completion(self.results)
    }
    
    func getEarthquakes(maginute: EarthquakeMagnitude, completion: @escaping EarthquakesDataProviderResponse) {
        self.isGetEarthquakesForMagnitudeCalled = true
        completion(self.results)
    }
    
    
}

class EarthquakesDataSourceTests: XCTestCase {
    
    var dataSource: EarthquakesDataSource!
    var earthquakesDataProviderSpy: EarthquakesDataProviderSpy!
    override func setUp() {
        super.setUp()
        self.earthquakesDataProviderSpy = EarthquakesDataProviderSpy()
        self.dataSource = EarthquakesDataSource(dataProvider: self.earthquakesDataProviderSpy)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
    func testFetchEarthquakesForUpdateEarthquakes() {
        self.earthquakesDataProviderSpy.results = [
            Earthquake(magnitude: nil, place: "1", time: Date(), latitude: 0.0, longitude: 1.0, depth: 1.0),
            Earthquake(magnitude: nil, place: "2", time: Date(), latitude: 0.0, longitude: 1.0, depth: 1.0)
        ]
        self.dataSource.fetchEarthquakesFor(magnitude: .low(EarthquakeMagnitude.defaultLowMagnitude)) { _ in }
        XCTAssertEqual(self.dataSource.earthquakes.count, self.earthquakesDataProviderSpy.results.count, "fetchEarthquakesFor(magnitude:completion) must call dataProvider.getEarthquakes(magnittude:completion:)")
    }
    
    func testFetchEarthquakesInUpdateEarthquakes() {
        self.earthquakesDataProviderSpy.results = [
            Earthquake(magnitude: nil, place: "1", time: Date(), latitude: 0.0, longitude: 1.0, depth: 1.0),
            Earthquake(magnitude: nil, place: "2", time: Date(), latitude: 0.0, longitude: 1.0, depth: 1.0)
        ]
        self.dataSource.fetchEarthquakesIn(longitude: 0.0, latitude: 0.0) { _ in }
        XCTAssertEqual(self.dataSource.earthquakes.count, self.earthquakesDataProviderSpy.results.count, "fetchEarthquakesFor(magnitude:completion) must call dataProvider.getEarthquakes(magnittude:completion:)")
    }
    
    func testFetchEarthquakesInCallDataProviderMethod() {
        self.dataSource.fetchEarthquakesIn(longitude: 0.0, latitude: 0.0) { _ in }
        XCTAssertTrue(self.earthquakesDataProviderSpy.isGetEarthquakesCalled, "fetchEarthquakesIn(longitude:latitude:completion) must call dataProvider.getEarthquakes(longitude:latitude:completion:)")
    }
    
    func testFetchEarthquakesForCallDataProviderMethod() {
        self.dataSource.fetchEarthquakesFor(magnitude: .low(EarthquakeMagnitude.defaultLowMagnitude)) { _ in }
        XCTAssertTrue(self.earthquakesDataProviderSpy.isGetEarthquakesForMagnitudeCalled, "fetchEarthquakesFor(magnitude:completion) must call dataProvider.getEarthquakes(magnittude:completion:)")
    }
    
    func testFetchEarthquakesInCallCompletion() {
        let completionHandlerExpectation = XCTestExpectation(description: "Completion Handler")
        self.dataSource.fetchEarthquakesIn(longitude: 0.0, latitude: 0.0) { _ in
            completionHandlerExpectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [completionHandlerExpectation], timeout: 30.0)
        XCTAssertEqual(result, XCTWaiter.Result.completed, "fetchEarthquakesIn(longitude:latitude:completion) must call completion handler before 30 seconds")
    }
    
    func testFetchEarthquakesForCallCompletion() {
        let completionHandlerExpectation = XCTestExpectation(description: "Completion Handler")
        self.dataSource.fetchEarthquakesFor(magnitude: .low(EarthquakeMagnitude.defaultLowMagnitude), completion: { _ in
            completionHandlerExpectation.fulfill()
        })
        let result = XCTWaiter.wait(for: [completionHandlerExpectation], timeout: 30.0)
        XCTAssertEqual(result, XCTWaiter.Result.completed, "fetchEarthquakesFor(magnitude:completion) must call completion handler before 30 seconds")
    }
    
    
    func testFetchEarthquakesForUpdateCurrenMagnitude(){
        let magnitude: EarthquakeMagnitude? = .low(EarthquakeMagnitude.defaultLowMagnitude)
        self.dataSource.fetchEarthquakesFor(magnitude: magnitude!, completion: { _ in })
        XCTAssertEqual(self.dataSource.currentMagnitude?.magnitude, magnitude?.magnitude, "fetchEarthquakesFor(magnitude:completion) must update the currentMagnitude value")
    }
    
    
    func testfetchEarthquakesInUpdateCurrenSearchCoordiate(){
        let coordinate: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 0.0, longitude: 1.1)
        self.dataSource.fetchEarthquakesIn(longitude: coordinate!.longitude, latitude: coordinate!.latitude, completion: {_ in})
        let currentSearchCoordiate = self.dataSource.currentSearchCoordiate
        let isEqual = currentSearchCoordiate?.latitude == coordinate?.latitude && currentSearchCoordiate?.longitude == coordinate?.longitude
        XCTAssertTrue(isEqual, "fetchEarthquakesIn(longitude:latitude:completion) must update the currentSearchCoordiate value")
    }
}
