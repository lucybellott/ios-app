//
//  WeatherView.swift
//  ios-app
//
//  Created by Lucy Bellott on 6/19/24.
//

import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    
    // Function to convert Kelvin to Fahrenheit
        func kelvinToFahrenheit(_ kelvin: Double) -> Double {
            return (kelvin - 273.15) * 9/5 + 32
        }
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.name)
                        .bold().font(.title)
                    Text("Today \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                    }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
                Spacer()
                
                VStack {
                    HStack{
                        Text("\(kelvinToFahrenheit(weather.main.temp).roundDouble())°F")
                            .font(.system(size:100))
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            .padding()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.637, saturation: 0.822, brightness: 0.456))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    WeatherView(weather: previewWeather)
}
