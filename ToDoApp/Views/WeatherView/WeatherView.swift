//
//  WeatherView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/19.
//

import SwiftUI
 

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

struct WeatherLocationView: View {
    var cityName: String
    
    var body: some View {
        HStack {
            Image("LocationPin")
                .resizable()
                .frame(width: 30, height: 30)
            
            Text(cityName)
                .font(.system(size: 25, weight: .medium))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct MainWeatherView: View {
    @ObservedObject var viewModel: WeatherViewModel
    var temperature: Int
    
    var body: some View {
        VStack {
            Text("\(temperature)°C")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.white)
            
            WeatherIconView(
                iconURL: viewModel.currentCondition?.icon ?? "",
                size: 50,
                fallbackIcon: "questionmark",
                conditionText: viewModel.currentCondition?.text ?? ""
            )
            
            Text(viewModel.currentCondition?.text ?? "")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 5)
        }
    }
}

struct AstronomyScrollView: View {
    @State private var selectedPage: Int = 0
    let astronomy: Astro?
    
    var body: some View {
        let pages = [
            [
                AstronomyEvent(title: "Sunrise", icon: "sunrise.fill", time: astronomy?.sunrise ?? "--"),
                AstronomyEvent(title: "Sunset", icon: "sunset.fill", time: astronomy?.sunset ?? "--")
            ],
            [
                AstronomyEvent(title: "Moonrise", icon: "moon.stars.fill", time: astronomy?.moonrise ?? "--"),
                AstronomyEvent(title: "Moonset", icon: "moon.zzz.fill", time: astronomy?.moonset ?? "--")
            ]
        ]
        
        TabView(selection: $selectedPage) {
            ForEach(pages.indices, id: \.self) { index in
                HStack(spacing: 175) {
                    ForEach(pages[index], id: \.title) { event in
                        VStack {
                            Image(systemName: event.icon)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                            
                            Text(event.title)
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(event.time)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                }
                .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 130)
    }
}

struct AstronomyEvent: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let time: String
}

struct WeatherPickerView: View {
    @State private var selected = 0
    private let hourToHourWeatherView: AnyView
    private let tomorrowWeatherView: AnyView
    private let dayToDayWeatherView: AnyView

    init(hourToHourWeatherView: AnyView, tomorrowWeatherView: AnyView, dayToDayWeatherView: AnyView) {
        self.hourToHourWeatherView = hourToHourWeatherView
        self.tomorrowWeatherView = tomorrowWeatherView
        self.dayToDayWeatherView = dayToDayWeatherView
    }

    var body: some View {
        VStack {
            Picker("Weather: ", selection: $selected) {
                Text("Today").tag(0)
                Text("Tomorrow").tag(1)
                Text("3-Day").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .accentColor(.white)

            if selected == 0 {
                hourToHourWeatherView
                    .frame(height: 150)
            } else if selected == 1 {
                tomorrowWeatherView
                    .frame(height: 150)
            } else {
                dayToDayWeatherView
            }
        }
    }
}


