//
//  WeatherViewModelTest.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/10/03.
//
import XCTest
@testable import ToDoApp

final class WeatherViewModelTest {
    
    func testSomething() {
        let viewModel: WeatherViewModel = WeatherViewModel(weatherService: MockWeatherService())
        viewModel.fetchWeather(for: "Cape Town")
        XCTAssertEqual(viewModel.cityName, "Cape Town")
    }
}

final class MockWeatherService: WeatherServiceProtocol {
    func fetchWeather(for location: String, days: Int) async throws -> ToDoApp.WeatherForecastModel {
        return mockWeatherForecast
    }
    
    let mockWeatherForecast = WeatherForecastModel(
        location: Location(
            name: "Cape Town",
            region: "Western Cape",
            country: "South Africa",
            localtime: "2025-10-03 14:30",
            lat: -33.9249,
            lon: 18.4241,
            tzId: "Africa/Johannesburg",
            localtimeEpoch: 1759482600
        ),
        current: CurrentWeather(
            tempC: 22.5,
            condition: WeatherCondition(
                text: "Partly cloudy",
                icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
            ),
            windKph: 15.0,
            humidity: 60,
            feelslikeC: 22.0
        ),
        forecast: Forecast(
            forecastday: [
                ForecastDay(
                    date: "2025-10-03",
                    day: Day(
                        maxtempC: 25.0,
                        mintempC: 15.0,
                        avgtempC: 20.0,
                        dailyChanceOfRain: 10,
                        condition: WeatherCondition(
                            text: "Sunny",
                            icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
                        )
                    ),
                    astro: Astro(
                        sunrise: "06:10 AM",
                        sunset: "06:45 PM",
                        moonrise: "08:20 PM",
                        moonset: "07:15 AM"
                    ),
                    hour: [
                        HourlyWeather(
                            time: "2025-10-03 09:00",
                            tempC: 18.0,
                            condition: WeatherCondition(
                                text: "Sunny",
                                icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
                            ),
                            humidity: 65,
                            windKph: 10.0
                        ),
                        HourlyWeather(
                            time: "2025-10-03 12:00",
                            tempC: 22.0,
                            condition: WeatherCondition(
                                text: "Partly cloudy",
                                icon: "//cdn.weatherapi.com/weather/64x64/day/116.png"
                            ),
                            humidity: 55,
                            windKph: 12.0
                        ),
                        HourlyWeather(
                            time: "2025-10-03 15:00",
                            tempC: 24.5,
                            condition: WeatherCondition(
                                text: "Sunny",
                                icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
                            ),
                            humidity: 50,
                            windKph: 18.0
                        )
                    ]
                )
            ]
        )
    )

}

