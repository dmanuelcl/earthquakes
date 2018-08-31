//
//  UsgsApiManagerTests.swift
//  AppServicesTests
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import XCTest
@testable import AppServices

class UsgsApiManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testApiRequestMustCallCompletionHandler() {
        let completionHandlerExpectation = XCTestExpectation(description: "Api request CompletionHandler")
        UsgsApiManager.shared.requestData(withParameters: []) { (_, _) in
            completionHandlerExpectation.fulfill()
        }
        let result = XCTWaiter.wait(for: [completionHandlerExpectation], timeout: 30.0)
        XCTAssertEqual(result, XCTWaiter.Result.completed, "Api request must call completion handler before 30 seconds")
    }
    
}
