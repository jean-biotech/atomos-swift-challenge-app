import SwiftUI

struct AccessibilityWelcomeSheet: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var state = appState

        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.07, green: 0.09, blue: 0.18),
                    Color(red: 0.04, green: 0.05, blue: 0.12)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                VStack(spacing: 10) {
                    Image(systemName: "figure.accessibility")
                        .font(.system(size: 52, weight: .ultraLight))
                        .foregroundStyle(Color.dnaTeal)
                        .padding(.top, 36)

                    Text("Make it yours")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Set up accessibility options\nbefore you start exploring.")
                        .font(.system(size: 15))
                        .foregroundStyle(.white.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .lineSpacing(3)
                }
                .padding(.bottom, 32)

                // Options
                VStack(spacing: 10) {
                    optionRow(
                        icon: "textformat.size.larger",
                        iconColor: .monumentLavender,
                        title: "Larger Text",
                        subtitle: "Bigger font in instructions and buttons",
                        isOn: $state.largeTextEnabled
                    )

                    optionRow(
                        icon: "speaker.wave.2.fill",
                        iconColor: .dnaTeal,
                        title: "Read Aloud",
                        subtitle: "Speaks instructions as you progress",
                        isOn: $state.readAloudEnabled
                    )

                    // VoiceOver info row
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.successGreen.opacity(0.18))
                                .frame(width: 40, height: 40)
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 18))
                                .foregroundStyle(Color.successGreen)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text("VoiceOver Ready")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.white)
                            Text("Enable in iOS Settings → Accessibility")
                                .font(.system(size: 12))
                                .foregroundStyle(.white.opacity(0.45))
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(rowBackground)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("VoiceOver Ready. Enable in iOS Settings, Accessibility.")
                }
                .padding(.horizontal, 20)

                Spacer()

                // CTA
                Button(action: {
                    appState.hasSeenAccessibilityPrompt = true
                    dismiss()
                }) {
                    Text("Get Started")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color.dnaTeal)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
                .accessibilityLabel("Get Started")
                .accessibilityHint("Dismiss and begin using BioBridge Lab")
            }
        }
        .preferredColorScheme(.dark)
    }

    private var rowBackground: some View {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(Color.white.opacity(0.06))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(Color.white.opacity(0.09), lineWidth: 1)
            )
    }

    private func optionRow(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(iconColor.opacity(0.18))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(iconColor)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.45))
            }
            Spacer()
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(iconColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(rowBackground)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(subtitle).")
    }
}

#Preview {
    AccessibilityWelcomeSheet()
        .environment(AppState())
}
