//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Jyoti on 19/03/25.
//

import SwiftUI

 struct WeatherDetailView: View {
    var cityWeather: CityWeather
//    var weather: WeatherResponse

    var body: some View {
        ZStack {
            Color.lightBlue.edgesIgnoringSafeArea(.all)
            VStack {
                // Navigation
                HStack {
//                    NavigationLink(destination: CitySelectionView()) {
//                        Image(systemName: "line.horizontal.3")
//                            .font(.title)
//                            .foregroundColor(.black)
//                    }
//                    Spacer()
                    Text(cityWeather.cityName)
                        .font(.system(size: 22, weight: .bold))
                    Spacer()
                    NavigationLink(destination: WeatherListView()) {
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                // Date
                Text(formattedDate(Date()))
                    .foregroundColor(.white)
                    .font(.system(size: 16))

                // Weather Icon & Details
                Image(systemName: weatherIcon(for: cityWeather.icon))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(.yellow)


                Text(cityWeather.condition)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)

                Text(cityWeather.temperature)
                    .font(.system(size: 60, weight: .bold))

//                HStack {
//                    Text("↑ \(cityWeather.highTemperature)")
//                    Text("↓ \(cityWeather.lowTemperature)")
//                }
//                .foregroundColor(.gray)
                VStack {
                    // Hourly Forecast
                    HStack {
                        Text("Today")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(cityWeather.hourlyForecast, id: \.time) { forecast in
                                VStack {
                                    Text(forecast.time)
                                        .font(.system(size: 14))
                                    Image(systemName: forecast.icon)
                                        .font(.title)
                                    Text(forecast.temperature)
                                        .font(.system(size: 16, weight: .bold))
                                }
                                .padding()
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                    }
                }.frame(height: 150)
                Spacer()
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Weather now")
                            .bold()
                            .padding(.bottom)
                        
                        HStack {
                            WeatherRow(logo: "thermometer", name: "Min temp", value: (cityWeather.lowTemperature) + ("°"))
                            Spacer()
                            WeatherRow(logo: "thermometer", name: "Max temp", value: (cityWeather.highTemperature + "°"))
                        }
                        
                        HStack {
                            WeatherRow(logo: "wind", name: "Wind speed", value: (cityWeather.windSpeed + "m/s"))
                            Spacer()
                            WeatherRow(logo: "humidity", name: "Humidity", value: "\(cityWeather.humidity)%")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 20)
                    .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                    .background(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
                // Bottom Forecast Section
//                VStack {
//                    // Hourly Forecast
//                    HStack {
//                        Text("Today")
//                            .font(.title2)
//                            .bold()
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack(spacing: 15) {
//                            ForEach(cityWeather.hourlyForecast, id: \.time) { forecast in
//                                VStack {
//                                    Text(forecast.time)
//                                        .font(.system(size: 14))
//                                    Image(systemName: forecast.icon)
//                                        .font(.title)
//                                    Text(forecast.temperature)
//                                        .font(.system(size: 16, weight: .bold))
//                                }
//                                .padding()
//                                .background(Color.blue.opacity(0.2))
//                                .cornerRadius(15)
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//
//                    Divider()
//                        .padding(.horizontal)
//
//                    // Daily Forecast
//                    HStack {
//                        Text("Every day")
//                            .font(.title2)
//                            .bold()
//                        Spacer()
//                    }
//                    .padding(.horizontal)
//                    
////                    ScrollView(.vertical, showsIndicators: false){
//                        VStack(spacing: 10) {
//                            ForEach(cityWeather.dailyForecast, id: \.date) { forecast in
//                                HStack {
//                                    Text(forecast.date)
//                                        .foregroundColor(.gray)
//                                    Spacer()
//                                    Text(forecast.highTemp)
//                                        .bold()
//                                    Text(forecast.lowTemp)
//                                        .foregroundColor(.gray)
//                                }
//                               
//                                .padding(.horizontal)
//                            }
//                        }
//                               
//                   
//
//                    Spacer()
//                }
//                .frame(height: 400)
//                .background(Color.clear.opacity(0.9))
//                .foregroundColor(.white)
//                .clipShape(RoundedRectangle(cornerRadius: 30))
//                .padding(.bottom, 10)
            }
        }.edgesIgnoringSafeArea(.bottom)
            .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
            .preferredColorScheme(.dark)
    }
     func formatTime(_ timeString: String) -> String {
         let dateFormatter = ISO8601DateFormatter()
         if let date = dateFormatter.date(from: timeString) {
             let timeFormatter = DateFormatter()
             timeFormatter.dateFormat = "HH:mm"
             return timeFormatter.string(from: date)
         }
         return timeString
     }

     func formatDate(_ dateString: String) -> String {
         let dateFormatter = ISO8601DateFormatter()
         if let date = dateFormatter.date(from: dateString) {
             let outputFormatter = DateFormatter()
             outputFormatter.dateFormat = "EEE, MMM d"
             return outputFormatter.string(from: date)
         }
         return dateString
     }
      func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE, MMM d" // Example: "Mon, Nov 17"
            return formatter.string(from: date)
        }
     func weatherIcon(for iconCode: String) -> String {
         switch iconCode {
         case "01d": return "sun.max.fill"
         case "01n": return "moon.fill"
         case "02d": return "cloud.sun.fill"
         case "02n": return "cloud.moon.fill"
         case "03d", "03n": return "cloud.fill"
         case "04d", "04n": return "smoke.fill"
         case "09d", "09n": return "cloud.drizzle.fill"
         case "10d": return "cloud.rain.fill"
         case "10n": return "cloud.moon.rain.fill"
         case "11d", "11n": return "cloud.bolt.rain.fill"
         case "13d", "13n": return "snowflake"
         case "50d", "50n": return "cloud.fog.fill" // Used for Smoke, Mist, Fog
         default: return "questionmark.circle"
         }
     }

//     func weatherIcon(for condition: String) -> String {
//         switch condition.lowercased() {
//         case "clear":
//             return "sun.max.fill"
//         case "cloudy":
//             return "cloud.fill"
//         case "rain":
//             return "cloud.rain.fill"
//         case "thunderstorm":
//             return "cloud.bolt.rain.fill"
//         case "snow":
//             return "snowflake"
//         case "fog":
//             return "cloud.fog.fill"
//         case "partly cloudy":
//             return "cloud.sun.fill"
//         case "windy":
//             return "wind"
//         case "smoke":
//             return "wind"
//         default:
//             return "questionmark.circle" // Default icon for unknown conditions
//         }
//     }

}


// MARK: - Sample Data for Preview

import SwiftUI

struct WeatherRow: View {
    var logo: String
    var name: String
    var value: String
    
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: logo)
                .font(.title2)
                .frame(width: 20, height: 20)
                .padding()
                .background(Color(hue: 1.0, saturation: 0.0, brightness: 0.888))
                .cornerRadius(50)

            
            VStack(alignment: .leading, spacing: 8) {
                Text(name)
                    .font(.caption)
                
                Text(value)
                    .bold()
                    .font(.headline)
            }
        }
    }
}

struct WeatherRow_Previews: PreviewProvider {
    static var previews: some View {
        WeatherRow(logo: "thermometer", name: "Feels like", value: "8°")
    }
}
