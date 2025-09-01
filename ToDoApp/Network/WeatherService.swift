//
//  WeatherService.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//

import Foundation

class WeatherService {
    private let apiKey = ProcessInfo.processInfo.environment["Weather_Api_Key"]
    private let baseURL = "https://api.weatherapi.com/v1/forecast.json"
    
    func fetchWeather(for location: String, days: Int = 3) async throws -> WeatherForecastModel {
        guard var urlComponents = URLComponents(string: baseURL) else {
            throw WeatherServiceError.invalidURL
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "q", value: location),
            URLQueryItem(name: "days", value: "\(days)"),
            URLQueryItem(name: "aqi", value: "no"),
            URLQueryItem(name: "alerts", value: "no")
        ]
        
        guard let url = urlComponents.url else {
            throw WeatherServiceError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw WeatherServiceError.invalidResponse
        }
        
        let decoder = JSONDecoder()

        do {
            let weather = try decoder.decode(WeatherForecastModel.self, from: data)
            return weather
        } catch {
            throw WeatherServiceError.decodingFailed(error)
        }
    }
}

enum WeatherServiceError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingFailed(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL."
        case .invalidResponse:
            return "Invalid response from the server."
        case .decodingFailed(let error):
            return "Failed to decode weather data: \(error.localizedDescription)"
        }
    }
}
