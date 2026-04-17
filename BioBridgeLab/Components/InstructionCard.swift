import SwiftUI

struct InstructionCard: View {
    let text: String
    var icon: String? = nil
    var maxWidth: CGFloat = 320

    @State private var appeared = false
    @Environment(\.appFontScale) private var fontScale
    @Environment(AppState.self) private var appState

    var body: some View {
        HStack(spacing: 10) {
            if let icon {
                Image(systemName: icon)
                    .font(.system(size: 16 * fontScale, weight: .regular))
                    .foregroundStyle(.white.opacity(0.8))
            }
            Text(text)
                .font(.system(size: 16 * fontScale, weight: .regular))
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .frame(maxWidth: maxWidth)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 10)
        .accessibilityLabel(text)
        .onAppear {
            withAnimation(Anim.standard.delay(0.3)) {
                appeared = true
            }
            if appState.readAloudEnabled {
                SpeechManager.shared.speak(text)
            }
        }
    }
}

struct InstructionBanner: View {
    let text: String

    @Environment(\.appFontScale) private var fontScale
    @Environment(AppState.self) private var appState

    var body: some View {
        Text(text)
            .font(.system(size: 14 * fontScale, weight: .light))
            .foregroundStyle(.white.opacity(0.9))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.4))
            )
            .accessibilityLabel(text)
            .onAppear {
                if appState.readAloudEnabled {
                    SpeechManager.shared.speak(text)
                }
            }
            .onChange(of: text) { _, newText in
                if appState.readAloudEnabled {
                    SpeechManager.shared.speak(newText)
                }
            }
    }
}
