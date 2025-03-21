//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Jyoti on 17/03/25.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject var weatherViewModel = WeatherViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                WeatherApp()
            }.navigationBarBackButtonHidden(true)
            .environmentObject(weatherViewModel)
        }
    }
}

