//
//  DenizVetMobileApp.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 14.10.2025.
//

import SwiftUI

@main
struct DenizVetMobileApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("accountRole") private var accountRole: String = "user"
    @AppStorage("authToken") private var authToken: String = ""
    @AppStorage("persistSession") private var persistSession: Bool = false
    init() {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
            appearance.backgroundColor = UIColor.white.withAlphaComponent(0.4)
        
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isLoggedIn && !authToken.isEmpty {
                    if accountRole == "vet" {
                        VetClinicPlaceholderView()
                    } else {
                        MainTabView()
                    }
                } else {
                    LoginView()
                }
            }
            .onAppear {
                if !persistSession {
                    isLoggedIn = false
                    authToken = ""
                    accountRole = "user"
                    UserDefaults.standard.removeObject(forKey: "authToken")
                    UserDefaults.standard.removeObject(forKey: "currentUser")
                } else if authToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    isLoggedIn = false
                    accountRole = "user"
                }
            }
        }
    }
}
