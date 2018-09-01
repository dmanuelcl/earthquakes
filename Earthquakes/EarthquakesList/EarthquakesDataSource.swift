//
//  EarthquakesDataSource.swift
//  Earthquakes
//
//  Created by Dani Manuel Céspedes Lara on 9/1/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import UIKit
import AppDomain
import MapKit


class EarthquakesDataSource: NSObject, EarthquakesDataSourceProtocol{
    
    //The last coordinate used for serach
    var currentSearchCoordiate: CLLocationCoordinate2D? = nil
    
    //The las magnitude used for search
    var currentMagnitude: EarthquakeMagnitude? = nil
    
    
    /// Result of the last search
    var earthquakes: [Earthquake] = []
    
    private let dataProvider: EarthquakesDataProvider
    
    init(dataProvider: EarthquakesDataProvider) {
        self.dataProvider = dataProvider
    }
    
    /// Get every earthquakes who have taken place near the given location
    ///
    /// - Parameters:
    ///   - longitude: Longitude to create the search location
    ///   - latitude: Latitude to create the search location
    ///   - completion: Invoked with the results obtained
    func fetchEarthquakesIn(longitude: Double, latitude: Double, completion: @escaping ([Earthquake]) -> Void) {
        self.currentSearchCoordiate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.dataProvider.getEarthquakes(longitude: longitude, latitude: latitude) { (earthquakes) in
            self.earthquakes = earthquakes
            completion(earthquakes)
        }
    }
    
    
    /// Get every earthquakes based on its magnitude
    ///
    /// - Parameters:
    ///   - maginute: Earthquakes magnitude to filter
    ///   - completion: Invoked with the results obtained
    func fetchEarthquakesFor(magnitude: EarthquakeMagnitude, completion: @escaping ([Earthquake]) -> Void) {
        self.currentMagnitude = magnitude
        self.dataProvider.getEarthquakes(maginute: magnitude) { (earthquakes) in
            self.earthquakes = earthquakes
            completion(earthquakes)
        }
    }
    
}

// MARK: - Add conformance to UITableViewDataSource
extension EarthquakesDataSource: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.earthquakes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: EarthquakeCell.self), for: indexPath) as! EarthquakeCell
        let model = self.earthquakes[indexPath.row]
        cell.configure(with: model)
        return cell
    }
}
