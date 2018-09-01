//
//  MapViewControllerTests.swift
//  EarthquakesTests
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import XCTest

@testable import Earthquakes

class MapViewControllerSpy: MapViewController {
    var isSetupMapCalled: Bool = false
    var isEarthquakeSheetView: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupMap() {
        self.isSetupMapCalled = true
    }
    
    override func setupEarthquakeSheetView() {
        self.isEarthquakeSheetView = true
    }
}

class MapViewControllerTests: XCTestCase {
    
    var viewController: MapViewController?{
        guard let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateInitialViewController() as? MapViewController else{
             XCTFail("MapViewController must be the InitialViewController on Main.storyboard")
            return nil
        }
        viewController.loadViewIfNeeded()
        return viewController
    }
    override func setUp() {
        super.setUp()
       
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSearchForMagnitudeUpdateButtonsStatus() {
        guard let viewController = self.viewController else {
            return
        }
        viewController.searchByMagnitude(self)
        XCTAssertTrue(viewController.magnitudeButton.isSelected, "On searchByMagnitude(:) the magnitudeButton.isSelected must be true ")
        XCTAssertTrue(!viewController.searchButton.isSelected, "On searchByMagnitude(:) the searchButton.isSelected must be false ")
        XCTAssertTrue(!viewController.currentLocationButton.isSelected, "On searchByMagnitude(:) the currentLocationButton.isSelected must be false ")
    }
    
    func testSearchForCurrentLocationUpdateButtonsStatus() {
        guard let viewController = self.viewController else {
            return
        }
        viewController.searchForCurrentLocation(self)
        XCTAssertTrue(!viewController.magnitudeButton.isSelected, "On searchForCurrentLocation(:) the magnitudeButton.isSelected must be false ")
        XCTAssertTrue(!viewController.searchButton.isSelected, "On searchForCurrentLocation(:) the searchButton.isSelected must be false ")
        XCTAssertTrue(viewController.currentLocationButton.isSelected, "On searchForCurrentLocation(:) the currentLocationButton.isSelected must be true ")
    }
    
    func testSearchForLocationUpdateButtonsStatus() {
        guard let viewController = self.viewController else {
            return
        }
        viewController.searchForLocation(self)
        XCTAssertTrue(!viewController.magnitudeButton.isSelected, "On searchForLocation(:) the magnitudeButton.isSelected must be false ")
        XCTAssertTrue(viewController.searchButton.isSelected, "On searchForLocation(:) the searchButton.isSelected must be true ")
        XCTAssertTrue(!viewController.currentLocationButton.isSelected, "On searchForLocation(:) the currentLocationButton.isSelected must be false ")
    }
    
    func testPresentAlertControllerOnSearchForMagnitude() {
        guard let viewController = self.viewController else {
            return
        }
        viewController.searchByMagnitude(self)
        let expectation = XCTestExpectation(description: "")
        _ = XCTWaiter.wait(for: [expectation], timeout: 1.0)
        guard let presenterViewController = viewController.presentedViewController as? UIAlertController else {
            XCTFail("searchByMagnitude(:) must present an UIAlertController")
            return
        }
        XCTAssertTrue(presenterViewController.preferredStyle == .actionSheet, "searchByMagnitude(:) must present an UIAlertController with style actionSheet")
    }
    
}
