//
//  MapViewController.swift
//  Scripture Map
//
//  Created by Kyle on 11/26/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupMapView()
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(40.2506, -111.65247)
            annotation.title = "Tanner Building"
            annotation.subtitle = "BYU Campus"
            
            self.mapView.addAnnotation(annotation)
        }
        
        let camera = MKMapCamera(lookingAtCenterCoordinate: CLLocationCoordinate2DMake(40.2506  , -111.65247), fromEyeCoordinate: CLLocationCoordinate2DMake(40.2406, -111.65247), eyeAltitude: 300)
        
        mapView.setCamera(camera, animated: true)
    }
    
    // MARK: - SETUP METHODS
    
    private func setupMapView() {
        mapView.delegate = self
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier("Pin")
        
        if view == nil {
            let pinView = MKPinAnnotationView()
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.pinTintColor = UIColor.blueColor() // MKPinAnnotationView.purplePinColor()
            
            view = pinView
        } else {
            view?.annotation = annotation
        }
        
        return view
    }
}