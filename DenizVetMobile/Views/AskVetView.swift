import SwiftUI

struct AskVetView: View {
    @StateObject private var viewModel = AskVetViewModel()
    @State private var scrollTarget: UUID?

    private let bg = Color(red: 0.97, green: 0.95, blue: 0.89)
    private let suggestions = [
        "Kedim son iki gündür kusuyor ve iştahsız.",
        "Köpeğim çok kaşınıyor ve tüy döküyor.",
        "Kedim yemek yedikten sonra saklanıyor ve halsiz."
    ]

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 14) {
                headerCard

                chatCard

                composerCard
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            .padding(.bottom, 10)
        }
        .navigationBarTitleDisplayMode(.inline)
        .customBackButton("Veterinerime Sor")
        .onChange(of: viewModel.messages) { _, messages in
            scrollTarget = messages.last?.id
        }
    }

    private var headerCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                Circle()
                    .fill(Color.white)
                    .frame(width: 54, height: 54)
                    .overlay(
                        Image(systemName: "cross.case.fill")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundStyle(Color(.systemOrange))
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text("Veterinerime Sor AI")
                        .font(GilroyFont(isBold: true, size: 22))
                        .foregroundStyle(.black.opacity(0.82))

                    Text("Belirtiyi yaz, ben de güvenli bir ön bilgilendirme yapayım.")
                        .font(GilroyFont(size: 14))
                        .foregroundStyle(.black.opacity(0.62))
                }
            }

            Text("Bu alan veteriner muayenesinin yerine geçmez. Acil bir durum varsa doğrudan kliniğe başvur.")
                .font(GilroyFont(size: 13))
                .foregroundStyle(Color(.systemRed).opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.96))
        )
    }

    private var chatCard: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(Color.white.opacity(0.96))
            .overlay {
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 14) {
                            suggestionsView

                            ForEach(viewModel.messages) { message in
                                AskVetBubble(message: message)
                                    .id(message.id)
                            }

                            if viewModel.isLoading {
                                HStack(spacing: 10) {
                                    ProgressView()
                                        .tint(Color(.systemOrange))

                                    Text("Yanıt hazırlanıyor...")
                                        .font(GilroyFont(size: 14))
                                        .foregroundStyle(.black.opacity(0.58))
                                }
                                .padding(.horizontal, 4)
                            }

                            if let errorMessage = viewModel.errorMessage {
                                Text(errorMessage)
                                    .font(GilroyFont(size: 13))
                                    .foregroundStyle(Color(.systemRed))
                                    .padding(.horizontal, 4)
                            }
                        }
                        .padding(16)
                    }
                    .onChange(of: scrollTarget) { _, target in
                        guard let target else { return }
                        withAnimation(.easeOut(duration: 0.2)) {
                            proxy.scrollTo(target, anchor: .bottom)
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
    }

    private var suggestionsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Hazır sorular")
                .font(GilroyFont(isBold: true, size: 15))
                .foregroundStyle(.black.opacity(0.7))

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(suggestions, id: \.self) { suggestion in
                        Button {
                            Task { await viewModel.sendSuggestedPrompt(suggestion) }
                        } label: {
                            Text(suggestion)
                                .font(GilroyFont(size: 13))
                                .foregroundStyle(.black.opacity(0.72))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 10)
                                .background(
                                    Capsule(style: .continuous)
                                        .fill(Color(.systemOrange).opacity(0.12))
                                )
                        }
                        .buttonStyle(.plain)
                        .disabled(viewModel.isLoading)
                    }
                }
            }
        }
        .padding(.bottom, 2)
    }

    private var composerCard: some View {
        HStack(alignment: .bottom, spacing: 10) {
            TextField("Sorunuzu yazın...", text: $viewModel.inputText, axis: .vertical)
                .font(GilroyFont(size: 15))
                .lineLimit(1...5)
                .padding(.horizontal, 14)
                .padding(.vertical, 13)
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white)
                )

            Button {
                Task { await viewModel.sendMessage() }
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(.systemOrange))
                        .frame(width: 48, height: 48)

                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                    } else {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.plain)
            .disabled(viewModel.isLoading || viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .opacity((viewModel.isLoading || viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) ? 0.6 : 1)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(red: 0.92, green: 0.88, blue: 0.79))
        )
    }
}

private struct AskVetBubble: View {
    let message: AskVetChatMessage

    var isUser: Bool { message.role == "user" }

    var body: some View {
        HStack {
            if isUser { Spacer(minLength: 46) }

            VStack(alignment: .leading, spacing: 6) {
                Text(isUser ? "Sen" : "Veterinerime Sor AI")
                    .font(GilroyFont(isBold: true, size: 12))
                    .foregroundStyle(isUser ? .white.opacity(0.82) : .black.opacity(0.5))

                Text(message.content)
                    .font(GilroyFont(size: 15))
                    .foregroundStyle(isUser ? .white : .black.opacity(0.82))
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(isUser ? Color(.systemOrange) : Color(red: 0.95, green: 0.93, blue: 0.89))
            )

            if !isUser { Spacer(minLength: 46) }
        }
    }
}

#Preview {
    NavigationStack {
        AskVetView()
    }
}
