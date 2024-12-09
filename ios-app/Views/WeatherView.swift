
import SwiftUI

struct WeatherView: View {
    var onLogout: (() -> Void)?
    @State private var city: String = ""
    @State var weather: ResponseBody?
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    @StateObject private var weatherManager = WeatherManager()
    @State private var showingLoginSignup = false
    @State private var isLoggedIn = false

    // Favorites and tab tracking
    @State private var favoriteCities: [String] = []
    @State private var selectedTab: Int = 0

    // Store the user's email after login
    @State private var userEmail: String?

    // Replace with actual logic or coordinates for current location
    let currentLatitude = 40.7128
    let currentLongitude = -74.0060

    // Convert Kelvin to Fahrenheit
    func kelvinToFahrenheit(_ kelvin: Double) -> Double {
        return (kelvin - 273.15) * 9 / 5 + 32
    }

    // Calculate asphalt temperature
    func calculateAsphaltTemperature(airTemp: Double) -> Int {
        return Int(airTemp * 1.2 + 20)
    }

    // Calculate concrete temperature
    func calculateConcreteTemperature(airTemp: Double) -> Int {
        return Int(airTemp * 1.1 + 15)
    }

    // Get local image name for weather condition
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

    // Get system icon name for weather condition
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

    // Load weather by city
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

    // Fetch favorites from backend
    func fetchFavorites() {
        guard isLoggedIn, let email = userEmail else { return }
        guard let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "http://127.0.0.1:8080/favorites?email=\(encodedEmail)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching favorites: \(error.localizedDescription)")
                    return
                }
                guard let data = data else { return }
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if let favoritesResponse = try? JSONDecoder().decode([FavoriteCityResponse].self, from: data) {
                        self.favoriteCities = favoritesResponse.map { $0.cityName }
                    } else {
                        print("Failed to decode favorites.")
                    }
                } else {
                    print("Failed to fetch favorites. Check response code.")
                }
            }
        }.resume()
    }

    struct FavoriteCityResponse: Decodable {
        let id: UUID
        let cityName: String
        let userID: UUID
    }

    // Add city to favorites and persist to backend
    func addCityToFavorites(_ city: String) {
        guard !favoriteCities.contains(city) else { return }
        favoriteCities.append(city)

        guard isLoggedIn, let email = userEmail else {
            // If user is not logged in, optionally show an alert or handle accordingly
            print("User not logged in. Favorites are not persisted to backend.")
            return
        }

        guard let url = URL(string: "http://127.0.0.1:8080/favorites") else { return }
        let data = ["cityName": city, "email": email]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: data) else {
            print("Failed to encode favorite data.")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error adding favorite: \(error.localizedDescription)")
                    return
                }
                if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    print("Favorite city added successfully.")
                    // Optionally, fetch updated favorites
                    fetchFavorites()
                } else {
                    print("Failed to add favorite. Check server response.")
                }
            }
        }.resume()
    }

    // After logout, load weather for current location
    func loadWeatherForCurrentLocation() {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                weather = try await weatherManager.getCurrentWeather(latitude: currentLatitude, longitude: currentLongitude)
            } catch {
                errorMessage = "Could not fetch weather for current location."
                print("Error fetching location-based weather: \(error.localizedDescription)")
            }
            isLoading = false
        }
    }

    // Determine daytime or nighttime
    private var isDayTime: Bool {
        let currentHour = Calendar.current.component(.hour, from: Date())
        return currentHour >= 7 && currentHour < 19
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Weather tab
            NavigationView {
                ScrollView {
                    if isLoading {
                        ProgressView().padding()
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else if let weather = weather {
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

                            HStack {
                                Text(weather.name)
                                    .bold()
                                    .font(.title)

                                if isLoggedIn {
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
                                isLoggedIn = false
                                userEmail = nil // Clear user email on logout
                                selectedTab = 0
                                loadWeatherForCurrentLocation()
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
                    // After login, receive email and handle it
                    LoginSignupView(onLogin: { email in
                        showingLoginSignup = false
                        isLoggedIn = true
                        userEmail = email // Store the user's email
                        fetchFavorites()    
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
            .onChange(of: selectedTab) { newValue in
                // When user goes to favorites tab, fetch again if logged in
                if newValue == 1 && isLoggedIn && userEmail != nil {
                    fetchFavorites()
                }
            }

            // Favorites Tab
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
