//
//  WeatherPickerView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import SwiftUI

struct WeatherPickerView: View {
    @State private var selected = 0
    private let hourToHourWeatherView: AnyView
    private let dayToDayWeatherView: AnyView

    init(hourToHourWeatherView: AnyView, dayToDayWeatherView: AnyView) {
        self.hourToHourWeatherView = hourToHourWeatherView
        self.dayToDayWeatherView = dayToDayWeatherView
    }

    var body: some View {
        VStack {
            Picker("Weather: ", selection: $selected) {
                Text("Today").tag(0)
                Text("3-Day").tag(2)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .accentColor(.white)

            if selected == 0 {
                hourToHourWeatherView
                    .frame(height: 150)
            }
            else {
                dayToDayWeatherView
            }
        }
    }
}
