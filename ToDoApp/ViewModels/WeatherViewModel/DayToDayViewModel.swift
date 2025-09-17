//
//  DayToDayViewModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
import SwiftUI

@MainActor
class DayToDayViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var dailyForecast: [ForecastDay] = []
    
    private let weatherService = WeatherService()
    
    func getDayToDayWeather(for location: String) async {
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
    func formatDateToWeekday(_ dateStr: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateStr) {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEEE"
            return weekdayFormatter.string(from: date)
        }
        return "Unknown"
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
