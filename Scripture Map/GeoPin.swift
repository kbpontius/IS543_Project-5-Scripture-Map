//
//  GeoPin.swift
//  Scripture Map
//
//  Created by Kyle on 11/26/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import MapKit

class GeoPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var viewCoordinate: CLLocationCoordinate2D?
    
    var altitude: Double = 5000
    var tiltAngle: Double = 0
    var heading: Double = 0
    
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    convenience init(place: GeoPlace) {
        self.init(coordinate: CLLocationCoordinate2DMake(place.latitude, place.longitude), title: place.placename, subtitle: "FIX ME")
        self.viewCoordinate = CLLocationCoordinate2DMake(place.viewLatitude ?? place.latitude, place.viewLongitude ?? place.longitude)
        self.altitude = place.viewAltitude ?? 5000
        self.tiltAngle = place.viewTilt ?? 0
        self.heading = place.viewHeading ?? 0
    }
}
