import SwiftUI

struct LabHubView: View {
    @Environment(AppState.self) private var appState

    @State private var appeared = false
    @State private var showInfoSheet = false
    @State private var showAccessibilitySheet = false
    @State private var showAccessibilityWelcome = false
    @State private var floatOffset: CGFloat = 0

    var body: some View {
        ZStack {
            LabBackground()

            // Floating decorative particles
            floatingParticles

            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    // Top Bar
                    topBar
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    // Welcome section
                    welcomeSection
                        .padding(.horizontal, 24)

                    // 3D Explorer card
                    NavigationLink(destination: ExplorerHomeView()) {
                        moduleCard(
                            title: "3D Explorer",
                            subtitle: "Molecules in 3D",
                            hook: "See the molecules of life up close",
                            icon: { AnyView(explorerIcon) },
                            isCompleted: !appState.completedMolecules.isEmpty,
                            accentColor: .monumentLavender
                        )
                    }
                    .accessibilityLabel("3D Explorer. Molecules in 3D. See the molecules of life up close.\(!appState.completedMolecules.isEmpty ? " Completed." : "")")
                    .padding(.horizontal, 20)

                    // Lab Notes card (full width)
                    NavigationLink(destination: LabProgressView()) {
                        labNotesCard
                    }
                    .accessibilityLabel("Lab Notes. Review your experiments and what you learned.")
                    .padding(.horizontal, 20)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)

                    Spacer(minLength: 40)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showInfoSheet) {
            infoSheet
        }
        .sheet(isPresented: $showAccessibilitySheet) {
            AccessibilitySettingsView()
                .environment(appState)
        }
        .sheet(isPresented: $showAccessibilityWelcome) {
            AccessibilityWelcomeSheet()
                .environment(appState)
        }
        .onAppear {
            if !appState.hasSeenAccessibilityPrompt {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    showAccessibilityWelcome = true
                }
            }
            withAnimation(Anim.standard.delay(0.1)) {
                appeared = true
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                floatOffset = -8
            }
        }
    }

    // MARK: - Floating Decorative Particles
    private var floatingParticles: some View {
        GeometryReader { geo in
            ForEach(0..<6, id: \.self) { i in
                let positions: [(x: CGFloat, y: CGFloat)] = [
                    (0.1, 0.15), (0.85, 0.25), (0.2, 0.45),
                    (0.9, 0.55), (0.15, 0.7), (0.8, 0.8)
                ]
                let sizes: [CGFloat] = [6, 8, 5, 7, 4, 6]
                let colors: [Color] = [.dnaTeal, .dnaPink, .proteinGold, .rnaColor, .dnaTeal, .monumentLavender]

                Circle()
                    .fill(colors[i].opacity(0.2))
                    .frame(width: sizes[i], height: sizes[i])
                    .position(
                        x: geo.size.width * positions[i].x,
                        y: geo.size.height * positions[i].y + floatOffset * (i % 2 == 0 ? 1 : -1)
                    )
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    // MARK: - Top Bar
    private var topBar: some View {
        HStack {
            // Lab icon
            Circle()
                .fill(Color.primaryGradientEnd.opacity(0.2))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "flask.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.primaryGradientEnd)
                )

            Spacer()

            // Accessibility settings button
            Button(action: { showAccessibilitySheet = true }) {
                HStack(spacing: 5) {
                    Image(systemName: "figure.accessibility")
                        .font(.system(size: 15, weight: .medium))
                    Text("Accessibility")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(Color.dnaTeal)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.dnaTeal.opacity(0.12))
                )
            }
            .accessibilityLabel("Accessibility settings")
            .padding(.trailing, 4)

            // Info button
            Button(action: { showInfoSheet = true }) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 20))
                    .foregroundStyle(.secondary)
            }
            .accessibilityLabel("About BioBridge Lab")
            .padding(.trailing, 8)

            // Progress pill
            HStack(spacing: 6) {
                Text("\(appState.completedCount)/\(appState.totalModules)")
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text("Complete")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 7)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
            )
        }
    }

    // MARK: - Welcome Section
    private var welcomeSection: some View {
        VStack(spacing: 8) {
            Text("Welcome, future scientist!")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.primaryGradientEnd, .dnaTeal],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Text("Explore the 3D structures of DNA, proteins, and the molecules that make life possible.")
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .padding(.vertical, 4)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 10)
    }

    // MARK: - Module Card
    private func moduleCard(
        title: String,
        subtitle: String,
        hook: String,
        icon: () -> AnyView,
        isCompleted: Bool,
        accentColor: Color
    ) -> some View {
        VStack(spacing: 10) {
            // Icon area with accent tint
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [accentColor.opacity(0.12), accentColor.opacity(0.04)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 85)

                icon()

                // Completion badge
                if isCompleted {
                    VStack {
                        HStack {
                            Spacer()
                            Circle()
                                .fill(Color.successGreen)
                                .frame(width: 22, height: 22)
                                .overlay(
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(.white)
                                )
                                .shadow(color: .successGreen.opacity(0.4), radius: 4)
                                .offset(x: -6, y: 6)
                        }
                        Spacer()
                    }
                }
            }

            // Text
            VStack(spacing: 3) {
                Text(title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.2))
                    .lineLimit(1)

                Text(subtitle)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(accentColor)
                    .lineLimit(1)

                Text(hook)
                    .font(.system(size: 10, weight: .regular))
                    .foregroundStyle(Color(red: 0.4, green: 0.4, blue: 0.45))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .frame(height: 26)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.white)
                .shadow(color: accentColor.opacity(0.08), radius: 12, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [accentColor.opacity(0.2), accentColor.opacity(0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1
                )
        )
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
    }

    // MARK: - Icons

    private var explorerIcon: some View {
        ZStack {
            Image(systemName: "cube.transparent")
                .font(.system(size: 32))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.monumentLavender, Color.dnaTeal],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(systemName: "hurricane")
                .font(.system(size: 8))
                .foregroundStyle(Color.dnaPink.opacity(0.6))
                .offset(x: 14, y: 12)
        }
    }

    // MARK: - Lab Notes Card
    private var labNotesCard: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(red: 0.95, green: 0.93, blue: 0.88))
                    .frame(width: 44, height: 52)
                    .overlay(
                        VStack(spacing: 3) {
                            ForEach(0..<4, id: \.self) { _ in
                                RoundedRectangle(cornerRadius: 0.5)
                                    .fill(Color.gray.opacity(0.15))
                                    .frame(height: 1)
                                    .padding(.horizontal, 6)
                            }
                        }
                    )

                Rectangle()
                    .fill(appState.completedCount > 0 ? Color.successGreen : Color.warningRed.opacity(0.5))
                    .frame(width: 6, height: 14)
                    .offset(x: 14, y: -26)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text("Lab Notes")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color(red: 0.15, green: 0.15, blue: 0.2))

                Text("Review your experiments and what you learned")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color(red: 0.4, green: 0.4, blue: 0.45))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Color(red: 0.6, green: 0.6, blue: 0.65))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
                .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 4)
        )
    }

    // MARK: - Info Sheet
    private var infoSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What is BioBridge Lab?")
                            .font(.system(size: 22, weight: .bold))
                        Text("BioBridge Lab is an interactive journey through molecular biology. Explore real 3D molecular structures — from DNA and proteins to the molecules that power every living cell.")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .lineSpacing(2)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 14) {
                        Text("Your Experiments")
                            .font(.system(size: 18, weight: .semibold))

                        infoRow(icon: "cube.transparent", color: .monumentLavender, title: "3D Explorer",
                                text: "Explore the 3D structures of DNA, proteins, and other molecules that make up every living thing.")
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Who is this for?")
                            .font(.system(size: 18, weight: .semibold))
                        Text("Anyone curious about biology! Whether you're a student, a science enthusiast, or just wondering how life works at the molecular level — these experiments are designed to make complex biology feel hands-on and fun.")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .lineSpacing(2)
                    }
                }
                .padding(24)
            }
            .navigationTitle("About")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { showInfoSheet = false }
                }
            }
        }
    }

    private func infoRow(icon: String, color: Color, title: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(color)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                Text(text)
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
                    .lineSpacing(1.5)
            }
        }
    }
}

struct TrapezoidShape: InsettableShape {
    var insetAmount: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let inset = insetAmount
        path.move(to: CGPoint(x: rect.minX + rect.width * 0.15 + inset, y: rect.minY + inset))
        path.addLine(to: CGPoint(x: rect.maxX - rect.width * 0.15 - inset, y: rect.minY + inset))
        path.addLine(to: CGPoint(x: rect.maxX - inset, y: rect.maxY - inset))
        path.addLine(to: CGPoint(x: rect.minX + inset, y: rect.maxY - inset))
        path.closeSubpath()
        return path
    }

    func inset(by amount: CGFloat) -> TrapezoidShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}

#Preview {
    NavigationStack {
        LabHubView()
    }
    .environment(AppState())
}
