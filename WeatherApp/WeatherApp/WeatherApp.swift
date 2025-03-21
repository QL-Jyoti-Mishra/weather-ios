//
//  WeatherApp.swift
//  WeatherApp
//
//  Created by Jyoti on 19/03/25.
//

import Foundation
import SwiftUI

struct WeatherApp: View {
    @EnvironmentObject var  weatherViewModel: WeatherViewModel
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image(systemName: "cloud.bolt.rain.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.white)
                
                VStack {
                    Text("Weather")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(Color.yellow)
                    
                    Text("Forecast App.")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                }
                
                Text("It's the newest weather app. It has a bunch of features and that includes most of the ones that every weather app has.")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                Spacer()
                
                NavigationLink(destination: {
                    if let firstCity = weatherViewModel.cities.first {
                        WeatherDetailView(cityWeather: firstCity)
                    } else {
                        EmptyView() // Placeholder to avoid crash
                    }
                }) {
                    getStartedButton()
                }
                .padding(.bottom, 50)
            }
            .padding(.top, 50)
        }
    }
    // Reusable "Get Started" Button
       @ViewBuilder
       private func getStartedButton() -> some View {
           Text("Get Started")
               .font(.system(size: 20, weight: .bold))
               .frame(width: 200, height: 50)
               .background(Color.yellow)
               .foregroundColor(.white)
               .cornerRadius(25)
               .padding(.bottom, 50)
               .buttonStyle(PlainButtonStyle()) // Prevents default button styling
       }
}
