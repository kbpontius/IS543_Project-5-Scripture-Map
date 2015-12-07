//
//  GeocodeSuggestionViewController.swift
//  Scripture Map
//
//  Created by Kyle on 12/7/15.
//  Copyright © 2015 Kyle Pontius. All rights reserved.
//

import UIKit
import MapKit

class GeocodeSuggestionViewController: UIViewController {
    @IBOutlet weak var txtLongitude: UITextField!
    @IBOutlet weak var txtLatitude: UITextField!
    @IBOutlet weak var txtViewLongitude: UITextField!
    @IBOutlet weak var txtViewLatitude: UITextField!
    @IBOutlet weak var txtViewTilt: UITextField!
    @IBOutlet weak var txtViewRoll: UITextField!
    @IBOutlet weak var txtViewAltitude: UITextField!
    @IBOutlet weak var txtViewHeading: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    var suggestGeocodeDelegate: GeocodingSuggestionDelegate!
    var mapCamera: MKMapCamera?
    
    override func viewDidLoad() {
        setupTextFields()
        setupDefaultValues()
    }
    
    // MARK: - SETUP METHODS
    
    private func setupDefaultValues() {
        if let camera = mapCamera {
            loadMapCamera(camera)
            refreshMapViewWithNewTextFieldValues(false)
        }
    }
    
    private func setupTextFields() {
        txtLongitude.delegate = self
        txtLatitude.delegate = self
        txtViewLongitude.delegate = self
        txtViewLatitude.delegate = self
        txtViewTilt.delegate = self
        txtViewRoll.delegate = self
        txtViewAltitude.delegate = self
        txtViewHeading.delegate = self
    }
    
    // MARK: - IB ACTIONS
    
    @IBAction func loadMapViewValues(sender: AnyObject) {
        loadMapCamera(mapView.camera)
    }

    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) {
            let latitude = Double(self.txtLatitude.text ?? "") ?? 0
            let longitude = Double(self.txtLongitude.text ?? "") ?? 0
            let viewLatitude = Double(self.txtViewLatitude.text ?? "") ?? 0
            let viewLongitude = Double(self.txtViewLongitude.text ?? "") ?? 0
            let viewTilt = Double(self.txtViewTilt.text ?? "") ?? 0
            let viewRoll = Double(self.txtViewRoll.text ?? "") ?? 0
            let viewAltitude = Double(self.txtViewAltitude.text ?? "") ?? 0
            let viewHeading = Double(self.txtViewHeading.text ?? "") ?? 0
            
            self.suggestGeocodeDelegate.didSuggestLocationToGeocode(latitude, longitude: longitude, viewLatitude: viewLatitude, viewLongitude: viewLongitude, viewTilt: viewTilt, viewRoll: viewRoll, viewAltitude: viewAltitude, viewHeading: viewHeading)
        }
    }
    
    // MARK: - HELPER METHODS
    
    private func loadMapCamera(mapCamera: MKMapCamera) {
        txtLongitude.text = String(mapCamera.centerCoordinate.longitude)
        txtLatitude.text = String(mapCamera.centerCoordinate.latitude)
        txtViewLongitude.text = txtLongitude.text
        txtViewLatitude.text = txtLatitude.text
        txtViewTilt.text = String(mapCamera.pitch)
        txtViewRoll.text = "0"
        txtViewAltitude.text = String(mapCamera.altitude)
        txtViewHeading.text! = String(mapCamera.heading)
    }
    
    // Normally a great deal of validation would go in here,
    // however, due to a great lack of available time to work on
    // this I'm going to just assume that the value passed in is a
    // double, like it should be. :)
    private func refreshMapViewWithNewTextFieldValues(animated: Bool) {
        let camera = MKMapCamera(lookingAtCenterCoordinate: CLLocationCoordinate2D(latitude: Double(txtLatitude.text ?? "") ?? 0, longitude: Double(txtLongitude.text ?? "") ?? 0), fromEyeCoordinate: CLLocationCoordinate2D(latitude: Double(txtViewLatitude.text ?? "") ?? 0, longitude: Double(txtViewLongitude.text ?? "") ?? 0), eyeAltitude: Double(txtViewAltitude.text ?? "") ?? 0)
        
        mapView.setCamera(camera, animated: animated)
    }
    
    // Just a small bit of validation before evaluating.
    private func validateTextFields(textField: UITextField) {
        // Prevent any of the textfields from being 0.
        if textField.text!.isEmpty {
            textField.text = "0"
        }
        
        if textField == txtLongitude {
            txtViewLongitude.text = txtLongitude.text
        }
        
        if textField == txtLatitude {
            txtViewLatitude.text = txtLatitude.text
        }
    }
}

extension GeocodeSuggestionViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(textField: UITextField) {
        validateTextFields(textField)
        refreshMapViewWithNewTextFieldValues(true)
    }
}