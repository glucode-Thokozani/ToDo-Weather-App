//
//  WeatherIconView.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/09/08.
//

import SwiftUI

struct WeatherIconView: View {
    let iconURL: String
    let size: CGFloat
    let fallbackIcon: String
    let conditionText: String
    
    @State private var image: UIImage?
    @State private var isLoading = true
    
    init(iconURL: String, size: CGFloat = 50, fallbackIcon: String = "questionmark", conditionText: String = "") {
        self.iconURL = iconURL
        self.size = size
        self.fallbackIcon = fallbackIcon
        self.conditionText = conditionText
    }
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
            } else if isLoading {
                ProgressView()
                    .frame(width: size, height: size)
            } else {
                Image(systemName: getSFIconForCondition(conditionText))
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        
        let fullURL: String
        if iconURL.hasPrefix("http://") || iconURL.hasPrefix("https://") {
            fullURL = iconURL
        } else if iconURL.hasPrefix("//") {
            fullURL = "https:\(iconURL)"
        } else if iconURL.hasPrefix("/") {
            fullURL = "https://cdn.weatherapi.com\(iconURL)"
        } else {
            fullURL = "https://cdn.weatherapi.com/weather/64x64/day/\(iconURL)"
        }
        
        guard let url = URL(string: fullURL) else {
            isLoading = false
            return
        }
        
        print("🌤️ WeatherIconView: Final URL: \(url)")
        var request = URLRequest(url: url)
        request.setValue("image/*", forHTTPHeaderField: "Accept")
        request.timeoutInterval = 10.0
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("WeatherIconView: Error loading image: \(error.localizedDescription)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    print("WeatherIconView: HTTP Status: \(httpResponse.statusCode)")
                    if httpResponse.statusCode != 200 {
                        print("WeatherIconView: HTTP Error - Status: \(httpResponse.statusCode)")
                    }
                }
                
                if let data = data {
                    print("🌤️ WeatherIconView: Received \(data.count) bytes of data")
                    if let uiImage = UIImage(data: data) {
                        print("WeatherIconView: Successfully loaded image")
                        self.image = uiImage
                    } else {
                        print("WeatherIconView: Failed to create UIImage from data")
                    }
                } else {
                    print("WeatherIconView: No data received")
                }
                self.isLoading = false
            }
        }.resume()
    }
    
    private func getSFIconForCondition(_ condition: String) -> String {
        let lower = condition.lowercased()
        
        if lower.contains("sun") || lower.contains("clear") {
            return "sun.max.fill"
        } else if lower.contains("cloud") {
            return "cloud.fill"
        } else if lower.contains("rain") {
            return "cloud.rain.fill"
        } else if lower.contains("snow") {
            return "snowflake"
        } else if lower.contains("thunder") || lower.contains("storm") {
            return "cloud.bolt.fill"
        } else if lower.contains("fog") || lower.contains("mist") {
            return "cloud.fog.fill"
        } else if lower.contains("wind") {
            return "wind"
        } else {
            return fallbackIcon
        }
    }
}
