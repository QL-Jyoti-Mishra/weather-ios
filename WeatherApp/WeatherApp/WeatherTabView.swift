////
////  WeatherView.swift
////  WeatherApp
////
////  Created by Jyoti on 18/03/25.
////
//
import SwiftUI
import CoreData
import CoreLocation
import Combine
import Foundation


struct WeatherAppTabView: View {
    @EnvironmentObject var  weatherViewModel: WeatherViewModel
    var body: some View {
        TabView {
            if let firstCity = weatherViewModel.cities.first {
                WeatherDetailView(cityWeather: firstCity) // Pass a single object
                            .tabItem {
                                Label("Weather", systemImage: "cloud.sun.fill")
                            }
                    } else {
                        Text("No City Selected") // Show a placeholder if no data
                            .tabItem {
                                Label("Weather", systemImage: "cloud.sun.fill")
                            }
                    }
            CitySelectionView()
                .tabItem {
                    Label("Cities", systemImage: "magnifyingglass")
                }
        }
    }
}

struct CitySelectionView: View {
    @State private var searchText = ""
    @EnvironmentObject var weatherViewModel: WeatherViewModel
    let temperatures = ["28°", "24°", "36°"]
    
    var body: some View {
        VStack {
            TextField("Search a new city...", text: $searchText)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                .padding()
            
            List(0..<weatherViewModel.cities.count, id: \..self) { index in
                NavigationLink(destination:  WeatherDetailView(cityWeather: weatherViewModel.cities[index])) {
                    HStack {
                        Text(weatherViewModel.cities[index].cityName)
                        Spacer()
                        Text(temperatures[index])
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Choose a city")
    }
}
import SwiftUI

struct WeatherListView: View {
    @EnvironmentObject private var viewModel: WeatherViewModel
    @State private var newCity = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter city name", text: $newCity)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button("Add City") {
                    if !newCity.isEmpty {
                        viewModel.addCity(newCity)
                        newCity = ""  // Clear input field after adding
                    }
                }
                .padding()
               
                .padding(.bottom, 50)
                List(viewModel.cities) { cityWeather in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(cityWeather.cityName)
                                .font(.headline)
                            Text(cityWeather.condition)
                                .font(.subheadline)
                        }
                        Spacer()
                        Text("\(cityWeather.temperature)°C")
                            .font(.title2)
                    }
                }
                .navigationTitle("City List")
            }
        }
    }
}


