//
//  DateConverter.swift
//  WeatherApi
//
//  Created by Mangust on 21.05.2025.
//

import Foundation

extension String {
    func dateToShortDay() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")

        guard let date = dateFormatter.date(from: self) else {
            return nil
        }

        let weekdayFormatter = DateFormatter()
        weekdayFormatter.locale = Locale(identifier: "ru_RU")
        weekdayFormatter.dateFormat = "E"

        let dayName = weekdayFormatter.string(from: date).uppercased()

        return dayName
    }

    func dateToShortHour() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        guard let date = dateFormatter.date(from: self) else {
            return nil
        }

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "H"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")

        let shortHour = timeFormatter.string(from: date)

        return shortHour
    }
}

extension Date {
    func startOfDay() -> Date {
        Calendar.current.startOfDay(for: self)
    }
}
