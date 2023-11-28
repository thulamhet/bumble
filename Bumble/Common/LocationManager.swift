//
//  LocationManager.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 28/11/2023.
//

import Foundation
import CoreLocation

class YourLocationManager: NSObject, CLLocationManagerDelegate {

    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    // CLLocationManagerDelegate method called when the location is updated
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            // Do something with the location
        }
    }

    // Handle location manager errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
