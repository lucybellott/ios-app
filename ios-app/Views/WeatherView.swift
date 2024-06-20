//
//  WeatherView.swift
//  ios-app
//
//  Created by Lucy Bellott on 6/19/24.
//


import SwiftUI

struct WeatherView: View {
    @State private var city: String = ""
    var weather: ResponseBody
    
    // Function to convert Kelvin to Fahrenheit
    func kelvinToFahrenheit(_ kelvin: Double) -> Double {
        return (kelvin - 273.15) * 9/5 + 32
    }
    
    // Function to get the image URL based on the weather condition
    func getImageUrl(for weatherCondition: String) -> URL? {
        switch weatherCondition.lowercased() {
        case "clouds":
            return URL(string: "https://i.pinimg.com/originals/84/9a/2e/849a2ef3fe74c896f94a462aa0bc4078.jpg")
        case "rain":
            return URL(string: "https://leadervet.com/wp-content/uploads/2019/09/Can-Weather-Affect-a-Dogs-Behavior.jpg")
        case "snow":
            return URL(string: "https://www.shutterstock.com/image-photo/funny-puppy-dog-corgi-warm-600nw-2104482491.jpg")
        case "clear":
            return URL(string: "https://www.theinertia.com/wp-content/uploads/2014/10/dog-beach.jpg")
        case "thunderstorm":
            return URL(string: "https://tippvet.com/wp-content/uploads/2020/08/bigstock-A-Cute-Little-Beagle-Dog-Hides-372628669_embiggened-cropped.png")
        case "drizzle":
            return URL(string: "https://www.dogingtonpost.com/wp-content/uploads/2020/09/rainyday-min-1000x600.jpg")
        case "mist":
            return URL(string: "https://dogdiscoveries.com/.image/t_share/MTg0OTc5NTkxODY4MTk2MzI3/foggs.jpg")
        case "smoke":
            return URL(string: "https://i.pinimg.com/736x/5f/91/f2/5f91f239c02fdcc83c9d6b78c89c76ea.jpg")
        case "haze":
            return URL(string: "https://img.freepik.com/premium-photo/white-dog-stands-fog-foggy-day_357532-14303.jpg")
        case "dust":
            return URL(string: "https://www.alphapaw.com/wp-content/uploads/2020/07/photo_2020-11-05_16-39-33.jpg")
        case "fog":
            return URL(string: "https://pbs.twimg.com/media/BfJ_3mMCUAA-O87?format=png&name=large")
        case "sand":
            return URL(string: "https://www.onegreenplanet.org/wp-content/uploads/2023/07/shutterstock_1131985073-1-scaled.jpg")
        case "ash":
            return URL(string: "https://www.madpaws.com.au/wp-content/uploads/2019/07/a.-staffordshire-terrier.jpg")
        case "squall":
            return URL(string: "https://cdn-icons-png.flaticon.com/512/1779/1779807.png")
        case "tornado":
            return URL(string: "https://i.pinimg.com/736x/09/c3/ff/09c3ffc814457f208550dd32f92c6135.jpg")
        default:
            return URL(string: "https://www.shutterstock.com/image-photo/funny-smile-dog-sunglasses-600nw-2251348601.jpg")
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
        //        VStack {
        //            SearchBar(text: $city)
        //                .padding()
    //             }
            
            
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
                                .frame(width: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 50))
                            
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
