//
//  UserDefaultsService.swift
//  WeatherApi
//
//  Created by Mangust on 19.05.2025.
//

import Foundation
import CoreLocation

final class LocationService: NSObject {
    var showAlertForSettingsCallback: (() -> Void)?
    var detectedLocationCallback: ((CLLocation) -> Void)?
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationPermission() {
        let status = CLLocationManager.authorizationStatus()

        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            showAlertForSettingsCallback?()
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            break
        }
    }

    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        case .denied, .restricted:
            showAlertForSettingsCallback?()
        default:
            break
        }


    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last else {
            return
        }

        detectedLocationCallback?(latestLocation)
    }
}
