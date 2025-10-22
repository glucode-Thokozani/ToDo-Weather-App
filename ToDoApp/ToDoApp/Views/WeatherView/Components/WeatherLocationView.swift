//
//  WeatherLocationView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/01.
//

import SwiftUI

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
