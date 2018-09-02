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


/// Is the main scene of the app, shows the map and controls available
class MapViewController: UIViewController {
    
    //MARK: - IBOutlet
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var magnitudeButton: UIButton!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    
    //MARK: - Attrs
    private var locationManager: CLLocationManager!
    private var currentAnnotations: [EarthquakePointAnnotation] = []
    private let dateFormatter = DateFormatter()
    var dataSource: EarthquakesDataSourceProtocol!
    
    
    /// Alert to show the message for location authorization
    var locationAlert: UIAlertController?
    
    //Used to display the list of Earthquakes
    var earthquakesSheetView: EarthquakeSheetView!
    
    
    /// Loading view indicator
    var loadingView: LoadingView = LoadingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dateFormatter.dateFormat = "MMMM dd, yyyy, hh:mm:ss a"
        self.setupMap()
        self.setupEarthquakeSheetView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.earthquakesSheetView.install()
        if self.dataSource.earthquakes.count == 0{
            self.hideEarthSheetView()
        }else{
            self.displayEarthSheetViewIfNeeded()
        }
    }
    
    
    /// Preparate the earthquakesSheetView to display the list of Earthquakes
    func setupEarthquakeSheetView(){
        self.earthquakesSheetView = EarthquakeSheetView(dataSource: self.dataSource as! EarthquakeSheetViewDataSource)
        self.earthquakesSheetView.sheetHeight = UIScreen.main.bounds.height * 0.75
        self.earthquakesSheetView.initialHeight = UIScreen.main.bounds.height * 0.25
        self.earthquakesSheetView.hideOnClosed = true
        self.earthquakesSheetView.earthquakDelegate = self
    }
    
    
    /// Configure the map amnd location manager to handle the user's ubication
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
    
    
    /// Center the map based on the given coordinate
    ///
    /// - Parameter coordinate: The coordinate to center the map
    func centerMap(in coordinate: CLLocationCoordinate2D){
        DispatchQueue.main.async {
            self.map.setRegion(MKCoordinateRegion.init(center: coordinate, span: MKCoordinateSpan.init(latitudeDelta: 10, longitudeDelta: 10)), animated: true)
        }
    }
    
    //Given a list of locations, find the nearest location
    func nearestLocation(locations: [CLLocation], referenceLocation: CLLocation) -> CLLocation?{
        var minimumDistance: Double = -1
        var closestLocation: CLLocation?
        for location in locations{
            let distance = referenceLocation.distance(from: location)
            if distance < minimumDistance || minimumDistance == -1 {
                minimumDistance = distance
                closestLocation = location
            }
        }
        return closestLocation
    }
    
    
    /// Refresh te current data reload the list of Earthquakes as well as the map annotations
    func refreshData(){
        DispatchQueue.main.async {
            self.loadingView.hide()
            self.refreshMapAnnotations()
            self.earthquakesSheetView.reloadData()
            self.hideEarthSheetView()
            self.displayEarthSheetViewIfNeeded()
        }
    }
    
    
    /// Update the map annotations, replace the old annotations and add new based en the current list of Earthquakes
    func refreshMapAnnotations() {
        
        // Remove the old anotations
        self.map.removeAnnotations(self.map.annotations)
        self.currentAnnotations.removeAll()
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
            }else{ let subtitle = NSLocalizedString("map_anotation_without_magnitude_details", comment: "Anotation subtitle")
                pointAnotation.subtitle = String.init(format: subtitle, date)
            }
            self.currentAnnotations.append(pointAnotation)
            self.map.addAnnotation(pointAnotation)
        }
    }
    
    
    /// Update the status of the buttons for the search options
    ///
    /// - Parameters:
    ///   - searchByMagnitude: Define if the magnitudeButton shuld be selected
    ///   - searchByLocation: Define if the searchButton shuld be selected
    ///   - searchByCurrentLocation: Define if the currentLocationButton shuld be selected
    func updateButtonStatus(searchByMagnitude: Bool, searchByLocation: Bool, searchByCurrentLocation: Bool){
        self.magnitudeButton.isSelected = searchByMagnitude
        self.currentLocationButton.isSelected = searchByCurrentLocation
        self.searchButton.isSelected = searchByLocation
    }
    
    
    /// Check if is needed show the earthquakesSheetView
    func displayEarthSheetViewIfNeeded(){
        if self.dataSource.earthquakes.count > 0{
            self.earthquakesSheetView.hideOnClosed = false
            self.earthquakesSheetView.open()
        }
    }
    
    
    /// Hide the earthquakesSheetView
    func hideEarthSheetView(){
        self.earthquakesSheetView.hideOnClosed = true
        self.earthquakesSheetView.close()
    }
    
    
    /// Create a search for the given magnitude
    ///
    /// - Parameter magnitude: magnitude used for search
    func search(forMagnitude magnitude: EarthquakeMagnitude){
        self.loadingView.display()
        self.dataSource.fetchEarthquakesFor(magnitude: magnitude) {[unowned self] eartquakes in
            if let currentLocation = self.locationManager.location {
                let locations = eartquakes.map({CLLocation.init(latitude: $0.latitude, longitude: $0.longitude)})
                if let nearestLocation = self.nearestLocation(locations: locations, referenceLocation: currentLocation){
                    self.centerMap(in: nearestLocation.coordinate)
                }
            }
            self.refreshData()
        }
    }
    
    
    /// Create a search using the  latitude and longitude
    ///
    /// - Parameters:
    ///   - latitude: Latitude
    ///   - longitude: Longitude
    func search(forLatitude latitude: Double, longitude: Double){
        self.loadingView.display()
        self.dataSource.fetchEarthquakesIn(longitude: longitude, latitude: latitude) {[unowned self] _ in
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            self.centerMap(in: coordinate)
            self.refreshData()
        }
    }
    
    
    /// Present a UIAlertController with style actionSheet to select the magnitude for the search
    func presentMagnitudeSelectionAlertController(){
        let title = NSLocalizedString("magnitude_selection_alert_title", comment: "Alert title")
        let message = NSLocalizedString("magnitude_selection_alert_description", comment: "Alert message")
        
        let cancelTitle = NSLocalizedString("magnitude_selection_alert_cancel_action", comment: "Cancel")
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: {[unowned self] _ in
            self.displayEarthSheetViewIfNeeded()
        })
        
        let lowTitle = NSLocalizedString("magnitude_low", comment: "Low")
        let lowAction = UIAlertAction(title: lowTitle, style: .default, handler: {[unowned self] _ in
            self.search(forMagnitude: .low(EarthquakeMagnitude.defaultLowMagnitude))
        })
        
        let moderateTitle = NSLocalizedString("magnitude_moderate", comment: "Moderate")
        let moderateAction = UIAlertAction(title: moderateTitle, style: .default, handler: {[unowned self] _ in
            self.search(forMagnitude: .low(EarthquakeMagnitude.defaultModerateMagnitude))
        })
        
        let highTitle = NSLocalizedString("magnitude_high", comment: "High")
        let highAction = UIAlertAction(title: highTitle, style: .default, handler:  {[unowned self] _ in
            self.search(forMagnitude: .low(EarthquakeMagnitude.defaultHighMagnitude))
        })
        
        let extremeTitle = NSLocalizedString("magnitude_extreme", comment: "Extreme")
        let extremeAction = UIAlertAction(title: extremeTitle, style: .default, handler: {[unowned self] _ in
            self.search(forMagnitude: .low(EarthquakeMagnitude.defaultExtremeMagnitude))
        })
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        alertController.addAction(lowAction)
        alertController.addAction(moderateAction)
        alertController.addAction(highAction)
        alertController.addAction(extremeAction)
        alertController.addAction(cancelAction)
        
        self.hideEarthSheetView()
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    /// Present a SearchViewController to search by place or address
    func presentSearchViewController(){
        self.hideEarthSheetView()
        let searchViewController = UIStoryboard.init(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        searchViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: searchViewController)
        navigationController.isNavigationBarHidden = false
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    @IBAction func searchForCurrentLocation(_ sender: AnyObject){
        self.updateButtonStatus(searchByMagnitude: false, searchByLocation: false, searchByCurrentLocation: true)
        guard let coordinate = self.locationManager.location?.coordinate else {return}
        self.search(forLatitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    @IBAction func searchByMagnitude(_ sender: AnyObject){
        self.updateButtonStatus(searchByMagnitude: true, searchByLocation: false, searchByCurrentLocation: false)
        self.presentMagnitudeSelectionAlertController()
    }
    
    @IBAction func searchForLocation(_ sender: AnyObject){
        self.updateButtonStatus(searchByMagnitude: false, searchByLocation: true, searchByCurrentLocation: false)
        self.presentSearchViewController()
    }
    
    
    /// Reload the data using the las search configuration
    /// 
    @IBAction func reloadData(_ sender: AnyObject){
        if self.searchButton.isSelected{
            guard let lastCoordinate = self.dataSource.currentSearchCoordiate else {
                return
            }
            self.search(forLatitude: lastCoordinate.latitude, longitude: lastCoordinate.longitude)
            return
        }
        
        if self.magnitudeButton.isSelected{
            guard let magnitude = self.dataSource.currentMagnitude else {
                return
            }
            self.search(forMagnitude: magnitude)
            return
        }
        
        if self.currentLocationButton.isSelected{
            self.searchForCurrentLocation(self)
        }
    }
}

// MARK: - CLLocationManagerDelegate conformance
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
        self.searchForCurrentLocation(self)
        self.locationAlert?.dismiss(animated: true, completion: nil)
    }
}


// MARK: - MKMapViewDelegate conformance
extension MapViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? EarthquakePointAnnotation else {
            return nil
        }
        
        let anotationIdentifier = String(describing: MKPinAnnotationView.self)
        var anotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: anotationIdentifier)
        if let _anotationView = self.map.dequeueReusableAnnotationView(withIdentifier: anotationIdentifier, for: annotation) as? MKPinAnnotationView{
            anotationView = _anotationView
        }
        
        anotationView.canShowCallout = true
        anotationView.animatesDrop = true
        anotationView.pinTintColor = annotation.earthquake.magnitudeColor
        return anotationView
    }
}


// MARK: - EarthquakeSheetViewDelegate conformance
extension MapViewController: EarthquakeSheetViewDelegate{
    func sheetView(_ sheetView: EarthquakeSheetView, didSelectEarthquake earthquake: Earthquake) {
        earthquake.playSound()
        let coordinate = CLLocationCoordinate2D(latitude: earthquake.latitude, longitude: earthquake.longitude)
        self.centerMap(in: coordinate)
        //FIXME: - This is not the best way to perform this, fix me
        let annotation = self.currentAnnotations.first { (annotation) -> Bool in
            let annotationEarthquake = annotation.earthquake
            let isTheSame =
                annotationEarthquake?.time == earthquake.time &&
                    annotationEarthquake?.place == earthquake.place &&
                    annotationEarthquake?.latitude == earthquake.latitude &&
                    annotationEarthquake?.longitude == earthquake.longitude
            
            return isTheSame
        }
        if let annotationToSelect = annotation{
            self.map.selectAnnotation(annotationToSelect, animated: true)
        }
        self.earthquakesSheetView.close()
    }
}


// MARK: - SearchViewControllerDelegate conformance
extension MapViewController: SearchViewControllerDelegate{
    func searchView(didCancel searchViewController: SearchViewController) {
        searchViewController.dismiss(animated: true, completion: nil)
    }
    
    func searchView(didFailed searchViewController: SearchViewController) {
        searchViewController.dismiss(animated: true, completion: nil)
    }
    
    func searchView(_ searchViewController: SearchViewController, didSelectCoordinate coordinate: CLLocationCoordinate2D) {
        searchViewController.dismiss(animated: true, completion: nil)
        self.search(forLatitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
