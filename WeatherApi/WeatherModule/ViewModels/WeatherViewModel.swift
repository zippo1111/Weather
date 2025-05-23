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

        return allHours?.map { hour in
            let iconImage = data?.icons.filter { key, _ in
                key == hour.time_epoch
            }.first

            return HourlyWeatherViewModel(
                hour: hour.time.dateToShortHour(),
                conditionIcon: hour.condition.icon,
                iconImage: iconImage?.value,
                temperature: "\(hour.temp_c)"
            )
        }
    }

    func getDailyModel() async -> [DailyWeatherViewModel]? {
        let data = await model.getData()

        return data?.forecastdays.map { day in
            let iconImage = data?.icons.filter { key, _ in
                key == day.date_epoch
            }.first

            return DailyWeatherViewModel(
                day: day.date.dateToShortDay(),
                conditionIcon: iconImage?.value,
                temperatureMin: "\(day.day.minTempCeil)",
                temperatureMax: "\(day.day.maxTempCeil)"
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

