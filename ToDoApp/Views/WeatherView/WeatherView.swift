//
//  WeatherView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/19.
//
import SwiftUI
import SwiftUIPager

struct WeatherView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            BackGroundColorView(startColor: Color.blue, endColor: Color("LightBlue"))
            VStack {
                WeatherLocationView(cityName: viewModel.cityName)
                ScrollView {
                    Spacer()
                    MainWeatherView(temperature: viewModel.currentTemperature)
                    Spacer()
                    HStack {
                        AstronomyScrollView(astronomy: viewModel.astronomy)
                    }
                    .background(.ultraThinMaterial.opacity(0.5))
                    .cornerRadius(12)
                    .padding()
                    Spacer()
                    WeatherPickerView()
                }
            }
        }
        .onAppear {
            viewModel.fetchWeather(for: "Johannesburg")
        }
    }
}

struct BackGroundColorView: View {
    var startColor: Color
    var endColor: Color
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [startColor, endColor]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
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
    @StateObject private var viewModel = WeatherViewModel()
    var temperature: Int
    var conditionText: String = ""
    
    var weatherInformation: (icon: String, text: String) {
        viewModel.evaluateTemperature(temperature: temperature)
    }
    
    var body: some View {
        VStack {
            Text("\(temperature)°C")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.white)
            
            Image(systemName: weatherInformation.icon)
                .renderingMode(.original)
                .resizable()
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
            
            Text(conditionText.isEmpty ? weatherInformation.text : viewModel.currentConditionText)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding()
        }
    }
}

struct AstronomyScrollView: View {
    @StateObject private var page: Page = .first()
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
        
        Pager(page: page, data: Array(pages.indices), id: \.self) { index in
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
        }
        .loopPages()
        .itemSpacing(10)
        .preferredItemSize(CGSize(width: UIScreen.main.bounds.width * 0.8, height: 130))
        .frame(height: 130)
        .animation(.easeInOut(duration: 0.3), value: page.index)
    }
}

struct WeatherPickerView: View {
    @State private var selected = 0
    
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
                HourToHourWeatherView()
                    .frame(height: 150) 
            } else if selected == 1 {
                TomorrowWeatherView()
                    .frame(height: 150)
            } else {
                DayToDayWeatherView()
            }
        }
    }
}



struct AstronomyEvent: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let time: String
}

#Preview {
    WeatherView()
}
