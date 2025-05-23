//
//  DailyWeatherViewModel.swift
//  WeatherApi
//
//  Created by Mangust on 18.05.2025.
//

import Foundation

struct DailyWeatherViewModel: Hashable {
    let day: String?
    let conditionIcon: String?
    let temperatureMin: String?
    let temperatureMax: String?
}
