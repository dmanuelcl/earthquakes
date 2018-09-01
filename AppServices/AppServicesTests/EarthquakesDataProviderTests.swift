//
//  EarthquakesDataProviderTests.swift
//  AppServicesTests
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import XCTest

@testable import AppServices

class ApiManagerMock: ApiManager {
    static var share = ApiManagerMock()
    var isRequestDataCalled: Bool = false
    func requestData(withParameters parameters: [ApiParameterConvertible], completion: @escaping (Error?, Data?) -> Void) {
        self.isRequestDataCalled = true
        completion(nil, nil)
    }
    
}

class EarthquakesDataProviderTests: XCTestCase {
    
    var dataProvider: EarthquakesDataProvider!
    
    override func setUp() {
        super.setUp()
        self.dataProvider = EarthquakesDataProvider(apiManager: ApiManagerMock.share)
    }
    
    override func tearDown() {
        super.tearDown()
        ApiManagerMock.share.isRequestDataCalled = false
    }
    
    func testGetRecentEarthquakesMustCallApiManageRequestData(){
        self.dataProvider.getRecentEarthquakes { _ in }
        XCTAssertEqual(ApiManagerMock.share.isRequestDataCalled, true, "getRecentEarthquakes(completion:) must call apiManager's requestData(withParameters:, completion:)")
    }
    
    func testGetRecentEarthquakesByMagnitudeMustCallApiManageRequestData(){
        self.dataProvider.getEarthquakes(maginute: .low(1.5)) { _ in }
        XCTAssertEqual(ApiManagerMock.share.isRequestDataCalled, true, "getEarthquakes(magnitude:completion:) must call apiManager's requestData(withParameters:, completion:)")
    }
    
    func testGetRecentEarthquakesByLocationMustCallApiManageRequestData(){
        self.dataProvider.getEarthquakes(longitude: 1.0, latitude: 1.0) { _ in }
        XCTAssertEqual(ApiManagerMock.share.isRequestDataCalled, true, "getEarthquakes(longitude:latitude:completion:) must call apiManager's requestData(withParameters:, completion:)")
    }
    
    func testGetRecentEarthquakesMustCallCompletionHandler() {
        let completionHandlerExpectation = XCTestExpectation(description: "")
        self.dataProvider.getRecentEarthquakes { _ in
            completionHandlerExpectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [completionHandlerExpectation], timeout: 30.0)
        XCTAssertEqual(result, XCTWaiter.Result.completed, "getRecentEarthquakes(completion:) must call completion handler before 30 seconds")
    }
    
    func testGetRecentEarthquakesByMagnitudeMustCallCompletionHandler() {
        let completionHandlerExpectation = XCTestExpectation(description: "")
        self.dataProvider.getEarthquakes(maginute: .low(1.5), completion: { _ in
             completionHandlerExpectation.fulfill()
        })
        
        let result = XCTWaiter.wait(for: [completionHandlerExpectation], timeout: 30.0)
        XCTAssertEqual(result, XCTWaiter.Result.completed, "getEarthquakes(magnitude:completion:) must call completion handler before 30 seconds")
    }
    
    func testGetRecentEarthquakesByLocationMustCallCompletionHandler() {
        let completionHandlerExpectation = XCTestExpectation(description: "")
        self.dataProvider.getEarthquakes(longitude: 1.0, latitude: 1.0) { _ in
            completionHandlerExpectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [completionHandlerExpectation], timeout: 30.0)
        XCTAssertEqual(result, XCTWaiter.Result.completed, "getEarthquakes(longitude:latitude:completion:) must call completion handler before 30 seconds")
    }
}
