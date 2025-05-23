//
//  Constants.swift
//  WeatherApi
//
//  Created by Mangust on 22.05.2025.
//

import UIKit
import CoreLocation

enum Constants {
    static let celcium = "\u{00B0}C"
    static let refreshIcon = UIImage(systemName: "arrow.triangle.2.circlepath")
    static let locationMoscow = CLLocation(latitude: 55.75, longitude: 37.62)
    static let timeZone = "Europe/Moscow"
    static let daysDateFormat = "yyyy-MM-dd HH:mm"
    static let daysLimiter = 3
    struct LocationAlert {
        static let title = "Location Access Needed"
        static let message = "Please enable location permissions in Settings"
        static let toSettingsTitle = "Open Settings"
        static let cancelTitle = "Cancel"
    }

    struct UserDefaults {
        static let defaultLocationKey = "defaultLocation"
    }

    struct API {
        static let query = "http://api.weatherapi.com/v1/forecast.json?key=%20fa8b3df74d4042b9aa7135114252304&days=7&q="
    }
}
