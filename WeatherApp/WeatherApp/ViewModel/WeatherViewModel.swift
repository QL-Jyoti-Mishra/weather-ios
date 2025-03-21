//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Jyoti on 19/03/25.
//

import Foundation
import Combine
import CoreLocation
import SwiftUI


//class WeatherViewModel: ObservableObject {
//    @Published var cities: [CityWeather] = []
//    @Published var searchQuery: String = ""
//
//    private var cancellables = Set<AnyCancellable>()
//    private let geocoder = CLGeocoder()
//
//    func addCity(_ city: String) {
//        geocoder.geocodeAddressString(city) { [weak self] placemarks, error in
//            guard let location = placemarks?.first?.location, error == nil else { return }
//            
//            DispatchQueue.main.async {
//                self?.fetchWeather(city: city, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//            }
//        }
//    }
//
//    func fetchWeather(city: String, latitude: Double, longitude: Double) {
//        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true"
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTaskPublisher(for: url)
//            .map { $0.data }
//            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//               
//                           switch completion {
//                           case .failure(let error):
//                               print("❌ API Error:", error.localizedDescription)
//                           case .finished:
//                               print("✅ Successfully fetched weather data")
//                           }
//                       }, receiveValue: {
//                weatherResponse in
//                let weather = CityWeather(
//                    cityName: city,
//                    temperature: "\(weatherResponse.current_weather.temperature)",
//                    windSpeed: weatherResponse.current_weather.windspeed, condition: self.getWeatherCondition(code: weatherResponse.current_weather.weathercode)
//                )
//
//                // Append to city list
//                self.cities.append(weather)
//            })
//            .store(in: &cancellables)
//    }
//
//    private func getWeatherCondition(code: Int) -> String {
//        switch code {
//        case 0: return "☀️ Clear Sky"
//        case 1...3: return "🌤️ Partly Cloudy"
//        case 45...48: return "🌫️ Foggy"
//        case 51...55: return "🌧️ Light Rain"
//        case 61...65: return "🌧️ Heavy Rain"
//        case 80...82: return "🌩️ Thunderstorm"
//        default: return "☁️ Cloudy"
//        }
//    }
//}
//
import SwiftUI
import Combine
import CoreLocation

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var cities: [CityWeather] = []
    @Published var weatherResponse: [WeatherResponse] = []
    @Published var searchQuery: String = ""

    private var cancellables = Set<AnyCancellable>()
    private let geocoder = CLGeocoder()
    private let locationManager = CLLocationManager()
    private var currentCity: String = "Current Location"
    @Published var location: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        setupLocationManager()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locationq = locations.first else { return }
        guard let location = locations.first?.coordinate else { return }
        self.location = location
        // Reverse geocode to get city name
        geocoder.reverseGeocodeLocation(locationq) { [weak self] placemarks, error in
            guard let self = self, let placemark = placemarks?.first, error == nil else { return }
            
            let cityName = placemark.locality ?? "Current Location"
            
            DispatchQueue.main.async {
                self.fetchWeather(city: cityName, latitude: location.latitude, longitude: location.longitude)
            }
        }
        
        locationManager.stopUpdatingLocation() // Stop updating after fetching location
    }



        func addCity(_ city: String) {
            geocoder.geocodeAddressString(city) { [weak self] placemarks, error in
                guard let location = placemarks?.first?.location, error == nil else { return }
    
                DispatchQueue.main.async {
                    self?.fetchWeather(city: city, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }
            }
        }
    
        func fetchWeather(city: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=48532a5e16bd27acbb55cf0c9b778afc&units=metric"
//            let urlString = "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true"
            guard let url = URL(string: urlString) else { return }
    
            URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: WeatherResponse.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
    
                               switch completion {
                               case .failure(let error):
                                   print("❌ API Error:", error.localizedDescription)
                               case .finished:
                                   print("✅ Successfully fetched weather data")
                               }
                           }, receiveValue: {
                    weatherResponse in
//                               self.weatherResponse.append(weatherResponse)
                            let sampleHourlyData: [HourlyWeather] = [
                                   HourlyWeather(time: "10 AM", temperature: "22°", icon: "cloud.sun.fill"),
                                   HourlyWeather(time: "11 AM", temperature: "24°", icon: "sun.max.fill"),
                                   HourlyWeather(time: "12 PM", temperature: "26°", icon: "cloud.fill")
                               ]
                               let weather = CityWeather(cityName: city, temperature: "\(weatherResponse.main.temp)°C",   highTemperature: "\(weatherResponse.main.tempMax)°C",
                                                         lowTemperature: "\(weatherResponse.main.tempMin)°C", humidity: weatherResponse.main.humidity, windSpeed: "\(weatherResponse.wind.speed)", condition: weatherResponse.weather.first!.main, icon: weatherResponse.weather.first!.icon, hourlyForecast: sampleHourlyData,
                    dailyForecast: [
                        DailyWeather(date: "Mon, Nov 17", highTemp: "31°", lowTemp: "23°"),
                        DailyWeather(date: "Tue, Nov 18", highTemp: "29°", lowTemp: "22°"),
                        DailyWeather(date: "Wed, Nov 19", highTemp: "27°", lowTemp: "20°"),
                        DailyWeather(date: "Thus, Nov 17", highTemp: "31°", lowTemp: "23°"),
                        DailyWeather(date: "Fri, Nov 18", highTemp: "29°", lowTemp: "22°"),
                        DailyWeather(date: "Sat, Nov 19", highTemp: "27°", lowTemp: "20°"),
                        DailyWeather(date: "Sun, Nov 19", highTemp: "27°", lowTemp: "20°"),
                    ])
    
                    // Append to city list
                    self.cities.append(weather)
                })
                .store(in: &cancellables)
        }
    
       /// Get the appropriate SF Symbol for weather condition
       private func getWeatherIcon(for condition: String) -> String {
           switch condition {
           case "☀️ Clear Sky": return "sun.max.fill"
           case "🌤️ Partly Cloudy": return "cloud.sun.fill"
           case "🌫️ Foggy": return "cloud.fog.fill"
           case "🌧️ Light Rain", "🌧️ Heavy Rain": return "cloud.rain.fill"
           case "🌩️ Thunderstorm": return "cloud.bolt.rain.fill"
           default: return "cloud.fill"
           }
       }
    
    private func getWeatherCondition(code: Int) -> String {
        switch code {
        case 0: return "☀️ Clear Sky"
        case 1...3: return "🌤️ Partly Cloudy"
        case 45...48: return "🌫️ Foggy"
        case 51...55: return "🌧️ Light Rain"
        case 61...65: return "🌧️ Heavy Rain"
        case 80...82: return "🌩️ Thunderstorm"
        default: return "☁️ Cloudy"
        }
    }
}
