//
//
//import SwiftUI
//
//struct WeatherView: View {
//    var onLogout: (() -> Void)?
//    @State private var city: String = ""
//    @State var weather: ResponseBody?
//    @State private var isLoading: Bool = false
//    @State private var errorMessage: String?
//    @StateObject private var weatherManager = WeatherManager()
//    @State private var showingLoginSignup = false
//    @State private var isLoggedIn = false // Track logged-in state
//
//    // Function to convert Kelvin to Fahrenheit
//    func kelvinToFahrenheit(_ kelvin: Double) -> Double {
//        return (kelvin - 273.15) * 9 / 5 + 32
//    }
//
//    // Function to calculate asphalt temperature based on air temperature
//    func calculateAsphaltTemperature(airTemp: Double) -> Int {
//        return Int(airTemp * 1.2 + 20)
//    }
//
//    // Function to calculate concrete temperature based on air temperature
//    func calculateConcreteTemperature(airTemp: Double) -> Int {
//        return Int(airTemp * 1.1 + 15)
//    }
//
//    // Function to get the image URL based on the weather condition
//    func getLocalImageName(for weatherCondition: String) -> String {
//        switch weatherCondition.lowercased() {
//        case "clouds": return "clouds"
//        case "rain": return "rain"
//        case "snow": return "snow"
//        case "clear": return "sunny"
//        case "thunderstorm": return "thunder"
//        case "drizzle": return "drizzle"
//        case "mist": return "mist"
//        case "smoke": return "sauna"
//        case "haze": return "hazy"
//        case "dust": return "dust"
//        case "fog": return "fog"
//        case "sand": return "sand"
//        case "ash": return "ash"
//        case "squall": return "squall"
//        case "tornado": return "tornado"
//        default: return "sauna"
//        }
//    }
//
//    // Function to get the system icon name based on the weather condition
//    func getSystemImageName(for weatherCondition: String) -> String {
//        let imageName: String
//        switch weatherCondition.lowercased() {
//        case "clouds": imageName = "cloud"
//        case "rain": imageName = "cloud.rain"
//        case "snow": imageName = "cloud.snow"
//        case "clear": imageName = "sun.max"
//        case "thunderstorm": imageName = "cloud.bolt"
//        case "drizzle": imageName = "cloud.drizzle"
//        case "mist": imageName = "cloud.fog"
//        case "smoke": imageName = "smoke"
//        case "haze": imageName = "sun.haze"
//        case "dust", "sand", "ash": imageName = "aqi.low"
//        case "fog": imageName = "cloud.fog"
//        case "squall": imageName = "wind"
//        case "tornado": imageName = "tornado"
//        default: imageName = "questionmark"
//        }
//        return imageName
//    }
//
//    // Function to load weather data for the entered city
//    func loadWeather() {
//        guard !city.isEmpty else {
//            errorMessage = "Please enter a city name."
//            return
//        }
//        isLoading = true
//        errorMessage = nil
//
//        Task {
//            do {
//                weather = try await weatherManager.getWeather(forCity: city)
//                city = ""
//            } catch {
//                errorMessage = "Could not fetch weather data. Please try again."
//                print("Error fetching weather: \(error.localizedDescription)")
//            }
//            isLoading = false
//        }
//    }
//
//    // Computed property to determine if it is daytime or nighttime
//    private var isDayTime: Bool {
//        let currentHour = Calendar.current.component(.hour, from: Date())
//        return currentHour >= 7 && currentHour < 19
//    }
//
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                if let weather = weather {
//                    // Calculate temperatures
//                    let airTemp = kelvinToFahrenheit(weather.main.temp)
//                    let asphaltTemp = calculateAsphaltTemperature(airTemp: airTemp)
//                    let concreteTemp = calculateConcreteTemperature(airTemp: airTemp)
//
//                    VStack(alignment: .leading) {
//                        HStack {
//                            SearchBar(text: $city, onSearch: loadWeather)
//                            Button(action: loadWeather) {
//                                Text("Search")
//                                    .bold()
//                                    .padding()
//                                    .frame(maxHeight: 36)
//                                    .background(Color.white)
//                                    .foregroundColor(.blue)
//                                    .cornerRadius(25)
//                            }
//                        }
//                        .padding(.top)
//
//                        Text(weather.name)
//                            .bold()
//                            .font(.title)
//
//                        Text("\(Date().formatted(.dateTime.month().day().hour().minute()))")
//                            .fontWeight(.light)
//
//                        Spacer()
//
//                        VStack {
//                            HStack {
//                                VStack(spacing: 20) {
//                                    Image(systemName: getSystemImageName(for: weather.weather[0].main))
//                                        .font(.system(size: 50))
//                                    Text("\(weather.weather[0].main)")
//                                }
//                                .frame(width: 150, alignment: .leading)
//
//                                Spacer()
//
//                                Text("\(airTemp.roundDouble())°")
//                                    .font(.system(size: 90))
//                                    .fontWeight(.bold)
//                            }
//
//                            Spacer().frame(height: 15)
//
//                            Image(getLocalImageName(for: weather.weather[0].main))
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 300, height: 280)
//                                .cornerRadius(40)
//                                .padding(.bottom, 20)
//                        }
//                        .frame(maxWidth: .infinity)
//
//                        Spacer()
//
//                        // Additional Weather Rows
//                        VStack(alignment: .leading, spacing: 15) {
//                            Text("Current Weather").bold().padding(.bottom)
//
//                            HStack {
//                                WeatherRow(logo: "thermometer", name: "Min", value: "\(kelvinToFahrenheit(weather.main.tempMin).roundDouble())°")
//                                Spacer()
//                                WeatherRow(logo: "thermometer", name: "Max", value: "\(kelvinToFahrenheit(weather.main.tempMax).roundDouble())°")
//                            }
//                            HStack {
//                                WeatherRow(logo: "wind", name: "Wind", value: "\(weather.wind.speed.roundDouble()) m/s")
//                                Spacer()
//                                WeatherRow(logo: "humidity.fill", name: "Humidity", value: "\(weather.main.humidity.roundDouble())%")
//                            }
//                            HStack {
//                                WeatherRow(logo: "pawprint", name: "Asphalt", value: "\(asphaltTemp)°")
//                                Spacer()
//                                WeatherRow(logo: "pawprint.fill", name: "Concrete", value: "\(concreteTemp)°")
//                            }
//                        }
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding()
//                        .padding(.bottom, 20)
//                        .foregroundColor(Color(hue: 0.637, saturation: 0.822, brightness: 0.456))
//                        .background(.white)
//                        .cornerRadius(20, corners: [.topLeft, .topRight])
//                    }
//                    .padding()
//                } else {
//                    Text("No data available")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                        .padding()
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    HStack {
//                        Image(systemName: "pawprint.fill")
//                            .foregroundColor(.white)
//                        Text("WoofWeather")
//                            .font(.system(size: 20, weight: .bold))
//                            .foregroundColor(.white)
//                    }
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    if isLoggedIn {
//                        Button(action: {
//                            isLoggedIn = false // Log the user out
//                        }) {
//                            Text("Logout")
//                                .foregroundColor(.white)
//                        }
//                    } else {
//                        Button(action: { showingLoginSignup = true }) {
//                            Text("Login/Signup")
//                                .foregroundColor(.white)
//                        }
//                    }
//                }
//            }
//            .fullScreenCover(isPresented: $showingLoginSignup) {
//                LoginSignupView(onLogin: {
//                    showingLoginSignup = false // Dismiss the login view
//                    isLoggedIn = true
//                })
//            }
//            .edgesIgnoringSafeArea(.bottom)
//            .background(isDayTime ? Color.blue : Color(red: 0.0, green: 0.0, blue: 0.5))
//            .preferredColorScheme(.dark)
//        }
//    }
//}
//
//#Preview {
//    WeatherView(weather: previewWeather)
//}

import SwiftUI

struct WeatherView: View {
    var onLogout: (() -> Void)?
    @State private var city: String = ""
    @State var weather: ResponseBody?
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @StateObject private var weatherManager = WeatherManager()
    @State private var showingLoginSignup = false
    @State private var isLoggedIn = false // Track logged-in state

    // NEW: Favorites and tab tracking
    @State private var favoriteCities: [String] = []
    @State private var selectedTab: Int = 0

    // Function to convert Kelvin to Fahrenheit
    func kelvinToFahrenheit(_ kelvin: Double) -> Double {
        return (kelvin - 273.15) * 9 / 5 + 32
    }

    // Function to calculate asphalt temperature
    func calculateAsphaltTemperature(airTemp: Double) -> Int {
        return Int(airTemp * 1.2 + 20)
    }

    // Function to calculate concrete temperature
    func calculateConcreteTemperature(airTemp: Double) -> Int {
        return Int(airTemp * 1.1 + 15)
    }

    // Function to get the image URL based on the weather condition
    func getLocalImageName(for weatherCondition: String) -> String {
        switch weatherCondition.lowercased() {
        case "clouds": return "clouds"
        case "rain": return "rain"
        case "snow": return "snow"
        case "clear": return "sunny"
        case "thunderstorm": return "thunder"
        case "drizzle": return "drizzle"
        case "mist": return "mist"
        case "smoke": return "sauna"
        case "haze": return "hazy"
        case "dust": return "dust"
        case "fog": return "fog"
        case "sand": return "sand"
        case "ash": return "ash"
        case "squall": return "squall"
        case "tornado": return "tornado"
        default: return "sauna"
        }
    }

    // Function to get the system icon name based on the weather condition
    func getSystemImageName(for weatherCondition: String) -> String {
        let imageName: String
        switch weatherCondition.lowercased() {
        case "clouds": imageName = "cloud"
        case "rain": imageName = "cloud.rain"
        case "snow": imageName = "cloud.snow"
        case "clear": imageName = "sun.max"
        case "thunderstorm": imageName = "cloud.bolt"
        case "drizzle": imageName = "cloud.drizzle"
        case "mist": imageName = "cloud.fog"
        case "smoke": imageName = "smoke"
        case "haze": imageName = "sun.haze"
        case "dust", "sand", "ash": imageName = "aqi.low"
        case "fog": imageName = "cloud.fog"
        case "squall": imageName = "wind"
        case "tornado": imageName = "tornado"
        default: imageName = "questionmark"
        }
        return imageName
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

    // NEW: Add city to favorites if not already present
    func addCityToFavorites(_ city: String) {
        guard !favoriteCities.contains(city) else { return }
        favoriteCities.append(city)
    }

    // Computed property to determine if it is daytime or nighttime
    private var isDayTime: Bool {
        let currentHour = Calendar.current.component(.hour, from: Date())
        return currentHour >= 7 && currentHour < 19
    }

    var body: some View {
        // NEW: Wrap content in a TabView with two tabs
        TabView(selection: $selectedTab) {
            // Weather Tab
            NavigationView {
                ScrollView {
                    if let weather = weather {
                        // Calculate temperatures
                        let airTemp = kelvinToFahrenheit(weather.main.temp)
                        let asphaltTemp = calculateAsphaltTemperature(airTemp: airTemp)
                        let concreteTemp = calculateConcreteTemperature(airTemp: airTemp)

                        VStack(alignment: .leading) {
                            HStack {
                                SearchBar(text: $city, onSearch: loadWeather)
                                Button(action: loadWeather) {
                                    Text("Search")
                                        .bold()
                                        .padding()
                                        .frame(maxHeight: 36)
                                        .background(Color.white)
                                        .foregroundColor(.blue)
                                        .cornerRadius(25)
                                }
                            }
                            .padding(.top)

                            // City Name + Heart button if logged in
                            HStack {
                                Text(weather.name)
                                    .bold()
                                    .font(.title)

                                if isLoggedIn { // NEW: Only show heart if logged in
                                    Button(action: {
                                        addCityToFavorites(weather.name)
                                    }) {
                                        Image(systemName: favoriteCities.contains(weather.name) ? "heart.fill" : "heart")
                                            .foregroundColor(favoriteCities.contains(weather.name) ? .red : .white)
                                    }
                                }
                            }

                            Text("\(Date().formatted(.dateTime.month().day().hour().minute()))")
                                .fontWeight(.light)

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

                                    Text("\(airTemp.roundDouble())°")
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
                            }
                            .frame(maxWidth: .infinity)

                            Spacer()

                            // Additional Weather Rows
                            VStack(alignment: .leading, spacing: 15) {
                                Text("Current Weather").bold().padding(.bottom)

                                HStack {
                                    WeatherRow(logo: "thermometer", name: "Min", value: "\(kelvinToFahrenheit(weather.main.tempMin).roundDouble())°")
                                    Spacer()
                                    WeatherRow(logo: "thermometer", name: "Max", value: "\(kelvinToFahrenheit(weather.main.tempMax).roundDouble())°")
                                }
                                HStack {
                                    WeatherRow(logo: "wind", name: "Wind", value: "\(weather.wind.speed.roundDouble()) m/s")
                                    Spacer()
                                    WeatherRow(logo: "humidity.fill", name: "Humidity", value: "\(weather.main.humidity.roundDouble())%")
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
                    } else if isLoading {
                        ProgressView().padding()
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        Text("No data available")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding()
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
                        if isLoggedIn {
                            Button(action: {
                                isLoggedIn = false // Log user out
                                selectedTab = 0
                                onLogout?()
                            }) {
                                Text("Logout")
                                    .foregroundColor(.white)
                            }
                        } else {
                            Button(action: { showingLoginSignup = true }) {
                                Text("Login/Signup")
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
                .fullScreenCover(isPresented: $showingLoginSignup) {
                    LoginSignupView(onLogin: {
                        showingLoginSignup = false
                        isLoggedIn = true
                    })
                }
                .edgesIgnoringSafeArea(.bottom)
                .background(isDayTime ? Color.blue : Color(red: 0.0, green: 0.0, blue: 0.5))
                .preferredColorScheme(.dark)
            }
            .tabItem {
                Label("Weather", systemImage: "cloud.sun")
            }
            .tag(0)

            // Favorites Tab (Define FavoriteCitiesView in a separate file)
            FavoriteCitiesView(
                favoriteCities: $favoriteCities,
                onSelectCity: { selectedCity in
                    city = selectedCity
                    selectedTab = 0
                    loadWeather()
                }
            )
            .tabItem {
                Label("Favorites", systemImage: "heart")
            }
            .tag(1)
        }
    }
}

#Preview {
    WeatherView(weather: previewWeather)
}
