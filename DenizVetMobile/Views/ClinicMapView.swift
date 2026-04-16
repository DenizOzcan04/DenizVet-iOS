import SwiftUI
import MapKit
import CoreLocation

struct ClinicMapView: View {
    let clinic: ClinicDTO

    @Environment(\.dismiss) private var dismiss
    @State private var position: MapCameraPosition = .automatic
    @StateObject private var locationManager = LocationPermissionManager()
    @State private var route: MKRoute?
    @State private var routeErrorMessage: String?
    @State private var isCalculatingRoute = false
    @State private var shouldCalculateRouteAfterLocationUpdate = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                ZStack(alignment: .bottomTrailing) {
                    if let coord = clinic.coordinate {
                        Map(position: $position) {
                            if locationManager.currentLocation != nil {
                                UserAnnotation()
                            }
                            Marker(clinic.name, coordinate: coord)

                            if let route {
                                MapPolyline(route.polyline)
                                    .stroke(Color(.systemBlue), lineWidth: 6)
                            }
                        }
                        .onAppear {
                            position = .region(
                                MKCoordinateRegion(
                                    center: coord,
                                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                                )
                            )
                        }
                        .frame(maxHeight: .infinity)
                    } else {
                        Text("Bu klinik için konum bilgisi bulunamadı.")
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white.opacity(0.6))
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.66)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.horizontal, 12)
                .padding(.top, 10)

                VStack(alignment: .leading, spacing: 6) {
                    Text(clinic.name)
                        .font(.system(size: 18, weight: .semibold))

                    Text("\(clinic.address) • \(clinic.city)")
                        .font(.system(size: 13))
                        .foregroundStyle(.secondary)

                    if let route {
                        Text(routeSummary(route))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(Color(.systemBlue))
                            .fixedSize(horizontal: false, vertical: true)
                    } else if let routeErrorMessage {
                        Text(routeErrorMessage)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.red)
                            .fixedSize(horizontal: false, vertical: true)
                    } else if let locationError = locationManager.locationErrorMessage {
                        Text(locationError)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.red)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal, 16)
                .padding(.top, 6)

                HStack(spacing: 12) {
                    Button {
                        Task { await handleDirectionsTap() }
                    } label: {
                        HStack(spacing: 8) {
                            if isCalculatingRoute {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "location.fill")
                            }

                            Text(isCalculatingRoute ? "Rota Hazırlanıyor" : "Yol Tarifi")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(.systemBlue))
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(!clinic.hasLocation || isCalculatingRoute)
                    .opacity((clinic.hasLocation && !isCalculatingRoute) ? 1 : 0.6)

                    Button {
                        openInMaps()
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "map")
                            Text("Haritalar")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(!clinic.hasLocation)
                    .opacity(clinic.hasLocation ? 1 : 0.6)
                }
                .padding(.horizontal, 16)

                Spacer(minLength: 10)
            }
            .navigationTitle("Konum").padding(.bottom, 5)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.black)
                    }
                }
            }
            .onChange(of: locationManager.currentLocation) { _, _ in
                guard shouldCalculateRouteAfterLocationUpdate else { return }
                Task { await calculateRouteIfPossible() }
            }
        }
    }

    private func handleDirectionsTap() async {
        routeErrorMessage = nil
        shouldCalculateRouteAfterLocationUpdate = true

        if locationManager.isAuthorized {
            if locationManager.currentLocation == nil {
                isCalculatingRoute = true
                locationManager.refreshLocation()
            } else {
                await calculateRouteIfPossible()
            }
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    private func calculateRouteIfPossible() async {
        guard let clinicCoordinate = clinic.coordinate else { return }
        guard let currentLocation = locationManager.currentLocation else {
            isCalculatingRoute = false
            return
        }

        isCalculatingRoute = true
        routeErrorMessage = nil

        if currentLocation.coordinate.latitude == 0 && currentLocation.coordinate.longitude == 0 {
            route = nil
            shouldCalculateRouteAfterLocationUpdate = false
            routeErrorMessage = "Mevcut konum alınamadı. Simülatörde bir konum seçip tekrar deneyin."
            isCalculatingRoute = false
            return
        }

        let transportTypes: [MKDirectionsTransportType] = [.automobile, .walking]
        var resolvedRoute: MKRoute?

        for transportType in transportTypes {
            do {
                if let calculatedRoute = try await calculateRoute(
                    from: currentLocation.coordinate,
                    to: clinicCoordinate,
                    transportType: transportType
                ) {
                    resolvedRoute = calculatedRoute
                    break
                }
            } catch {
                continue
            }
        }

        if let resolvedRoute {
            route = resolvedRoute
            updateCamera(for: resolvedRoute, userCoordinate: currentLocation.coordinate, clinicCoordinate: clinicCoordinate)
        } else {
            route = nil
            routeErrorMessage = "Uygulama içinde rota oluşturulamadı. Alttaki Haritalar butonuyla Apple Haritalar'da yol tarifini acabilirsiniz."
        }

        shouldCalculateRouteAfterLocationUpdate = false
        isCalculatingRoute = false
    }

    private func calculateRoute(
        from source: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D,
        transportType: MKDirectionsTransportType
    ) async throws -> MKRoute? {
        let request = MKDirections.Request()
        request.source = MKMapItem(
            placemark: MKPlacemark(coordinate: source)
        )
        request.destination = MKMapItem(
            placemark: MKPlacemark(coordinate: destination)
        )
        request.transportType = transportType

        let response = try await MKDirections(request: request).calculate()
        return response.routes.first
    }

    private func updateCamera(for route: MKRoute, userCoordinate: CLLocationCoordinate2D, clinicCoordinate: CLLocationCoordinate2D) {
        let userPoint = MKMapPoint(userCoordinate)
        let clinicPoint = MKMapPoint(clinicCoordinate)
        let points = [userPoint, clinicPoint]

        var mapRect = route.polyline.boundingMapRect
        for point in points {
            let pointRect = MKMapRect(x: point.x, y: point.y, width: 0, height: 0)
            mapRect = mapRect.union(pointRect)
        }

        position = .rect(mapRect.insetBy(dx: -400, dy: -400))
    }

    private func routeSummary(_ route: MKRoute) -> String {
        let distanceKm = route.distance / 1000
        let expectedMinutes = Int(round(route.expectedTravelTime / 60))
        return String(format: "Tahmini %.1f km • %d dk", distanceKm, expectedMinutes)
    }

    private func openInMaps() {
        guard let coordinate = clinic.coordinate else { return }

        let destination = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
        destination.name = clinic.name
        destination.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
        ])
    }
}
