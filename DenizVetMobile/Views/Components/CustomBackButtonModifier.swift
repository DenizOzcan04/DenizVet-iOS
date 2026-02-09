import SwiftUI

struct CustomBackButton: ViewModifier {
    @Environment(\.dismiss) private var dismiss
    let title: String?

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .tint(.black)
                    }
                }

                if let t = title {
                    ToolbarItem(placement: .principal) {
                        Text(t)
                            .font(.system(size: 17, weight: .semibold))
                    }
                }
            }
    }
}

extension View {
    func customBackButton(_ title: String? = nil) -> some View {
        modifier(CustomBackButton(title: title))
    }
}

