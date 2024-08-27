//
//  WeatherManager.swift
//  ios-app
//
//  Created by Lucy Bellott on 6/19/24.
//

import Foundation
import CoreLocation

class WeatherManager: ObservableObject {
    private let apiKey = "d38b20925679d2d417fddef4f8cb381a"
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> ResponseBody {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)")
        else {
            fatalError("Missing URL")
        }
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // Check the status code
//                if let httpResponse = response as? HTTPURLResponse {
//                    print("Status code: \(httpResponse.statusCode)")
//                }

                // Check the data
//                if let jsonString = String(data: data, encoding: .utf8) {
//                    print("Response data: \(jsonString)")
//                }

                
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }

        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
              
        return decodedData
        
    }
    
    func getWeather(forCity city: String) async throws -> ResponseBody {
            guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)")
            else {
                fatalError("Missing URL")
            }
            
            let urlRequest = URLRequest(url: url)
            
            let (data, response) = try await URLSession.shared.data(for: urlRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { fatalError("Error while fetching data") }

            let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
                  
            return decodedData
        }
}

// Model of the response body we get from calling the OpenWeather API
struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

extension ResponseBody.MainResponse {
    var feelsLike: Double { return feels_like }
    var tempMin: Double { return temp_min }
    var tempMax: Double { return temp_max }
}
