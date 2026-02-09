import SwiftUI

struct MyAppointmentsView: View {
    @StateObject private var vm = AppointmentsViewModel()
    
    private let background = Color(red: 0.97, green: 0.95, blue: 0.89)
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                    .ignoresSafeArea()
                
                if vm.isLoading {
                    ProgressView("Randevular yükleniyor...")
                } else if let error = vm.errorMessage {
                    VStack(spacing: 12) {
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        Button("Tekrar dene") {
                            Task { await vm.loadAppointments() }
                        }
                        .padding(.top, 4)
                    }
                    .padding()
                } else if vm.appointments.isEmpty {
                    VStack(spacing: 8) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 40))
                            .foregroundColor(.secondary)
                        
                        Text("Henüz randevunuz yok.")
                            .font(.system(size: 18, weight: .semibold))
                        
                        Text("Randevu alarak sevimli dostunuz için uygun zamanı planlayabilirsiniz.")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            
                            VStack(alignment: .leading, spacing: 4) {
                                
                                Text("Geçmiş ve yaklaşan tüm randevularınız")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)

                            LazyVStack(spacing: 16) {
                                ForEach(vm.appointments) { appointment in
                                    AppointmentCardView(
                                        appointment: appointment,
                                        onDelete: {
                                            Task {
                                                await vm.deleteAppointment(appointment)
                                            }
                                        }
                                    )
                                    .padding(.horizontal, 16)
                                }
                            }

                            .padding(.bottom, 24)
                        }
                    }
                    .refreshable {
                        await vm.refresh()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .customBackButton("Randevularım")
            .task {
                await vm.loadAppointments()
            }
        }
    }
}

#Preview {
    MyAppointmentsView()
}
