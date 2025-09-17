//
//  WeeksWeatherView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/20.
//
import SwiftUI

struct DayToDayWeatherView: View {
    @StateObject private var dailyViewModel = DayToDayViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(dailyViewModel.dailyForecast.prefix(7), id: \.date) { day in
                    HStack {
                        Text(dailyViewModel.formatDateToWeekday(day.date))
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.white)
                            .frame(width: 150, alignment: .leading)
                        Image(systemName: dailyViewModel.getSFIconName(for: day.day.condition.text))
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.white)
                        
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
    @StateObject private var dailyViewModel = DayToDayViewModel()
    
    var body: some View {
        VStack {
            if dailyViewModel.dailyForecast.count > 1 {
                let tomorrow = dailyViewModel.dailyForecast[1]
                
                Text("\(Int(tomorrow.day.avgtempC))°C")
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
                
                Image(systemName: dailyViewModel.getSFIconName(for: tomorrow.day.condition.text))
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.white)
                
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
