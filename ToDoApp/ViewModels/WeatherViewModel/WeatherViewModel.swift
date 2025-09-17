//
//  WeatherViewModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var cityName: String = ""
    @Published var currentTemperature: Int = 0
    @Published var currentConditionText: String = ""
    @Published var astronomy: Astro?
    
    
    private let weatherService = WeatherService()
    
    func fetchWeather(for location: String) {
        errorMessage = nil
        isLoading = true
        
        Task {
            do {
                let weather = try await weatherService.fetchWeather(for: location)
                
                cityName = "\(weather.location.name), \(weather.location.region)"
                currentTemperature = Int(weather.current.tempC)
                currentConditionText = weather.current.condition.text
                astronomy = weather.forecast.forecastday.first?.astro
                
            } catch {
                errorMessage = error.localizedDescription
                print("Weather fetch error: \(error)")
                
                cityName = ""
                currentTemperature = 0
                currentConditionText = ""
                astronomy = nil
            }
            
            isLoading = false
        }
    }
    func evaluateTemperature(temperature: Int) -> (icon: String, text: String) {
        if temperature < 0 {
            return ("snowflake", "It is very cold. Dress warmly 🥶")
        } else if temperature <= 19 {
            return ("wind", "Cold and windy. Dress accordingly 💨")
        } else if temperature > 20 {
            return ("sun.max.fill", "The sun is out, enjoy the heat 🔥")
        } else {
            return ("questionmark", "No cute message 🫥")
        }
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



