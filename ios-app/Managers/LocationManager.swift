

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var isLoading = false

    override init() {
        super.init()
        manager.delegate = self
        print("LocationManager initialized")
    }

    func requestLocation() {
        print("Requesting location authorization")
        manager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("Authorization status changed: \(manager.authorizationStatus.rawValue)")
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("Authorization granted, requesting location")
            isLoading = true
            manager.requestLocation()
        case .denied, .restricted:
            print("Location access denied or restricted.")
            isLoading = false
        case .notDetermined:
            print("Authorization not determined yet")
        @unknown default:
            print("Unknown authorization status")
            isLoading = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Did update locations: \(locations)")
        if let coordinate = locations.first?.coordinate {
            location = coordinate
            print("Location updated: \(coordinate)")
        } else {
            print("No location data available")
        }
        isLoading = false
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
        isLoading = false
    }
}



