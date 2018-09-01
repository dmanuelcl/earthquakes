//
//  MapViewControllerTests.swift
//  EarthquakesTests
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import XCTest
import AppDomain
import MapKit

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

class EarthquakesDataSourceSpy: EarthquakesDataSourceProtocol{
    var currentSearchCoordiate: CLLocationCoordinate2D?
    
    var currentMagnitude: EarthquakeMagnitude?
    
    var earthquakes: [Earthquake] = []
    
    var isFetchEarthquakesInCalled: Bool = false
    var isFetchEarthquakesForCalled: Bool = false
    
    func fetchEarthquakesIn(longitude: Double, latitude: Double, completion: @escaping ([Earthquake]) -> Void) {
        self.isFetchEarthquakesInCalled = true
        completion([])
    }
    
    func fetchEarthquakesFor(magnitude: EarthquakeMagnitude, completion: @escaping ([Earthquake]) -> Void) {
        self.isFetchEarthquakesForCalled = true
        completion([])
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
    
    func testReloadDataCallTeRightDataSourceMethod() {
        guard let viewController = self.viewController else {
            return
        }
        let dataSourceSpy = EarthquakesDataSourceSpy()
        viewController.dataSource = dataSourceSpy
        viewController.reloadData(self)
        
        if viewController.searchButton.isSelected{
            XCTAssertTrue(dataSourceSpy.isFetchEarthquakesInCalled, "On reloadData(:) If the searchButton is selected the dataSource.fetchEarthquakesIn(longitude:latitude:completion) method must be called ")
        }
        
        if viewController.currentLocationButton.isSelected{
            XCTAssertTrue(dataSourceSpy.isFetchEarthquakesInCalled, "On reloadData(:) If the searchButton is selected the dataSource.fetchEarthquakesIn(longitude:latitude:completion) method must be called ")
        }
        
        if viewController.magnitudeButton.isSelected{
            XCTAssertTrue(dataSourceSpy.isFetchEarthquakesInCalled, "On reloadData(:) If the searchButton is selected the dataSource.fetchEarthquakesFor(magnitude:completion) method must be called ")
        }
    }
    
    func testSearchForCurrentLocationCallDataSourceMethod() {
        guard let viewController = self.viewController else {
            return
        }
        let dataSourceSpy = EarthquakesDataSourceSpy()
        viewController.dataSource = dataSourceSpy
        viewController.searchForCurrentLocation(self)
        XCTAssertTrue(dataSourceSpy.isFetchEarthquakesInCalled, "On searchForCurrentLocation(:) the dataSource.fetchEarthquakesIn(longitude:latitude:completion) method must be called ")
    }
    
    func testSearchForMagnitudeUpdateButtonsStatus() {
        guard let viewController = self.viewController else {
            return
        }
        viewController.dataSource = EarthquakesDataSourceSpy()
        viewController.searchByMagnitude(self)
        XCTAssertTrue(viewController.magnitudeButton.isSelected, "On searchByMagnitude(:) the magnitudeButton.isSelected must be true ")
        XCTAssertTrue(!viewController.searchButton.isSelected, "On searchByMagnitude(:) the searchButton.isSelected must be false ")
        XCTAssertTrue(!viewController.currentLocationButton.isSelected, "On searchByMagnitude(:) the currentLocationButton.isSelected must be false ")
    }
    
    func testSearchForCurrentLocationUpdateButtonsStatus() {
        guard let viewController = self.viewController else {
            return
        }
        viewController.dataSource = EarthquakesDataSourceSpy()
        viewController.searchForCurrentLocation(self)
        XCTAssertTrue(!viewController.magnitudeButton.isSelected, "On searchForCurrentLocation(:) the magnitudeButton.isSelected must be false ")
        XCTAssertTrue(!viewController.searchButton.isSelected, "On searchForCurrentLocation(:) the searchButton.isSelected must be false ")
        XCTAssertTrue(viewController.currentLocationButton.isSelected, "On searchForCurrentLocation(:) the currentLocationButton.isSelected must be true ")
    }
    
    func testSearchForLocationUpdateButtonsStatus() {
        guard let viewController = self.viewController else {
            return
        }
        viewController.dataSource = EarthquakesDataSourceSpy()
        viewController.searchForLocation(self)
        XCTAssertTrue(!viewController.magnitudeButton.isSelected, "On searchForLocation(:) the magnitudeButton.isSelected must be false ")
        XCTAssertTrue(viewController.searchButton.isSelected, "On searchForLocation(:) the searchButton.isSelected must be true ")
        XCTAssertTrue(!viewController.currentLocationButton.isSelected, "On searchForLocation(:) the currentLocationButton.isSelected must be false ")
    }
    
}
