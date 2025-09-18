//
//  HourToHourWeatherViewModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
import SwiftUI

class HourToHourWeatherViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var hourlyForecast: [HourlyWeather] = []
    
    private let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func getHourToHourWeather(for location: String) {
        errorMessage = nil
        isLoading = true
        
        Task {
            do {
                let hourlyWeather = try await weatherService.fetchWeather(for: location, days: 3)
                hourlyForecast = hourlyWeather.forecast.forecastday.first?.hour ?? []
            } catch {
                hourlyForecast = []
            }
            isLoading = false
        }
    }
    func formattedHour(from timeString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        if let date = inputFormatter.date(from: timeString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "HH:mm"
            return outputFormatter.string(from: date)
        }
        return "--"
    }
    
}
