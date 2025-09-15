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
    
    private let weatherService = WeatherService()
    
    func getWeatherText(for location: String) async {
        errorMessage = nil
        isLoading = true
        
        do {
            let dailyWeather = try await weatherService.fetchWeather(for: location)
            dailyForecast = dailyWeather.forecast.forecastday
        } catch {
            dailyForecast = []
        }
        isLoading = false
    }
    
    func gradientFor(weather: String) -> [Color] {
        switch weather {
        case "Rain": return [Color.blue.opacity(0.6), Color.gray]
        case "Snow": return [Color.gray, Color.blue.opacity(0.3)]
        case "Cloudy": return [Color.gray, Color.white]
        default: return [Color.blue, Color.blue.opacity(10)]
        }
    }
}
