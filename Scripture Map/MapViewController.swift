//
//  MapViewController.swift
//  Scripture Map
//
//  Created by Kyle on 11/26/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - PROPERTIES
    
    var manager = CLLocationManager()
    // Default is the LDS Conference Center
    var displayDefaultLocation = true
    
    // MARK: - OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupMapView()
    }
    
    // MARK: - SETUP METHODS
    
    private func setupMapView() {
        mapView.delegate = self
        manager.delegate = self
        manager.distanceFilter = kCLDistanceFilterNone
        manager.desiredAccuracy = kCLLocationAccuracyBest
        
        evaluateLocationAuthorizationStatus()
    }
    
    private func goToLocationOnMap(annotation: MKPointAnnotation? = nil,
        altitude: Double = 1000, location: CLLocation = CLLocation(latitude: 40.7725, longitude: -111.8925)) {
            
        if annotation != nil {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
                self.mapView.addAnnotation(annotation!)
            }
        }

        let camera = MKMapCamera(lookingAtCenterCoordinate: location.coordinate, fromEyeCoordinate: location.coordinate, eyeAltitude: altitude)
        mapView.setCamera(camera, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("Pin")
        
        if view == nil {
            let pinView = MKPinAnnotationView()
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.pinTintColor = UIColor.blueColor()
            
            view = pinView
        } else {
            view?.annotation = annotation
        }
        
        return view
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        evaluateLocationAuthorizationStatus()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        manager.stopUpdatingLocation()
        goToLocationOnMap(location: newLocation)
    }
    
    private func evaluateLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        } else if CLLocationManager.authorizationStatus() != .AuthorizedWhenInUse {
            goToLocationOnMap()
        } else {
            manager.startUpdatingLocation()
        }
    }
}