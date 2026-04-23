import SwiftUI

struct VetClinicTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                VetAppointmentsView()
            }
            .tabItem {
                Label("Randevular", systemImage: "calendar.badge.clock")
            }

            NavigationStack {
                VetSettingsView()
            }
            .tabItem {
                Label("Ayarlar", systemImage: "gearshape")
            }
        }
        .tint(VetTheme.primary)
    }
}

#Preview {
    VetClinicTabView()
}
