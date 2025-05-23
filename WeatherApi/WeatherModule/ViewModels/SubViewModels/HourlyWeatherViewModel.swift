//
//  HourlyWeatherViewModel.swift
//  WeatherApi
//
//  Created by Mangust on 18.05.2025.
//

import Foundation
import UIKit

struct HourlyWeatherViewModel: Hashable {
    let hour: String?
    let conditionIcon: String
    let iconImage: UIImage?
    let temperature: String?
}


