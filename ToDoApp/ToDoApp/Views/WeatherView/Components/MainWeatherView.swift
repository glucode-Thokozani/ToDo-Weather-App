//
//  MainWeatherView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import SwiftUI

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
