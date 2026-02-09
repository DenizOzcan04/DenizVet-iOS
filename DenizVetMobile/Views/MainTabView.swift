import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
                    .withGlobalTopBar(height: 40)
            }
            .tabItem {
                Label("Anasayfa", systemImage: "house")
            }

            NavigationStack {
                AppointmentView()
                    .withGlobalTopBar(height: 40)
            }
            .tabItem {
                Label("Randevu Al", systemImage: "calendar.badge.clock")
            }

            NavigationStack {
                BlogView()
                    .withGlobalTopBar(height: 40)
            }
            .tabItem {
                Label("Blog", systemImage: "book.pages")
            }

            NavigationStack {
                ProfileView()
                    .withGlobalTopBar(height: 40)
            }
            .tabItem {
                Label("Profil", systemImage: "person")
            }
        }
    }
}

#Preview {
    MainTabView()
}
