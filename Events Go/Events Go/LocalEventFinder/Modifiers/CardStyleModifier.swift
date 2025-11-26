import SwiftUI

// MARK: - CardStyleModifier (reusable)
struct CardStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
            )
    }
}
