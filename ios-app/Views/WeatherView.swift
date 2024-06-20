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
    
    // Function to get the image URL based on the weather condition
    func getImageUrl(for weatherCondition: String) -> URL? {
        switch weatherCondition.lowercased() {
        case "clouds":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/1163/1163624.png")
        case "rain":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/414/414974.png")
        case "snow":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/642/642102.png")
        case "clear":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/869/869869.png")
        case "thunderstorm":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/1146/1146860.png")
        case "drizzle":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/4550/4550234.png")
        case "mist":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/2913/2913615.png")
        case "smoke":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/4380/4380458.png")
        case "haze":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/4380/4380485.png")
        case "dust":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/4380/4380485.png")
        case "fog":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/2913/2913615.png")
        case "sand":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/414/414825.png")
        case "ash":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/414/414845.png")
        case "squall":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/1779/1779807.png")
        case "tornado":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/1146/1146869.png")
        default:
            return URL(string: "https://cdn-icons-png.flaticon.com/512/6503/6503066.png")
        }
    }
    
    // Function to get the system image name based on the weather condition
    func getSystemImageName(for weatherCondition: String) -> String {
        switch weatherCondition.lowercased() {
        case "clouds":
            return "cloud"
        case "rain":
            return "cloud.rain"
        case "snow":
            return "cloud.snow"
        case "clear":
            return "sun.max"
        case "thunderstorm":
            return "cloud.bolt"
        case "drizzle":
            return "cloud.drizzle"
        case "mist":
            return "cloud.fog"
        case "smoke":
            return "smoke"
        case "haze":
            return "sun.haze"
        case "dust", "sand", "ash":
            return "aqi.low"
        case "fog":
            return "cloud.fog"
        case "squall":
            return "wind"
        case "tornado":
            return "tornado"
        default:
            return "questionmark"
        }
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
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack {
                    HStack {
                        VStack(spacing: 20) {
                            Image(systemName: getSystemImageName(for: weather.weather[0].main))
                                .font(.system(size: 50))
                            
                            Text("\(weather.weather[0].main)")
                        }
                        .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        
                        Text(kelvinToFahrenheit(weather.main.temp).roundDouble() + "°")
                            .font(.system(size: 90))
                            .fontWeight(.bold)
                    }
                    
                    Spacer().frame(height: 80)
                    
                    AsyncImage(url: getImageUrl(for: weather.weather[0].main)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 250)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 20) {
                    Text("Today").bold().padding(.bottom)
                    
                    HStack {
                        WeatherRow(logo: "thermometer", name: "Min", value: (kelvinToFahrenheit(weather.main.tempMin).roundDouble()) + "°")
                        Spacer()
                        WeatherRow(logo: "thermometer", name: "Max", value: (kelvinToFahrenheit(weather.main.tempMax).roundDouble()) + "°")
                    }
                    HStack {
                        WeatherRow(logo: "wind", name: "Wind", value: (weather.wind.speed.roundDouble() + "m/s"))
                        Spacer()
                        WeatherRow(logo: "humidity.fill", name: "Humidity", value: (weather.main.humidity.roundDouble() + "%"))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .padding(.bottom, 20)
                .foregroundColor(Color(hue: 0.637, saturation: 0.822, brightness: 0.456))
                .background(.white)
                .cornerRadius(20, corners: [.topLeft, .topRight])
            }
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.637, saturation: 0.822, brightness: 0.456))
        .preferredColorScheme(.dark)
    }
}

#Preview {
    WeatherView(weather: previewWeather)
}
