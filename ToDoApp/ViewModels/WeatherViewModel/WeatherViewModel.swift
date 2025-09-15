//
//  WeatherViewModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
import SwiftUI

class WeatherViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var cityName: String = ""
    @Published var currentTemperature: Int = 0
    @Published var currentCondition: WeatherCondition?
    @Published var astronomy: Astro?
    
    private let weatherService: WeatherService
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func fetchWeather(for location: String) {
        errorMessage = nil
        isLoading = true
        
        Task {
            do {
                let weather = try await weatherService.fetchWeather(for: location)
                
                cityName = "\(weather.location.name), \(weather.location.region)"
                currentTemperature = Int(weather.current.tempC)
                currentCondition = weather.current.condition
                astronomy = weather.forecast.forecastday.first?.astro
                
            } catch {
                errorMessage = error.localizedDescription
                
                cityName = ""
                currentTemperature = 0
                currentCondition = nil
                astronomy = nil
            }
            
            isLoading = false
        }
    }
}



