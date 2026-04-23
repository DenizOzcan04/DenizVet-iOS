import SwiftUI

struct VetAppointmentsView: View {
    @StateObject private var viewModel = VetAppointmentsViewModel()
    @State private var selectedDate = ""

    var body: some View {
        ZStack {
            vetAppointmentsBackground

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    vetAppointmentsHeader

                    if viewModel.isLoading {
                        vetLoadingCard
                    } else if let errorMessage = viewModel.errorMessage {
                        VetInfoCard(
                            title: "Randevular yüklenemedi",
                            message: errorMessage,
                            icon: "wifi.exclamationmark",
                            tint: VetTheme.warning
                        )
                    } else if appointmentsByDay.isEmpty {
                        VetInfoCard(
                            title: "Henüz randevu yok",
                            message: "Bu klinik için alınan randevular burada saat saat listelenecek.",
                            icon: "calendar.badge.exclamationmark",
                            tint: VetTheme.accent
                        )
                    } else {
                        dateSelectorSection
                        appointmentListSection
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 20)
                .padding(.bottom, 28)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await viewModel.loadAppointments()
            setInitialDateIfNeeded()
        }
        .refreshable {
            await viewModel.loadAppointments()
            setInitialDateIfNeeded()
        }
        .onChange(of: viewModel.appointments.count) { _, _ in
            setInitialDateIfNeeded()
        }
    }

    private var appointmentsByDay: [String: [ClinicAppointmentDTO]] {
        Dictionary(grouping: viewModel.appointments) { $0.date }
    }

    private var sortedDays: [String] {
        appointmentsByDay.keys.sorted()
    }

    private var selectedDayAppointments: [ClinicAppointmentDTO] {
        appointmentsByDay[selectedDate, default: []]
            .sorted { $0.time < $1.time }
    }

    private var vetAppointmentsBackground: some View {
        LinearGradient(
            colors: [VetTheme.backgroundTop, VetTheme.secondary, VetTheme.backgroundBottom],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var vetAppointmentsHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Klinik Randevuları")
                        .font(GilroyFont(isBold: true, size: 28))
                        .foregroundStyle(.white)

                    Text("Bugün ve diğer günler için alınan randevuları buradan detaylı takip edebilirsiniz.")
                        .font(GilroyFont(size: 16))
                        .foregroundStyle(VetTheme.mutedText)
                }

                Spacer()

                Image(systemName: "stethoscope.circle.fill")
                    .font(.system(size: 42))
                    .foregroundStyle(.white.opacity(0.96))
            }

            HStack(spacing: 12) {
                VetQuickStatCard(
                    title: "Toplam",
                    value: "\(viewModel.appointments.count)",
                    icon: "calendar",
                    tint: VetTheme.accent
                )

                VetQuickStatCard(
                    title: "Bugün",
                    value: "\(appointmentsByDay[todayKey, default: []].count)",
                    icon: "clock.badge.checkmark",
                    tint: VetTheme.warning
                )
            }
        }
    }

    private var dateSelectorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Günler")
                .font(GilroyFont(isBold: true, size: 20))
                .foregroundStyle(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(sortedDays, id: \.self) { day in
                        Button {
                            selectedDate = day
                        } label: {
                            VStack(spacing: 6) {
                                Text(vetDayTitle(day))
                                    .font(GilroyFont(isBold: true, size: 14))
                                Text(vetDaySubtitle(day))
                                    .font(GilroyFont(size: 12))
                            }
                            .foregroundStyle(selectedDate == day ? VetTheme.primary : .white)
                            .frame(width: 98, height: 66)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(selectedDate == day ? Color.white : Color.white.opacity(0.14))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical, 2)
            }
        }
    }

    private var appointmentListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(vetSectionTitle)
                    .font(GilroyFont(isBold: true, size: 21))
                    .foregroundStyle(.white)

                Spacer()

                Text("\(selectedDayAppointments.count) randevu")
                    .font(GilroyFont(size: 14))
                    .foregroundStyle(VetTheme.mutedText)
            }

            ForEach(selectedDayAppointments) { appointment in
                VetAppointmentCard(appointment: appointment)
            }
        }
    }

    private var vetLoadingCard: some View {
        HStack(spacing: 14) {
            ProgressView()
                .tint(.white)

            Text("Klinik randevuları yükleniyor...")
                .font(GilroyFont(size: 16))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.12))
        )
    }

    private var todayKey: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }

    private var vetSectionTitle: String {
        if selectedDate == todayKey {
            return "Bugünün Akışı"
        }
        return "\(vetDayTitle(selectedDate)) Randevuları"
    }

    private func setInitialDateIfNeeded() {
        guard !sortedDays.isEmpty else {
            selectedDate = ""
            return
        }

        if sortedDays.contains(todayKey) {
            selectedDate = todayKey
            return
        }

        if !sortedDays.contains(selectedDate), let first = sortedDays.first {
            selectedDate = first
        }
    }

    private func vetDayTitle(_ rawDate: String) -> String {
        guard let date = vetDateFormatter.date(from: rawDate) else { return rawDate }
        if Calendar.current.isDateInToday(date) {
            return "Bugün"
        }
        if Calendar.current.isDateInTomorrow(date) {
            return "Yarın"
        }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMM"
        return formatter.string(from: date)
    }

    private func vetDaySubtitle(_ rawDate: String) -> String {
        guard let date = vetDateFormatter.date(from: rawDate) else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date).capitalized
    }

    private var vetDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
}

private struct VetQuickStatCard: View {
    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(tint.opacity(0.16))
                    .frame(width: 48, height: 48)

                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(GilroyFont(isBold: true, size: 21))
                    .foregroundStyle(.white)

                Text(title)
                    .font(GilroyFont(size: 13))
                    .foregroundStyle(VetTheme.mutedText)
            }

            Spacer()
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.white.opacity(0.12))
        )
    }
}

private struct VetInfoCard: View {
    let title: String
    let message: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(tint)

            Text(title)
                .font(GilroyFont(isBold: true, size: 21))
                .foregroundStyle(Color.black.opacity(0.82))

            Text(message)
                .font(GilroyFont(size: 15))
                .foregroundStyle(Color.black.opacity(0.66))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(VetTheme.cardBackground)
        )
    }
}

private struct VetAppointmentCard: View {
    let appointment: ClinicAppointmentDTO

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(appointment.time)
                        .font(GilroyFont(isBold: true, size: 24))
                        .foregroundStyle(VetTheme.primary)

                    Text(appointment.serviceType)
                        .font(GilroyFont(size: 14))
                        .foregroundStyle(Color.black.opacity(0.62))
                }

                Spacer()

                Text(statusTitle)
                    .font(GilroyFont(isBold: true, size: 12))
                    .foregroundStyle(statusTint)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(
                        Capsule(style: .continuous)
                            .fill(statusTint.opacity(0.14))
                    )
            }

            VStack(alignment: .leading, spacing: 10) {
                vetRow(icon: "pawprint.fill", title: "Hasta", value: "\(appointment.petName) • \(appointment.petType)")
                vetRow(icon: "person.fill", title: "Sahip", value: appointment.user?.fullName ?? "Bilinmiyor")

                if let email = appointment.user?.email, !email.isEmpty {
                    vetRow(icon: "envelope.fill", title: "E-posta", value: email)
                }

                if let notes = appointment.notes, !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    vetRow(icon: "note.text", title: "Not", value: notes)
                }
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(VetTheme.cardBackground)
        )
    }

    private func vetRow(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(VetTheme.secondary)
                .frame(width: 18, height: 18)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(GilroyFont(isBold: true, size: 12))
                    .foregroundStyle(Color.black.opacity(0.44))

                Text(value)
                    .font(GilroyFont(size: 14))
                    .foregroundStyle(Color.black.opacity(0.76))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var statusTitle: String {
        switch appointment.status {
        case "completed":
            return "Tamamlandı"
        case "cancelled":
            return "İptal"
        default:
            return "Aktif"
        }
    }

    private var statusTint: Color {
        switch appointment.status {
        case "completed":
            return VetTheme.success
        case "cancelled":
            return VetTheme.danger
        default:
            return VetTheme.warning
        }
    }
}

#Preview {
    NavigationStack {
        VetAppointmentsView()
    }
}
