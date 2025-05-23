//
//  WeatherByDaysHoursModel.swift
//  WeatherApi
//
//  Created by Mangust on 18.05.2025.
//

import Foundation
import UIKit

struct WeatherByDaysHoursModel {
    let cityName: String?
    let conditionIcon: String?
    let forecastdays: [WeatherEntityFull.ForecastDay]
    let icons: [Int: UIImage?]
    let temperatureCurrent: String?
}
