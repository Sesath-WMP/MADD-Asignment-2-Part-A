import SwiftUI
import UIKit

// MARK: - FloatingActionButton
struct FloatingActionButton: View {
    let systemImage: String
    let action: () -> Void
    @State private var show = false

    var body: some View {
        Button(action: tap) {
            Image(systemName: systemImage)
                .font(.title2.weight(.bold))
                .foregroundStyle(.white)
                .padding(16)
                .background(
                    Circle()
                        .fill(Color.accentColor)
                        .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 6)
                )
        }
        .accessibilityLabel("Primary action")
        .scaleEffect(show ? 1.0 : 0.6)
        .opacity(show ? 1.0 : 0.0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                show = true
            }
        }
    }

    private func tap() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        action()
    }
}
