//
//  WeatherView.swift
//  ios-app
//
//  Created by Lucy Bellott on 6/19/24.
//


import SwiftUI

struct WeatherView: View {
    @State private var city: String = ""
    @State var weather: ResponseBody
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @StateObject private var weatherManager = WeatherManager()
    @State private var showingLoginSignup = false
    
    
    // Function to convert Kelvin to Fahrenheit
    func kelvinToFahrenheit(_ kelvin: Double) -> Double {
        return (kelvin - 273.15) * 9/5 + 32
    }
    
    // Function to calculate asphalt temperature based on air temperature
    func calculateAsphaltTemperature(airTemp: Double) -> Int {
        return Int(airTemp * 1.2 + 20)
    }

    // Function to calculate concrete temperature based on air temperature
    func calculateConcreteTemperature(airTemp: Double) -> Int {
        return Int(airTemp * 1.1 + 15)
    }
    

    // Function to get the image URL based on the weather condition
    func getLocalImageName(for weatherCondition: String) -> String {
        switch weatherCondition.lowercased() {
        case "clouds":
            return "clouds"
        case "rain":
            return "rain"
        case "snow":
            return "snow"
        case "clear":
            return "sunny"
        case "thunderstorm":
            return "thunder"
        case "drizzle":
            return "drizzle"
        case "mist":
            return "mist"
        case "smoke":
            return "sauna"
        case "haze":
            return "hazy"
        case "dust":
            return "dust"
        case "fog":
            return "fog"
        case "sand":
            return "sand"
        case "ash":
            return "ash"
        case "squall":
            return "squall"
        case "tornado":
            return "tornado"
        default:
            return "sauna"
        }
    }

    // Function to get the system icon name based on the weather condition
    func getSystemImageName(for weatherCondition: String) -> String {
        let imageName: String
        switch weatherCondition.lowercased() {
        case "clouds":
            imageName = "cloud"
        case "rain":
            imageName = "cloud.rain"
        case "snow":
            imageName = "cloud.snow"
        case "clear":
            imageName = "sun.max"
        case "thunderstorm":
            imageName = "cloud.bolt"
        case "drizzle":
            imageName = "cloud.drizzle"
        case "mist":
            imageName = "cloud.fog"
        case "smoke":
            imageName = "smoke"
        case "haze":
            imageName = "sun.haze"
        case "dust", "sand", "ash":
            imageName = "aqi.low"
        case "fog":
            imageName = "cloud.fog"
        case "squall":
            imageName = "wind"
        case "tornado":
            imageName = "tornado"
        default:
            imageName = "questionmark"
        }
        return Image(systemName: imageName) != nil ? imageName : "questionmark"

    }
    
    // Function to load weather data for the entered city
    func loadWeather() {
        guard !city.isEmpty else {
            errorMessage = "Please enter a city name."
            return
        }
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                weather = try await weatherManager.getWeather(forCity: city)
                city = ""
            } catch {
                errorMessage = "Could not fetch weather data. Please try again."
                print("Error fetching weather: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }
    
    // Computed property to determine if it is daytime or nighttime
    private var isDayTime: Bool {
        let currentHour = Calendar.current.component(.hour, from: Date())
        return currentHour >= 7 && currentHour < 19
    }
    
    var body: some View {
        let airTemp = kelvinToFahrenheit(weather.main.temp)
        let asphaltTemp = calculateAsphaltTemperature(airTemp: airTemp)
        let concreteTemp = calculateConcreteTemperature(airTemp: airTemp)
        
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    GeometryReader { geometry in
                        VStack {
                            HStack {
                                SearchBar(text: $city, onSearch: loadWeather)
                                Button(action: {
                                    loadWeather()
                                }) {
                                    Text("Search")
                                        .bold()
                                        .padding()
                                        .frame(maxHeight: 36)
                                        .background(Color.white)
                                        .foregroundColor(.blue)
                                        .cornerRadius(25)
                                }
                            }
                            .padding(.top, -25)
                            
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
                                
                                Spacer().frame(height: 15)
                                
                                Image(getLocalImageName(for: weather.weather[0].main))
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 300, height: 280)
                                    .cornerRadius(40)
                                    .padding(.bottom, 20)
                                
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Current Weather").bold().padding(.bottom)
                                
                                HStack {
                                    WeatherRow(logo: "thermometer", name: "Min", value: (kelvinToFahrenheit(weather.main.tempMin).roundDouble()) + "°")
                                    Spacer()
                                    WeatherRow(logo: "thermometer", name: "Max", value: (kelvinToFahrenheit(weather.main.tempMax).roundDouble()) + "°  ")
                                }
                                HStack {
                                    WeatherRow(logo: "wind", name: "Wind", value: (weather.wind.speed.roundDouble() + "m/s"))
                                    Spacer()
                                    WeatherRow(logo: "humidity.fill", name: "Humidity", value: (weather.main.humidity.roundDouble() + "%"))
                                }
                                HStack {
                                    WeatherRow(logo: "pawprint", name: "Asphalt", value: "\(asphaltTemp)°")
                                    Spacer()
                                    WeatherRow(logo: "pawprint.fill", name: "Concrete", value: "\(concreteTemp)°")
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .padding(.bottom, 20)
                            .foregroundColor(Color(hue: 0.637, saturation: 0.822, brightness: 0.456))
                            .background(.white)
                            .cornerRadius(20, corners: [.topLeft, .topRight])
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image(systemName: "pawprint.fill")
                            .foregroundColor(.white)
                        Text("WoofWeather")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button(action: {
                                        showingLoginSignup = true
                                    }) {
                                        Text("Login/Signup")
                                            .foregroundColor(.white)
                                    }
                                }
                            }
            // Present LoginSignupView when showingLoginSignup is true
            .fullScreenCover(isPresented: $showingLoginSignup) {
                LoginSignupView()
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(isDayTime ? Color.blue : Color(red: 0.0, green: 0.0, blue: 0.5))
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    WeatherView(weather: previewWeather)
}
