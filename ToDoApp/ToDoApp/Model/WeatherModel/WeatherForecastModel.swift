//
//  WeatherForecastModel.swift
//  ToDoApp
//
//  Created by Thokozani Mncube on 2025/08/25.
//
struct WeatherForecastModel: Codable {
    let location: Location
    let current: CurrentWeather
    let forecast: Forecast
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let localtime: String
    let lat: Double?
    let lon: Double?
    let tzId: String?
    let localtimeEpoch: Int?

    enum CodingKeys: String, CodingKey {
        case name, region, country, localtime
        case lat, lon
        case tzId = "tz_id"
        case localtimeEpoch = "localtime_epoch"
    }
}

struct CurrentWeather: Codable {
    let tempC: Double
    let condition: WeatherCondition
    let windKph: Double
    let humidity: Int
    let feelslikeC: Double

    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case condition
        case windKph = "wind_kph"
        case humidity
        case feelslikeC = "feelslike_c"
    }
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let day: Day
    let astro: Astro
    let hour: [HourlyWeather]
}

struct Day: Codable {
    let maxtempC: Double
    let mintempC: Double
    let avgtempC: Double
    let dailyChanceOfRain: Int
    let condition: WeatherCondition

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case mintempC = "mintemp_c"
        case avgtempC = "avgtemp_c"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case condition
    }
}

struct Astro: Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
}
struct HourlyWeather: Codable {
    let time: String
    let tempC: Double
    let condition: WeatherCondition
    let humidity: Int
    let windKph: Double

    enum CodingKeys: String, CodingKey {
        case time
        case tempC = "temp_c"
        case condition
        case humidity
        case windKph = "wind_kph"
    }
}

struct WeatherCondition: Codable {
    let text: String
    let icon: String
}
