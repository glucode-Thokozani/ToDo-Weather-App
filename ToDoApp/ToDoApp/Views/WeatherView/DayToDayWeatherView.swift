//
//  WeeksWeatherView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/20.
//
import SwiftUI

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

