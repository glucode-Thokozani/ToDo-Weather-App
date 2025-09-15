//
//  WeeksWeatherView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/20.
//
import SwiftUI

// Updated DayToDayWeatherView
struct DayToDayWeatherView: View {
    @StateObject private var dailyViewModel: DayToDayViewModel
    init(dailyViewModel: DayToDayViewModel) {
        self._dailyViewModel = StateObject(wrappedValue: dailyViewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(dailyViewModel.dailyForecast.prefix(7), id: \.date) { day in
                    HStack {
                        Text(dailyViewModel.formatDateToWeekday(day.date))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 150, alignment: .leading)
                        
                        WeatherIconView(
                            iconURL: day.day.condition.icon,
                            size: 40,
                            fallbackIcon: "questionmark",
                            conditionText: day.day.condition.text
                        )
                        
                        Text("\(Int(day.day.avgtempC))°C")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 100, alignment: .trailing)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .background(.ultraThinMaterial.opacity(0.5))
        .cornerRadius(12)
        .padding()
        .onAppear {
            Task {
                await dailyViewModel.getDayToDayWeather(for: "Johannesburg")
            }
        }
    }
}

struct TomorrowWeatherView: View {
    @StateObject private var dailyViewModel: DayToDayViewModel
    
    init(dailyViewModel: DayToDayViewModel) {
        self._dailyViewModel = StateObject(wrappedValue: dailyViewModel)
    }
    
    var body: some View {
        VStack {
            if dailyViewModel.dailyForecast.count > 1 {
                let tomorrow = dailyViewModel.dailyForecast[1]
                
                Text("\(Int(tomorrow.day.avgtempC))°C")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                
                WeatherIconView(
                    iconURL: tomorrow.day.condition.icon,
                    size: 50,
                    fallbackIcon: "questionmark",
                    conditionText: tomorrow.day.condition.text
                )
                
                Text(tomorrow.day.condition.text)
                    .font(.headline)
                    .foregroundColor(.white)
            } else {
                Text("Loading...")
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            Task {
                await dailyViewModel.getDayToDayWeather(for: "Johannesburg")
            }
        }
    }
}
