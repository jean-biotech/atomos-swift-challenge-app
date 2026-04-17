import SwiftUI

struct LabProgressView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var appeared = false
    @State private var flippedCards: Set<String> = []

    private var modules: [(id: String, name: String, description: String, icon: String, color: Color)] {
        [
            ("molecularExplorer", "Molecular Explorer", "Explore DNA and protein structures in 3D", "cube.transparent", .monumentLavender)
        ]
    }

    var body: some View {
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

                // Header row
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 6)

                // Welcome greeting — animated, same as hub
                Text("Welcome, future scientist!")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.dnaTeal, Color.monumentLavender],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 8)
                    .animation(Anim.standard.delay(0.1), value: appeared)
                    .padding(.bottom, 6)

                // Title + subtitle compact
                VStack(spacing: 3) {
                    Text("Lab Notebook")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)
                    Text("\(appState.completedCount) of \(appState.totalModules) experiments complete")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.55))
                }
                .padding(.bottom, 14)

                // Progress bar
                ProgressBarView(
                    progress: Double(appState.completedCount) / Double(appState.totalModules),
                    color: .successGreen,
                    glow: false
                )
                .padding(.horizontal, 40)
                .padding(.bottom, 18)

                // Module list — no ScrollView needed, all 4 fit
                VStack(spacing: 10) {
                    ForEach(Array(modules.enumerated()), id: \.offset) { index, module in
                        flipCard(module: module, index: index)
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 20)
                            .animation(Anim.standard.delay(0.15 + Double(index) * 0.08), value: appeared)
                    }
                }
                .padding(.horizontal, 20)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            withAnimation(Anim.standard.delay(0.2)) {
                appeared = true
            }
        }
    }

    // MARK: - Flip Card Container
    private func flipCard(module: (id: String, name: String, description: String, icon: String, color: Color), index: Int) -> some View {
        let completed = appState.completedCount > 0
        let isFlipped = flippedCards.contains(module.id)

        return ZStack {
            cardBack(module: module)
                .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 1 : 0)

            cardFront(module: module, completed: completed)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .opacity(isFlipped ? 0 : 1)
        }
        .onTapGesture {
            if completed {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                    if flippedCards.contains(module.id) {
                        flippedCards.remove(module.id)
                    } else {
                        flippedCards.insert(module.id)
                    }
                }
                HapticManager.impact(.light)
            }
        }
    }

    // MARK: - Card Front
    private func cardFront(module: (id: String, name: String, description: String, icon: String, color: Color), completed: Bool) -> some View {
        NavigationLink(destination: destinationView(for: module.id)) {
            HStack(spacing: 14) {
                // Icon circle
                ZStack {
                    Circle()
                        .fill(module.color.opacity(0.2))
                        .frame(width: 44, height: 44)

                    if completed {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(module.color)
                    } else {
                        Image(systemName: module.icon)
                            .font(.system(size: 18))
                            .foregroundStyle(module.color)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(module.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)

                    Text(module.description)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.white.opacity(0.5))

                    HStack(spacing: 4) {
                        Image(systemName: completed ? "checkmark.circle.fill" : "play.circle.fill")
                            .font(.system(size: 9))
                        Text(completed ? "Completed — Tap to see what you learned" : "Tap to start")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(module.color)
                }

                Spacer()

                Image(systemName: completed ? "arrow.left.arrow.right" : "chevron.right")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white.opacity(0.3))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(0.07))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(
                                completed ? module.color.opacity(0.4) : Color.white.opacity(0.1),
                                lineWidth: completed ? 1.5 : 1
                            )
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(appState.completedCount > 0)
    }

    // MARK: - Card Back
    private func cardBack(module: (id: String, name: String, description: String, icon: String, color: Color)) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 14))
                    .foregroundStyle(module.color)
                Text("What You Learned")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white)
                Spacer()
                Text("Tap to flip back")
                    .font(.system(size: 9))
                    .foregroundStyle(.white.opacity(0.35))
            }

            ForEach(learningSummary(for: module.id), id: \.text) { item in
                HStack(alignment: .top, spacing: 8) {
                    Image(systemName: item.icon)
                        .font(.system(size: 11))
                        .foregroundStyle(module.color)
                        .frame(width: 16)
                    Text(item.text)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.white.opacity(0.85))
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            HStack {
                Spacer()
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(module.color)
                Spacer()
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white.opacity(0.07))
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .strokeBorder(module.color.opacity(0.4), lineWidth: 1.5)
                )
        )
    }

    // MARK: - Navigation Destinations
    @ViewBuilder
    private func destinationView(for moduleId: String) -> some View {
        MolecularExplorerModuleView(molecule: .dna, mode: .guided)
    }

    // MARK: - Learning Summaries
    private func learningSummary(for moduleId: String) -> [(icon: String, text: String)] {
        return [
            ("hurricane", "Explored the DNA double helix structure in 3D"),
            ("cube.transparent", "Learned about alpha helices, beta sheets, and loops"),
            ("magnifyingglass", "Discovered base pairs, grooves, and backbone chemistry"),
            ("sparkles", "Navigated protein tertiary structure and disulfide bridges")
        ]
    }
}

#Preview {
    NavigationStack {
        LabProgressView()
    }
    .environment(AppState())
}
