import SwiftUI

struct AccessibilitySettingsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        @Bindable var state = appState

        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [
                        Color(red: 0.07, green: 0.09, blue: 0.18),
                        Color(red: 0.04, green: 0.05, blue: 0.12)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {

                        // Header
                        VStack(spacing: 6) {
                            Image(systemName: "figure.accessibility")
                                .font(.system(size: 44, weight: .ultraLight))
                                .foregroundStyle(Color.dnaTeal)
                                .padding(.top, 12)

                            Text("Accessibility")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundStyle(.white)

                            Text("Customise your BioBridge Lab experience")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(.white.opacity(0.5))
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 8)

                        // ── Section: Vision ──────────────────────────────
                        settingsSection(title: "VISION", icon: "eye") {
                            toggleRow(
                                icon: "textformat.size.larger",
                                iconColor: .monumentLavender,
                                title: "Larger Text",
                                subtitle: "Increases font size in instructions\nand buttons throughout the app",
                                isOn: $state.largeTextEnabled
                            )
                        }

                        // ── Section: Hearing ─────────────────────────────
                        settingsSection(title: "HEARING", icon: "ear") {
                            toggleRow(
                                icon: "speaker.wave.2.fill",
                                iconColor: .dnaTeal,
                                title: "Read Aloud",
                                subtitle: "Speaks instruction text out loud\nas you progress through each module",
                                isOn: $state.readAloudEnabled
                            )

                            if appState.readAloudEnabled {
                                previewButton
                            }
                        }

                        // ── Section: VoiceOver tip ───────────────────────
                        settingsSection(title: "VOICEOVER", icon: "hand.point.up.left") {
                            infoRow(
                                icon: "checkmark.circle.fill",
                                iconColor: .successGreen,
                                title: "VoiceOver Compatible",
                                text: "All buttons, interactive elements, and drag gestures include descriptive VoiceOver labels. Enable VoiceOver in iOS Settings → Accessibility."
                            )
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color.dnaTeal)
                        .fontWeight(.semibold)
                }
            }
            .toolbarBackground(.clear, for: .navigationBar)
        }
        .preferredColorScheme(.dark)
    }

    // MARK: - Section Container

    private func settingsSection<Content: View>(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.4))
                Text(title)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.4))
                    .tracking(1.5)
            }
            .padding(.leading, 4)

            VStack(spacing: 0) {
                content()
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(Color.white.opacity(0.09), lineWidth: 1)
                    )
            )
        }
    }

    // MARK: - Toggle Row

    private func toggleRow(
        icon: String,
        iconColor: Color,
        title: String,
        subtitle: String,
        isOn: Binding<Bool>
    ) -> some View {
        HStack(spacing: 14) {
            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(iconColor.opacity(0.18))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(iconColor)
            }

            // Text
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.white.opacity(0.45))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            // Toggle
            Toggle("", isOn: isOn)
                .labelsHidden()
                .tint(iconColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(subtitle.replacingOccurrences(of: "\n", with: " "))")
    }

    // MARK: - Read Aloud Preview

    private var previewButton: some View {
        Button(action: {
            SpeechManager.shared.speak(
                "Welcome to BioBridge Lab. Read Aloud is now enabled. Instruction text will be spoken as you explore each module."
            )
        }) {
            HStack(spacing: 10) {
                Image(systemName: SpeechManager.shared.isSpeaking
                      ? "speaker.wave.3.fill"
                      : "play.circle.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.dnaTeal)
                Text(SpeechManager.shared.isSpeaking ? "Speaking…" : "Preview voice")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .accessibilityLabel("Preview Read Aloud voice")
        .accessibilityHint("Plays a sample of the text-to-speech voice")
        .overlay(
            // Top divider line
            Rectangle()
                .fill(Color.white.opacity(0.07))
                .frame(height: 1),
            alignment: .top
        )
    }

    // MARK: - Info Row

    private func infoRow(icon: String, iconColor: Color, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(iconColor.opacity(0.15))
                    .frame(width: 40, height: 40)
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(iconColor)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                Text(text)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.white.opacity(0.45))
                    .lineSpacing(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title). \(text)")
    }
}

#Preview {
    AccessibilitySettingsView()
        .environment(AppState())
}
