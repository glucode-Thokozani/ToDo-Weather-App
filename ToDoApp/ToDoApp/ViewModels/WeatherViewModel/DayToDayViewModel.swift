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
    
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func getDayToDayWeather(for location: String) async {
        await MainActor.run {
            errorMessage = nil
            isLoading = true
        }
        
        do {
            let dailyWeather = try await weatherService.fetchWeather(for: location, days: 3)
            
            await MainActor.run {
                dailyForecast = dailyWeather.forecast.forecastday
                isLoading = false
            }
        } catch {
            await MainActor.run {
                dailyForecast = []
                isLoading = false
            }
        }
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
