//
//  BackgroundViewModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/15.
//
import SwiftUI

@MainActor
class BackgroundViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var dailyForecast: [ForecastDay] = []
    @Published var currentCondition: WeatherCondition?
    
    private let weatherService = WeatherService()
    
    var weatherType: WeatherType {
        guard let weatherText = currentCondition?.text else {
            return .unknown
        }
        return WeatherType.from(weatherText)
    }
    
    func getWeatherText(for location: String) async {
        errorMessage = nil
        isLoading = true
        
        do {
            let dailyWeather = try await weatherService.fetchWeather(for: location)
            dailyForecast = dailyWeather.forecast.forecastday
            currentCondition = dailyWeather.current.condition
            
        } catch {
            dailyForecast = []
            currentCondition = nil
        }
        isLoading = false
    }
    
    func gradientFor(weather: String) -> [Color] {
        switch weather {
        case "rain": return [Color.blue.opacity(0.6), Color.gray]
        case "snow": return [Color.gray, Color.blue.opacity(0.3)]
        case "cloudy": return [Color.gray, Color.white]
        default: return [Color.blue, Color.blue.opacity(10)]
        }
    }
    
    enum WeatherType: String {
        case sunny
        case cloudy
        case rain
        case snow
        case unknown
        
        static func from(_ text: String) -> WeatherType {
            let lowercased = text.lowercased()
            if lowercased.contains("sunny") {
                return .sunny
            } else if lowercased.contains("cloudy") {
                return .cloudy
            } else if lowercased.contains("rain") {
                return .rain
            } else if lowercased.contains("snow") {
                return .snow
            } else {
                return .unknown
            }
        }
        
    }
}
