//
//  WeatherViewModel.swift
//  WeatherApi
//
//  Created by Mangust on 18.05.2025.
//

import Foundation
import CoreLocation

protocol WeatherViewModelProtocol {
    func getViewModel() async -> MainWeatherViewModel?
}

struct WeatherViewModel: WeatherViewModelProtocol {
    private let model = WeatherModels()

    func getViewModel() async -> MainWeatherViewModel? {
        MainWeatherViewModel(
            titleViewmodel: await getCityAndTemperature(),
            hourlyViewmodel: await getHourlyModel(),
            dailyViewmodel: await getDailyModel()
        )
    }
}

fileprivate extension WeatherViewModel {
    func getHourlyModel(_ numberOfDays: Int = 2) async -> [HourlyWeatherViewModel]? {
        let data = await model.getData()

        let allHours = data?.forecastdays.prefix(numberOfDays).flatMap { $0.hour }

        return allHours?.compactMap {
            HourlyWeatherViewModel(
                hour: $0.time.dateToShortHour(),
                conditionIcon: $0.condition.icon,
                temperature: "\($0.temp_c)"
            )
        }
    }

    func getDailyModel() async -> [DailyWeatherViewModel]? {
        let data = await model.getData()

        return data?.forecastdays.map {
            DailyWeatherViewModel(
                day: $0.date.dateToShortDay(),
                conditionIcon: $0.day.condition.icon,
                temperatureMin: "\($0.day.minTempCeil)",
                temperatureMax: "\($0.day.maxTempCeil)"
            )
        }
    }

    func getCityAndTemperature() async -> String? {
        guard let data = await model.getData(),
              let cityName = data.cityName,
              let temperatureCurrent = data.temperatureCurrent else {
            return nil
        }

        return "\(cityName)\n\(temperatureCurrent)\(Constants.celcium)"
    }
}

