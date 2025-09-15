//
//  DayToDayViewModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
import SwiftUI

class DayToDayViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var dailyForecast: [ForecastDay] = []
    
    private let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func getDayToDayWeather(for location: String) async {
        errorMessage = nil
        isLoading = true
        
        do {
            let dailyWeather = try await weatherService.fetchWeather(for: location)
            
            // Debug: Print the first day's condition data
            if let firstDay = dailyWeather.forecast.forecastday.first {
                print("🌤️ DayToDayViewModel: First day condition text: \(firstDay.day.condition.text)")
                print("🌤️ DayToDayViewModel: First day condition icon: \(firstDay.day.condition.icon)")
            }
            
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
}
