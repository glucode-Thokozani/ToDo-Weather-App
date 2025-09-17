//
//  HourToHourWeatherViewModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
import SwiftUI

@MainActor
class HourToHourWeatherViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var hourlyForecast: [HourlyWeather] = []
    
    private let weatherService = WeatherService()
    
    func getHourToHourWeather(for location: String) {
        errorMessage = nil
        isLoading = true
        
        Task {
            do {
                let hourlyWeather = try await weatherService.fetchWeather(for: location)
                
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
    func getSFIconName(for condition: String) -> String {
        let lower = condition.lowercased()
        
        if lower.contains("sun") {
            return "sun.max.fill"
        } else if lower.contains("cloud") {
            return "cloud.fill"
        } else if lower.contains("rain") {
            return "cloud.rain.fill"
        } else if lower.contains("snow") {
            return "snowflake"
        } else if lower.contains("clear"){
            return "moon.stars.fill"
        }
        else {
            return "questionmark"
        }
    }
}
