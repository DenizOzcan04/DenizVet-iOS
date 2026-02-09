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
                if isLoggedIn {
                    MainTabView()
                } else {
                    LoginView()
                }
            }
        }
    }
}
