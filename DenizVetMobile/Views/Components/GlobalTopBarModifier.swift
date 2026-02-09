import SwiftUI

struct GlobalTopBarModifier: ViewModifier {
    var barHeight: CGFloat = 44

    private let contentBg = Color(red: 0.97, green: 0.95, blue: 0.89)

    func body(content: Content) -> some View {
        content
            .padding(.top, 15)
            .background(contentBg.ignoresSafeArea())
            .safeAreaInset(edge: .top, spacing: 0) {
                GlobalTopBar()
                    .frame(height: barHeight)
                    .frame(maxWidth: .infinity)
            }
    }
}

extension View {
    func withGlobalTopBar(height: CGFloat = 44) -> some View {
        self.modifier(GlobalTopBarModifier(barHeight: height))
    }
}

