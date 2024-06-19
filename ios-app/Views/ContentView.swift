//
//  ContentView.swift
//  ios-app
//
//  Created by Lucy Bellott on 6/18/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    var body: some View {
        VStack {
            
            if let location = locationManager.location {
                
                if let weather = weather {
                    Text("weather data fetched")
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await
                                weatherManager.getCurrentWeather(latitude: location.latitude, longitude: location.longitude)
                                
                            } catch {
                                print("Error getting weather: \(error)")
                            }
                        }
                }
                
            } else {
                if locationManager.isLoading {
                    
                    LoadingView()
                    
                } else {
                    WelcomeView().environmentObject(locationManager)
                }
            }

        }
        
        .background(Color(hue: 0.637, saturation: 0.822, brightness: 0.456))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
}
