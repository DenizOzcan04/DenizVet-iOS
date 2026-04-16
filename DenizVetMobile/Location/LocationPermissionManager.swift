import Foundation
import CoreLocation

@MainActor
final class LocationPermissionManager: NSObject, ObservableObject {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var currentLocation: CLLocation?
    @Published var locationErrorMessage: String?

    private let manager = CLLocationManager()

    override init() {
        self.authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }

    var isAuthorized: Bool {
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
    }

    func requestWhenInUseAuthorization() {
        locationErrorMessage = nil
        manager.requestWhenInUseAuthorization()
    }

    func refreshLocation() {
        locationErrorMessage = nil

        if isAuthorized {
            manager.requestLocation()
        } else if authorizationStatus == .notDetermined {
            requestWhenInUseAuthorization()
        } else {
            locationErrorMessage = "Konum izni kapalı. Yol tarifi için Ayarlar'dan konum erişimine izin verin."
        }
    }
}

extension LocationPermissionManager: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationStatus = manager.authorizationStatus
            if isAuthorized {
                manager.requestLocation()
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            currentLocation = locations.first
            locationErrorMessage = nil
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            locationErrorMessage = "Mevcut konum alınamadı. Lütfen tekrar deneyin."
        }
    }
}
