//
//  GeoPin.swift
//  Scripture Map
//
//  Created by Kyle on 11/26/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import MapKit

class GeoPin: NSObject, MKAnnotation {
    
    // MARK: - PROPERTIES
    
    // MARK: Coordinate Properties
    var coordinate: CLLocationCoordinate2D
    var viewCoordinate: CLLocationCoordinate2D?
    
    // MARK: Viewing Properties
    var altitude: Double = 5000
    var tiltAngle: Double = 0
    var heading: Double = 0
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
    
    convenience init(place: GeoPlace) {
        self.init(coordinate: CLLocationCoordinate2DMake(place.latitude, place.longitude), title: place.placename)
        self.viewCoordinate = CLLocationCoordinate2DMake(place.viewLatitude ?? place.latitude, place.viewLongitude ?? place.longitude)
        self.altitude = place.viewAltitude ?? 5000
        self.tiltAngle = place.viewTilt ?? 0
        self.heading = place.viewHeading ?? 0
    }
}