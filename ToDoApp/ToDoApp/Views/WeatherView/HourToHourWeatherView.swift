//
//  TodaysWeatherView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/20.
//
import SwiftUI

struct HourToHourWeatherView: View {
    @StateObject private var hourlyViewModel: HourToHourWeatherViewModel
    init(hourlyViewModel: HourToHourWeatherViewModel) {
        self._hourlyViewModel = StateObject(wrappedValue: hourlyViewModel)
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(hourlyViewModel.hourlyForecast.prefix(25), id: \.time) { hour in
                    VStack(spacing: 10) {
                        
                        Text("\(Int(hour.tempC))°C")
                            .font(.system(size: 23))
                            .foregroundColor(.white)
                        
                        WeatherIconView(
                            iconURL: hour.condition.icon,
                            size: 50,
                            fallbackIcon: "questionmark",
                            conditionText: hour.condition.text
                        )
                        
                        Text(hourlyViewModel.formattedHour(from: hour.time))
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal)
        }
        .frame(height: 130)
        .background(.ultraThinMaterial.opacity(0.3))
        .cornerRadius(12)
        .padding(.horizontal)
        .onAppear {
            hourlyViewModel.getHourToHourWeather(for: "Johannesburg")
        }
    }
}
