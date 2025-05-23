//
//  WeatherByDaysHoursModel.swift
//  WeatherApi
//
//  Created by Mangust on 18.05.2025.
//

import Foundation

struct WeatherByDaysHoursModel {
    let cityName: String?
    let conditionIcon: String?
    let forecastdays: [WeatherEntityFull.ForecastDay]
    let temperatureCurrent: String?
}
