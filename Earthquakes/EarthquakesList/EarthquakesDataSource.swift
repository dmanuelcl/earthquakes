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
    
    var currentSearchCoordiate: CLLocationCoordinate2D? = nil
    
    var currentMagnitude: EarthquakeMagnitude? = nil
    
    var earthquakes: [Earthquake] = []
    
    private let dataProvider: EarthquakesDataProvider
    
    init(dataProvider: EarthquakesDataProvider) {
        self.dataProvider = dataProvider
    }
    
    func fetchEarthquakesIn(longitude: Double, latitude: Double, completion: @escaping ([Earthquake]) -> Void) {
        self.currentSearchCoordiate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.dataProvider.getEarthquakes(longitude: longitude, latitude: latitude) { (earthquakes) in
            self.earthquakes = earthquakes
            completion(earthquakes)
        }
    }
    
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
