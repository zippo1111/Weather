//
//  DailyWeatherViewModel.swift
//  WeatherApi
//
//  Created by Mangust on 18.05.2025.
//

import Foundation
import UIKit

struct DailyWeatherViewModel: Hashable {
    let day: String?
    let conditionIcon: UIImage?
    let temperatureMin: String?
    let temperatureMax: String?
}
