//
//  WeatherModels.swift
//  WeatherApi
//
//  Created by Mangust on 18.05.2025.
//

import Foundation
import UIKit

protocol WeatherModelsProtocol {
    func getData() async -> WeatherByDaysHoursModel?
}

struct WeatherModels: WeatherModelsProtocol {
    private let networkService = NetworkService()
    private let converter = JsonToWeatherConverter()
    private let cacheService = CacheService()
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

        var iconAddresses: [Int: String] = [:]
        for day in days {
            for hour in day.hour {
                iconAddresses[hour.time_epoch] = hour.condition.icon
            }
        }

        let icons = await loadIcons(for: iconAddresses)

        return WeatherByDaysHoursModel(
            cityName: entity.location.name,
            conditionIcon: entity.current.condition.icon,
            forecastdays: filteredDays ?? [],
            icons: icons,
            temperatureCurrent: "\(entity.current.tempCeil)"
        )
    }

    private func loadIcons(for epochIcons: [Int: String]) async -> [Int: UIImage?] {
        await withTaskGroup(of: (Int, UIImage?).self) { group in
            for (key, value) in epochIcons {
                group.addTask {
                    let image = await loadImageIfNeeded(for: value, by: key)
                    return (key, image)
                }
            }

            var result: [Int: UIImage?] = [:]
            for await (key, image) in group {
                result[key] = image
            }
            return result
        }
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

    private func loadImageIfNeeded(for address: String, by key: Int) async -> UIImage? {
        if let cachedImage = cacheService.get(by: key) {
            return cachedImage
        }

        guard let url = URL(string: "https://\(String(address.dropFirst(2)))") else {
            return nil
        }

        if #available(iOS 15.0, *) {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let image = UIImage(data: data)

                cacheService.set(value: image, for: key)
                return image
            } catch {
                return nil
            }
        } else {
            // Fallback on earlier versions
            return await withCheckedContinuation { continuation in
                URLSession.shared.dataTask(with: url) { data, response, error in
                    if let data = data, error == nil {
                        let image = UIImage(data: data)

                        cacheService.set(value: image, for: key)
                        continuation.resume(returning: image)
                    } else {
                        continuation.resume(returning: nil)
                    }
                }.resume()
            }
        }
    }
}
