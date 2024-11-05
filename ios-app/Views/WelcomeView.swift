//
//  WelcomeView.swift
//  ios-app
//
//  Created by Lucy Bellott on 6/18/24.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        VStack {
            VStack(spacing: 20){
                Text("WoofWeather 🐶")
                    .bold().font(.title)
                Text("Please share your location")
                    .padding()
            }
            .multilineTextAlignment(.center)
            .padding()
            
            LocationButton(.shareCurrentLocation){
                locationManager.requestLocation()
            }

            
//                        Button(action: {
//                print("Share Location button tapped")
//                locationManager.requestLocation()
//            }) {
//                Text("Share Location")
//                    .bold()
//                    .frame(width: 200, height: 50)
//                    .background(Color.blue)
//                    .foregroundColor(.white)
//                    .cornerRadius(10)
//            }
         
            
            
            
            
            .cornerRadius(30)
            .symbolVariant(.fill)
            .foregroundColor(.white)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    WelcomeView().environmentObject(LocationManager())
}
