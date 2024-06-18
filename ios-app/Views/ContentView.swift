//
//  ContentView.swift
//  ios-app
//
//  Created by Lucy Bellott on 6/18/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            
            if let location = locationManager.location{
                Text("Your coordinates are: \(location.longitude), \(location.latitude)")
            }
            
            WelcomeView()
                .environmentObject(locationManager)
        }
        
        .background(Color(hue: 0.637, saturation: 0.822, brightness: 0.456))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ContentView()
}
