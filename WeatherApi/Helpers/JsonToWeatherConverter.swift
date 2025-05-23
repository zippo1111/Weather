//
//  JsonToWeatherConverter.swift
//  WeatherApi
//
//  Created by Mangust on 19.05.2025.
//

import Foundation

struct JsonToWeatherConverter {
    func getWeatherData(from jsonString: String) -> WeatherEntityFull? {
        if let jsonData = jsonString.data(using: .utf8) {
            do {
                let weather = try JSONDecoder().decode(WeatherEntityFull.self, from: jsonData)
                return weather
            } catch {
                return nil
            }
        }

        return nil
    }
}
