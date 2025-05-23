//
//  NetworkService.swift
//  WeatherApi
//
//  Created by Mangust on 18.05.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case noInternetConnection
}

struct NetworkService {
    func getJson(from urlString: String) async -> String? {
        await withCheckedContinuation { continuation in
            getRequest(urlString) { result in
                switch(result) {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(_):
                    continuation.resume(returning:(nil))
                }
            }
        }
    }

    func getWeatherData(json: String, converter: JsonToWeatherConverter) -> WeatherEntityFull? {
        converter.getWeatherData(from: json)
    }
}

fileprivate extension NetworkService {
    func performRequest(
        urlString: String,
        method: String = "GET",
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method

        if let headers = headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }

        if method.uppercased() == "POST", let params = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: [])
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                completion(.failure(.decodingFailed(error)))
                return
            }
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.requestFailed(error)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  200..<300 ~= httpResponse.statusCode,
                  let data = data else {
                completion(.failure(.invalidResponse))
                return
            }

            guard let result = String(data: data, encoding: .utf8) else {
                completion(.failure(.invalidResponse))
                return
            }

            completion(.success(result))
        }.resume()
    }

    func getRequest(
        _ urlString: String,
        headers: [String: String]? = nil,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        performRequest(
            urlString: urlString,
            method: "GET",
            headers: headers,
            completion: completion
        )
    }
}
