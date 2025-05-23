//
//  MainWeatherViewModel.swift
//  WeatherApi
//
//  Created by Mangust on 20.05.2025.
//

import Foundation

struct MainWeatherViewModel: Hashable {
    let titleViewmodel: String?
    let hourlyViewmodel: [HourlyWeatherViewModel]?
    let dailyViewmodel: [DailyWeatherViewModel]?
}
