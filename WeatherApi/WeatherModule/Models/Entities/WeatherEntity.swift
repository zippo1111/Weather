//
//  WeatherEntity.swift
//  WeatherApi
//
//  Created by Mangust on 18.05.2025.
//

import Foundation

struct WeatherEntity: Codable {
    let location: Location
    let current: CurrentWeather

    struct Location: Codable {
        let name: String
        let lat: Double
        let lon: Double
        let localtime_epoch: Int
        let localtime: String
    }

    struct CurrentWeather: Codable {
        let last_updated_epoch: Int
        let last_updated: String
        let temp_c: Double
        let condition: Condition
    }

    struct Condition: Codable {
        let text: String
        let icon: String
    }
}


struct WeatherEntityFull: Codable {
    let location: Location
    let current: CurrentWeather
    let forecast: Forecast?

    struct Location: Codable {
        let name: String
        let lat: Double
        let lon: Double
        let localtime_epoch: Int
        let localtime: String
    }

    struct CurrentWeather: Codable {
        let last_updated_epoch: Int
        let last_updated: String
        let condition: Condition

        var tempCeil: Int {
            return Int(ceil(temp_c))
        }

        private let temp_c: Double
    }

    struct Condition: Codable, Equatable {
        let text: String
        let icon: String
    }

    struct Forecast: Codable {
        let forecastday: [ForecastDay]
    }

    struct ForecastDay: Codable, Equatable {
        static func == (lhs: WeatherEntityFull.ForecastDay, rhs: WeatherEntityFull.ForecastDay) -> Bool {
            return lhs.date == rhs.date &&
            lhs.date_epoch == rhs.date_epoch &&
            lhs.day == rhs.day &&
            lhs.hour == rhs.hour
        }

        let date: String
        let date_epoch: Int
        let day: Day
        let hour: [Hour]
    }

    struct Day: Codable, Equatable {
        static func == (lhs: WeatherEntityFull.Day, rhs: WeatherEntityFull.Day) -> Bool {
            return lhs.maxtemp_c == rhs.maxtemp_c &&
            lhs.mintemp_c == rhs.mintemp_c &&
            lhs.avgtemp_c == rhs.avgtemp_c &&
            lhs.condition == rhs.condition
        }

        let condition: Condition

        var maxTempCeil: Int {
            return Int(ceil(maxtemp_c))
        }

        var minTempCeil: Int {
            return Int(ceil(mintemp_c))
        }

        var avgTempCeil: Int {
            return Int(ceil(avgtemp_c))
        }

        private let maxtemp_c: Double
        private let mintemp_c: Double
        private let avgtemp_c: Double
    }

    struct Hour: Codable, Equatable {
        let time_epoch: Int
        let time: String
        let temp_c: Double
        let condition: Condition
    }
}
