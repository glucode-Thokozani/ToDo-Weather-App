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
    
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol) {
        self.weatherService = weatherService
    }
    
    func getHourToHourWeather(for location: String) {
        errorMessage = nil
        isLoading = true
        
        Task {
            do {
                let hourlyWeather = try await weatherService.fetchWeather(for: location, days: 3)
                await MainActor.run {
                    hourlyForecast = hourlyWeather.forecast.forecastday.first?.hour ?? []
                }
            } catch {
                await MainActor.run {
                    hourlyForecast = []
                }
            }
            await MainActor.run {
                isLoading = false
            }
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

/**
 package com.example.newweathertodoapp.ViewModels.WeatherViewModels

 import androidx.lifecycle.ViewModel
 import androidx.lifecycle.viewModelScope
 import com.example.newweathertodoapp.Models.WeatherModel.ForecastDay
 import com.example.newweathertodoapp.Network.WeatherService
 import kotlinx.coroutines.flow.MutableStateFlow
 import kotlinx.coroutines.flow.StateFlow
 import kotlinx.coroutines.launch
 import java.text.SimpleDateFormat
 import java.util.Locale

 class DayToDayViewModel(
     private val weatherService: WeatherService
 ) : ViewModel() {

     private val _isLoading = MutableStateFlow(false)
     val isLoading: StateFlow<Boolean> get() = _isLoading

     private val _errorMessage = MutableStateFlow<String?>(null)
     val errorMessage: StateFlow<String?> get() = _errorMessage

     private val _dailyForecast = MutableStateFlow<List<ForecastDay>>(emptyList())
     val dailyForecast: StateFlow<List<ForecastDay>> get() = _dailyForecast

     fun getDayToDayWeather(location: String) {
         viewModelScope.launch {
             _errorMessage.value = null
             _isLoading.value = true
             try {
                 val dailyWeather = weatherService.getWeather(
                     apiKey = "YOUR_API_KEY",
                     city = location,
                     days = 3
                 )
                 _dailyForecast.value = dailyWeather.forecast.forecastday
             } catch (e: Exception) {
                 _dailyForecast.value = emptyList()
                 _errorMessage.value = e.message
             } finally {
                 _isLoading.value = false
             }
         }
     }

     fun formatDateToWeekday(dateStr: String): String {
         return try {
             val formatter = SimpleDateFormat("yyyy-MM-dd", Locale.getDefault())
             val date = formatter.parse(dateStr)
             val weekdayFormatter = SimpleDateFormat("EEEE", Locale.getDefault())
             date?.let { weekdayFormatter.format(it) } ?: "Unknown"
         } catch (e: Exception) {
             "Unknown"
         }
     }
 }

 */
