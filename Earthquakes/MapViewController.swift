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
    
    //MARK: - Attrs
    var locationManager: CLLocationManager!
    var annotations: [MKPointAnnotation] = []
    let dateFormatter = DateFormatter()
    
    var locationAlert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "MMMM dd, yyyy, hh:mm:ss a"
        self.setupMap()
    }
    
    
    func setupMap(){
        //Setup location manager
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = 100 //To be notified only if the distance is more than 100 meters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
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
    
    func refreshMapAnnotations(with earthquakes: [Earthquake]) {

        // Remove the old anotations
        self.map.removeAnnotations(self.map.annotations)
        
        let earthquakes = [Earthquake.init(magnitude: EarthquakeMagnitude.high(6), place: "Este es el place 1", time: Date(), latitude: 33.9, longitude: -87.65, depth: 1.0),
                           Earthquake.init(magnitude: EarthquakeMagnitude.high(6), place: "Este es el place 2", time: Date(), latitude: 32.9, longitude: -89.65, depth: 1.0)]
        // Add new annotations...
        for earthquake in earthquakes {
            let pointAnotation = EarthquakePointAnnotation()
            
            pointAnotation.earthquake = earthquake
            
            pointAnotation.coordinate = CLLocationCoordinate2D(
                latitude: earthquake.latitude,
                longitude: earthquake.longitude)
            

            let date = self.dateFormatter.string(from: earthquake.time)
            
            pointAnotation.title = earthquake.place
            if let magnitude = earthquake.magnitude{
                pointAnotation.subtitle = "Magnitude \(magnitude.magnitude) event on \(date)"
            }else{
                pointAnotation.subtitle = "Event on \(date)"
            }
            
            self.map.addAnnotation(pointAnotation)
        }
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
        self.locationAlert?.dismiss(animated: true, completion: nil)
    }
}

extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        self.refreshMapAnnotations(with: [])
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
