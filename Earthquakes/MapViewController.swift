//
//  ViewController.swift
//  Earthquakes
//
//  Created by Dani Manuel Céspedes Lara on 8/31/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import UIKit
import AppDomain
import MapKit


class EarthquakePointAnnotation: MKPointAnnotation {
    var earthquake: Earthquake!
}

class MapViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var magnitudeButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    //MARK: - Attrs
    private var locationManager: CLLocationManager!
    private let dateFormatter = DateFormatter()
    var dataSource: EarthquakesDataSourceProtocol!
    
    var locationAlert: UIAlertController?
    
    var earthquakesSheetView: EarthquakeSheetView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "MMMM dd, yyyy, hh:mm:ss a"
        self.setupMap()
        self.setupEarthquakesSheetView()
    }
    
    func setupEarthquakesSheetView(){
        
    }
    
    func setupMap(){
        //Setup location manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 100 //To be notified only if the distance is more than 100 meters
        self.locationManager.requestWhenInUseAuthorization()
        
        // Setup map view...
        self.map.delegate = self
        self.map.showsUserLocation = true
        if #available(iOS 11.0, *) {
            self.map.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: String(describing: MKPinAnnotationView.self))
        }
    }
    
    func centerMap(in coordinate: CLLocationCoordinate2D){
        self.map.setCenter(coordinate, animated: true)
    }
    
    func refreshMapAnnotations() {

        // Remove the old anotations
        self.map.removeAnnotations(self.map.annotations)
        
        // Add new annotations...
        for earthquake in self.dataSource.earthquakes {
            let pointAnotation = EarthquakePointAnnotation()
            
            pointAnotation.earthquake = earthquake
            
            pointAnotation.coordinate = CLLocationCoordinate2D(
                latitude: earthquake.latitude,
                longitude: earthquake.longitude)
            
            
            let date = self.dateFormatter.string(from: earthquake.time)
            
            pointAnotation.title = earthquake.place
            if let magnitude = earthquake.magnitude{
                let subtitle = NSLocalizedString("map_anotation_details", comment: "Anotation subtitle")
                pointAnotation.subtitle = String.init(format: subtitle, magnitude.magnitude, date)
            }else{
                pointAnotation.subtitle = "Event on \(date)"
            }
            
            self.map.addAnnotation(pointAnotation)
        }
    }
    
    func updateButtonStatus(searchByMagnitude: Bool, searchByLocation: Bool, searchByCurrentLocation: Bool){
        self.magnitudeButton.isSelected = searchByMagnitude
        self.currentLocationButton.isSelected = searchByCurrentLocation
        self.searchButton.isSelected = searchByLocation
    }
    
    @IBAction func searchForCurrentLocation(_ sender: AnyObject){
        self.updateButtonStatus(searchByMagnitude: false, searchByLocation: false, searchByCurrentLocation: true)
    }
    
    @IBAction func searchByMagnitude(_ sender: AnyObject){
        self.updateButtonStatus(searchByMagnitude: true, searchByLocation: false, searchByCurrentLocation: false)
    }
    
    @IBAction func searchForLocation(_ sender: AnyObject){
        self.updateButtonStatus(searchByMagnitude: false, searchByLocation: true, searchByCurrentLocation: false)
    }
    
    @IBAction func refreshData(_ sender: AnyObject){
        
        
    }
}


extension MapViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        self.centerMap(in: location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard status != CLAuthorizationStatus.denied else {
            let title = NSLocalizedString("no_when_in_use_location_authorization_alert_title", comment: "Alert title")
            let message = NSLocalizedString("no_when_in_use_location_authorization_alert_message", comment: "Alert message")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)
            self.locationAlert = alert
            return
        }
        self.locationManager.startUpdatingLocation()
        self.locationAlert?.dismiss(animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.refreshMapAnnotations()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? EarthquakePointAnnotation else {
            return nil
        }
        
        let anotationIdentifier = String(describing: MKPinAnnotationView.self)
        let anotationView = self.map.dequeueReusableAnnotationView(withIdentifier: anotationIdentifier, for: annotation)
        
        anotationView.canShowCallout = true
        anotationView.image = annotation.earthquake.magnitudeImage
        
        return anotationView
    }
}
