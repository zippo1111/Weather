//
//  LocationData.swift
//  WeatherApi
//
//  Created by Mangust on 22.05.2025.
//

import Foundation
import CoreLocation

struct LocationData: Codable {
    let latitude: Double
    let longitude: Double

    init(location: CLLocation) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
    }

    func toCLLocation() -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
}
