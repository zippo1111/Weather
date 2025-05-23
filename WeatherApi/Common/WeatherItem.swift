//
//  Item.swift
//  MainCollectionWithInnerCollections
//
//  Created by Mangust on 20.05.2025.
//

import Foundation

enum WeatherItem: Hashable, Identifiable {
    case hourly(id: UUID, model: HourlyWeatherViewModel)
    case daily(id: UUID, model: DailyWeatherViewModel)

    init(hourlyModel: HourlyWeatherViewModel) {
        self = .hourly(id: UUID(), model: hourlyModel)
    }

    init(dailyModel: DailyWeatherViewModel) {
        self = .daily(id: UUID(), model: dailyModel)
    }

    var id: UUID {
        switch self {
        case .hourly(let id, _):
            return id
        case .daily(let id, _):
            return id
        }
    }
}
