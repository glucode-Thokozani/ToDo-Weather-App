//
//  WeatherViewModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
import SwiftUI
import WidgetKit

class WeatherViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var cityName: String = ""
    @Published var currentTemperature: Int = 0
    @Published var currentCondition: WeatherCondition?
    @Published var astronomy: Astro?
    @Published var searchLocation: String = ""
    
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func fetchWeather(for location: String) async {
        await MainActor.run {
            errorMessage = nil
            isLoading = true
        }
        
        do {
            let weather = try await weatherService.fetchWeather(for: location, days: 3)
            
            await MainActor.run {
                cityName = weather.location.name
                currentTemperature = Int(weather.current.tempC)
                currentCondition = weather.current.condition
                astronomy = weather.forecast.forecastday.first?.astro
                
                let sharedDefaults = UserDefaults(suiteName: "group.com.TK.ToDoApp")
                sharedDefaults?.set(currentTemperature, forKey: "temperature")
                sharedDefaults?.set(currentCondition?.text, forKey: "condition")
                sharedDefaults?.set(cityName, forKey: "city")
                
                WidgetCenter.shared.reloadAllTimelines()
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                
                cityName = ""
                currentTemperature = 0
                currentCondition = nil
                astronomy = nil
            }
        }
        
        await MainActor.run {
            isLoading = false
        }
    }
    
    func searchWeather() async {
        guard !searchLocation.isEmpty else {
            return
        }
        await fetchWeather(for: searchLocation)
    }
}



