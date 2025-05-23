//
//  UserDefaultsService.swift
//  WeatherApi
//
//  Created by Mangust on 22.05.2025.
//

import Foundation

protocol UserDefaultsProtocol {
    func set<T: Codable>(_ value: T, forKey key: String)
    func get<T: Codable>(forKey key: String) -> T?
    func remove(forKey key: String)
}

struct UserDefaultsService: UserDefaultsProtocol {
    static let shared = UserDefaultsService()

    private let userDefaults: UserDefaults

    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func set<T: Codable>(_ value: T, forKey key: String) {
        if let value: T = get(forKey: key) {
            print("The value \(value) exists")
        } else {
            do {
                let data = try JSONEncoder().encode(value)
                userDefaults.set(data, forKey: key)
            } catch {
                print("Failed to encode and save data: \(error)")
            }

            return
        }
    }

    func get<T: Codable>(forKey key: String) -> T? {
        guard let data = userDefaults.data(forKey: key) else {
            return nil
        }

        do {
            let value = try JSONDecoder().decode(T.self, from: data)
            return value
        } catch {
            return nil
        }
    }

    func remove(forKey key: String) {
        userDefaults.removeObject(forKey: key)
    }
}
