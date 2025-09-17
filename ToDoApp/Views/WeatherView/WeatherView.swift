//
//  WeatherView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/19.
//

import SwiftUI
import SwiftUIPager

struct WeatherView: View {
    @StateObject private var viewModel: WeatherViewModel
    private let hourToHourWeatherView: AnyView
    private let tomorrowWeatherView: AnyView
    private let dayToDayWeatherView: AnyView
    @State private var selected = 0
    
    init(viewModel: WeatherViewModel,
         hourToHourWeatherView: AnyView,
         tomorrowWeatherView: AnyView,
         dayToDayWeatherView: AnyView) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.hourToHourWeatherView = hourToHourWeatherView
        self.tomorrowWeatherView = tomorrowWeatherView
        self.dayToDayWeatherView = dayToDayWeatherView
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack {
                WeatherLocationView(cityName: viewModel.cityName)
                ScrollView {
                    Spacer()
                    MainWeatherView(viewModel: viewModel, temperature: viewModel.currentTemperature)
                    Spacer()
                    HStack {
                        AstronomyScrollView(astronomy: viewModel.astronomy)
                    }
                    .background(.ultraThinMaterial.opacity(0.5))
                    .cornerRadius(12)
                    .padding()
                    Spacer()
                    WeatherPickerView(
                        hourToHourWeatherView: hourToHourWeatherView,
                        tomorrowWeatherView: tomorrowWeatherView,
                        dayToDayWeatherView: dayToDayWeatherView
                    )
                }
            }
        }
        .onAppear {
            viewModel.fetchWeather(for: "Johannesburg")
        }
    }
}



