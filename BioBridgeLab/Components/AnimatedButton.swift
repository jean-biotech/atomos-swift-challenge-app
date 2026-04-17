import SwiftUI

struct AnimatedButton: View {
    let title: String
    var color: Color = .dnaTeal
    var textColor: Color = .white
    var glow: Bool = false
    let action: () -> Void

    @State private var isPressed = false
    @State private var glowOpacity: Double = 0.3
    @Environment(\.appFontScale) private var fontScale

    var body: some View {
        Button(action: {
            HapticManager.selection()
            withAnimation(Anim.spring) {
                isPressed = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(Anim.spring) {
                    isPressed = false
                }
                action()
            }
        }) {
            Text(title)
                .font(.system(size: 16 * fontScale, weight: .medium))
                .foregroundStyle(textColor)
                .padding(.horizontal, 32)
                .padding(.vertical, 14)
                .background(
                    Capsule()
                        .fill(color)
                        .shadow(color: glow ? color.opacity(glowOpacity) : .clear, radius: 10)
                )
        }
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .accessibilityLabel(title)
        .onAppear {
            if glow {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    glowOpacity = 0.8
                }
            }
        }
    }
}

struct SecondaryButton: View {
    let title: String
    var color: Color = .white.opacity(0.2)
    let action: () -> Void

    @Environment(\.appFontScale) private var fontScale

    var body: some View {
        Button(action: {
            HapticManager.selection()
            action()
        }) {
            Text(title)
                .font(.system(size: 16 * fontScale, weight: .regular))
                .foregroundStyle(.white.opacity(0.8))
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(color)
                        .overlay(
                            Capsule()
                                .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                        )
                )
        }
        .accessibilityLabel(title)
    }
}
