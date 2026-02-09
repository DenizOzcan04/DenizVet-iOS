import SwiftUI
import MapKit

struct ClinicMapView: View {
    let clinic: ClinicDTO

    @Environment(\.dismiss) private var dismiss
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {

                ZStack(alignment: .bottomTrailing) {
                    if let coord = clinic.coordinate {
                        Map(position: $position) {
                            Marker(clinic.name, coordinate: coord)
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

                Spacer(minLength: 10)
            }
            .navigationTitle("Konum")
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
        }
    }
}


