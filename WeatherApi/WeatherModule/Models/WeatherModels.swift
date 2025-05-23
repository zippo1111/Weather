//
//  WeatherModels.swift
//  WeatherApi
//
//  Created by Mangust on 18.05.2025.
//

import Foundation

protocol WeatherModelsProtocol {
    func getData() async -> WeatherByDaysHoursModel?
}

struct WeatherModels: WeatherModelsProtocol {
    private let networkService = NetworkService()
    private let converter = JsonToWeatherConverter()
    private let jsonAddress: String = {
        guard let locationData: LocationData = UserDefaultsService.shared.get(forKey: Constants.UserDefaults.defaultLocationKey) else {
            return "\(Constants.API.query)\(Constants.locationMoscow.coordinate.latitude),\(Constants.locationMoscow.coordinate.longitude)"
        }

        let location = locationData.toCLLocation()
        return "\(Constants.API.query)\(location.coordinate.latitude),\(location.coordinate.longitude)"
    }()

    func getData() async -> WeatherByDaysHoursModel? {
        guard let json = await networkService.getJson(from: jsonAddress) else {
            return nil
        }

        let entity = networkService.getWeatherData(
            json: json,
            converter: converter
        )

        guard let entity = entity,
              let days = entity.forecast?.forecastday else {
            return nil
        }

        let filteredDays = limitDays(to: Constants.daysLimiter, for: days)

        return WeatherByDaysHoursModel(
            cityName: entity.location.name,
            conditionIcon: entity.current.condition.icon,
            forecastdays: filteredDays ?? [],
            temperatureCurrent: "\(entity.current.tempCeil)"
        )
    }

    private func limitDays(to numberOfDays: Int, for data: [WeatherEntityFull.ForecastDay]) -> [WeatherEntityFull.ForecastDay]? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.daysDateFormat
        dateFormatter.timeZone = TimeZone(identifier: Constants.timeZone)

        let today = Calendar.current.startOfDay(for: Date())
        let threeDaysFromToday = Calendar.current.date(byAdding: .day, value: numberOfDays, to: today)!

        return data.map { day in
            let filteredHours = day.hour.filter { hour in
                guard let datetime = dateFormatter.date(from: hour.time) else {
                    return false
                }

                return datetime >= Date() && datetime <= threeDaysFromToday
            }

            return WeatherEntityFull.ForecastDay(date: day.date, date_epoch: day.date_epoch, day: day.day, hour: filteredHours)
        }
    }
}
