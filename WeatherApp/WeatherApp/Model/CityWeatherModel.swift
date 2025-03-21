//
//  CityWeatherModel.swift
//  WeatherApp
//
//  Created by Jyoti on 19/03/25.
//
//
import Foundation
//
//struct WeatherResponse: Codable {
//    let current_weather: Weather
//}
//
//struct Weather: Codable {
//    let temperature: Double
//    let windspeed: Double
//    let weathercode: Int
//}


// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let coord: Coordinates
    let weather: [Weather]
    let main: MainWeather
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let lon: Double
    let lat: Double
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

// MARK: - MainWeather
struct MainWeather: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    let seaLevel: Int?
    let grndLevel: Int?

    enum CodingKeys: String, CodingKey {
        case temp, pressure, humidity
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double?
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Sys
struct Sys: Codable {
    let type: Int?
    let id: Int?
    let country: String
    let sunrise: Int
    let sunset: Int
}

struct CityWeather: Identifiable {
    let id = UUID()
    let cityName: String
    let temperature: String
    let highTemperature: String
    let lowTemperature: String
    let humidity: Int
    let windSpeed: String
    let condition: String
    let icon: String
    let hourlyForecast: [HourlyWeather]
    let dailyForecast: [DailyWeather]
}

struct HourlyWeather: Identifiable {
    let id = UUID()
    let time: String
    let temperature: String
    let icon: String
}

struct DailyWeather: Identifiable {
    let id = UUID()
    let date: String
    let highTemp: String
    let lowTemp: String
}
