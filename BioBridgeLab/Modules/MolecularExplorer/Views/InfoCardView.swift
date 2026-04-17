import SwiftUI

struct InfoCardView: View {
    let stop: EducationalStop
    let onDismiss: () -> Void

    @Environment(AppState.self) private var appState
    @State private var appeared = false
    @State private var showDetail = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            HStack(spacing: 10) {
                Image(systemName: stop.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(Color.dnaTeal)
                    .frame(width: 36, height: 36)
                    .background(
                        Circle()
                            .fill(Color.dnaTeal.opacity(0.15))
                    )

                VStack(alignment: .leading, spacing: 2) {
                    Text(stop.title)
                        .font(.title3.weight(.medium))
                        .foregroundStyle(.white)
                    Text(stop.description)
                        .font(.appCaption)
                        .foregroundStyle(.white.opacity(0.6))
                }

                Spacer()

                Button(action: {
                    let text = showDetail
                        ? "\(stop.title). \(stop.description). \(stop.detail)"
                        : "\(stop.title). \(stop.description)"
                    SpeechManager.shared.speak(text)
                }) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.dnaTeal.opacity(0.8))
                }
                .accessibilityLabel("Read card aloud")
                .padding(.trailing, 4)

                Button(action: onDismiss) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(.white.opacity(0.4))
                }
            }

            // Detail text (expandable)
            if showDetail {
                Text(stop.detail)
                    .font(.appBody)
                    .foregroundStyle(.white.opacity(0.8))
                    .lineSpacing(4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }

            // Learn more / Continue button
            HStack {
                if !showDetail {
                    Button(action: {
                        withAnimation(Anim.spring) {
                            showDetail = true
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text("Learn More")
                                .font(.subheadline.weight(.medium))
                            Image(systemName: "chevron.down")
                                .font(.caption.weight(.bold))
                        }
                        .foregroundStyle(Color.dnaTeal)
                    }
                }

                Spacer()

                Button(action: {
                    HapticManager.impact(.light)
                    onDismiss()
                }) {
                    Text("Continue")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.dnaTeal)
                        )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .onAppear {
            withAnimation(Anim.infoCardSlide) {
                appeared = true
            }
            HapticManager.notification(.success)
            if appState.readAloudEnabled {
                SpeechManager.shared.speak("\(stop.title). \(stop.description)")
            }
        }
        .onChange(of: showDetail) { _, isShowing in
            if isShowing && appState.readAloudEnabled {
                SpeechManager.shared.speak(stop.detail)
            }
        }
        .onDisappear {
            SpeechManager.shared.stop()
        }
    }
}
