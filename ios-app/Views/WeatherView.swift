//
//  WeatherView.swift
//  ios-app
//
//  Created by Lucy Bellott on 6/19/24.
//

import SwiftUI

struct WeatherView: View {
    var weather: ResponseBody
    
     //Function to convert Kelvin to Fahrenheit
        func kelvinToFahrenheit(_ kelvin: Double) -> Double {
            return (kelvin - 273.15) * 9/5 + 32
        }
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.name)
                        .bold().font(.title)
                    Text("\(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                    }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                
                Spacer()
                
                VStack {
                    HStack{
                        VStack(spacing: 20){
                            Image(systemName: "cloud")
                                .font(.system(size:50))
                            
                            Text("\(weather.weather[0].main)")
                            
                        }
                        .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        
                        Text(kelvinToFahrenheit(weather.main.temp).roundDouble() + "°")
                            .font(.system(size:90))
                            .fontWeight(.bold)
//                            .padding()
                    }
                    
                    Spacer().frame(height: 80)
                    
                    AsyncImage(url: URL(string: "https://cdn-icons-png.flaticon.com/512/6503/6503066.png"))
                    { image in image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 300)
                                    
                                } placeholder: {
                                    ProgressView()
                                }
                    Spacer()
                    
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            .padding()
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            
            VStack{
                Spacer()
                
                VStack (alignment: .leading, spacing:20) {
                    Text("Today").bold().padding(.bottom)
                    
                    HStack{
                        WeatherRow(logo: "thermometer", name: "Min", value:(kelvinToFahrenheit(weather.main.tempMin).roundDouble()) + "°")
                        Spacer()
                        WeatherRow(logo: "thermometer", name: "Max", value:(kelvinToFahrenheit(weather.main.tempMax).roundDouble()) + "°")
                    }
                    HStack{
                        WeatherRow(logo: "wind", name: "Wind", value:(weather.wind.speed).roundDouble() + "m/s")
                        Spacer()
                        WeatherRow(logo: "humidity.fill", name: "Humidity", value:(weather.main.humidity.roundDouble() + "%"))
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.637, saturation: 0.822, brightness: 0.456))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
            
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.637, saturation: 0.822, brightness: 0.456))
        .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    WeatherView(weather: previewWeather)
}
