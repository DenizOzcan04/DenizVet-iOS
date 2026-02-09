//
//  HomeView.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 6.11.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    @State private var goToAppointment = false
    @State private var goToClinics = false
    @State private var goToAskVet = false
    @State private var goToMoreInfo = false

    private let topOffset: CGFloat = 14

    var body: some View {
        ZStack {
            BackgroundViewHome()

            ScrollView {
                VStack(spacing: 50) {
                    PageTitleView(name: homeVM.userName)

                    LearnMoreView { goToMoreInfo = true }

                    HStack(spacing: 18) {
                        HomeCard(systemImage: "calendar", title: "Randevu") {
                            goToAppointment = true
                        }
                        HomeCard(systemImage: "house", title: "Klinikler") {
                            goToClinics = true
                        }
                        HomeCard(systemImage: "sparkles", title: "Veterinerime Sor", isFeatured: true) {
                            goToAskVet = true
                        }
                    }

                    UpcomingAppointmentCard(appointment: homeVM.upcomingAppointment) { goToAppointment = true }
                }
                .padding(.horizontal, 16)
                .padding(.top, topOffset)
                .padding(.bottom, 24)
            }
        }
        .navigationDestination(isPresented: $goToAppointment) { AppointmentView() }
        .navigationDestination(isPresented: $goToClinics) { ClinicsView() }
        .navigationDestination(isPresented: $goToAskVet) { AskVetView() }
        .navigationDestination(isPresented: $goToMoreInfo) { MoreInfoView() }
        .task {
            await homeVM.loadUpcomingAppointment()
            await homeVM.loadUserName()
        }
    }
}



@ViewBuilder
func BackgroundViewHome() -> some View {
    Color(red: 0.97, green: 0.95, blue: 0.89)
        .ignoresSafeArea()
}

@ViewBuilder
func PageTitleView(name: String) -> some View {
    HStack {
        VStack(alignment: .leading) {
            Text("Tekrar hoşgeldin,")
                .font(GilroyFont(isBold: false, size: 20))
            Text((name.isEmpty ? "!" : "\(name)"))
                .font(.system(.title))
        }
        .padding(.leading, 20)

        Spacer()

        Image(systemName: "person.circle.fill")
            .font(.system(size: 50))
            .padding(.trailing, 20)
            .foregroundStyle(Color(.systemOrange))
    }
    .padding(.vertical, 14)
    .background(
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.white.opacity(0.9))
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: -5)
    )
}


@ViewBuilder
func LearnMoreView(onTapMoreInfo: @escaping () -> Void) -> some View {
    VStack(alignment: .leading) {
        Text("Sevimli Dostunuzun Sağlığı, Bizim Önceliğimiz.")
            .font(.system(.title2))
            .padding(7)

        Text("Uzman doktorlara ulaşmak artık çok kolay.")
            .font(.system(.callout))
            .padding(7)

        Button {
            onTapMoreInfo()
        } label: {
            Text("Daha Fazla Bilgi")
                .foregroundStyle(.white)
                .font(GilroyFont(isBold: true, size: 15))
                .padding(.vertical, 10)
                .padding(.horizontal, 30)
        }
        .background {
            RoundedRectangle(cornerRadius: 30)
                .fill(.black.opacity(0.8))
        }
        .padding(7)

    }
    .background {
        RoundedRectangle(cornerRadius: 30)
            .fill(.white)
            .frame(width: 370, height: 180)
    }
}


#Preview {
    HomeView()
}
