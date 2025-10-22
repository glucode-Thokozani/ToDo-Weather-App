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
    private let dayToDayWeatherView: AnyView
    @State private var selected = 0
    @State private var showSearch = false

    init(viewModel: WeatherViewModel,
         hourToHourWeatherView: AnyView,
         dayToDayWeatherView: AnyView) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.hourToHourWeatherView = hourToHourWeatherView
        self.dayToDayWeatherView = dayToDayWeatherView
    }

    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 16) {
                HStack {
                    WeatherLocationView(cityName: viewModel.cityName)
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Button(action: {
                        showSearch = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top)

                ScrollView {
                    MainWeatherView(viewModel: viewModel, temperature: viewModel.currentTemperature)
                        .padding(.vertical)
                    
                    HStack {
                        AstronomyScrollView(astronomy: viewModel.astronomy)
                    }
                    .background(.ultraThinMaterial.opacity(0.5))
                    .cornerRadius(12)
                    .padding()
                    
                    WeatherPickerView(
                        hourToHourWeatherView: hourToHourWeatherView,
                        dayToDayWeatherView: dayToDayWeatherView
                    )
                }

                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            if showSearch {
                WeatherSearchView(
                    searchQuery: $viewModel.searchLocation,
                    isPresented: $showSearch,
                    onSearch: {
                        await viewModel.searchWeather()
                    }
                )
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchWeather(for: "Johannesburg")
            }
        }
    }
}
