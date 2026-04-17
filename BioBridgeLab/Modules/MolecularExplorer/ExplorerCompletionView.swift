import SwiftUI

struct ExplorerCompletionView: View {
    let explorerState: ExplorerState
    let onTryAgain: () -> Void
    let onContinue: () -> Void

    @State private var appeared = false
    @State private var showDetails = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.explorerBackground1, .explorerBackground2],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                // Success icon
                ZStack {
                    Circle()
                        .fill(Color.successGreen.opacity(0.15))
                        .frame(width: 100, height: 100)

                    Circle()
                        .fill(Color.successGreen.opacity(0.3))
                        .frame(width: 70, height: 70)

                    Image(systemName: "checkmark")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(Color.successGreen)
                }
                .scaleEffect(appeared ? 1.0 : 0.5)
                .opacity(appeared ? 1 : 0)

                // Title
                VStack(spacing: 8) {
                    Text("Exploration Complete!")
                        .font(.appTitle)
                        .foregroundStyle(.white)

                    Text(completionMessage)
                        .font(.appBody)
                        .foregroundStyle(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 15)

                // Stats
                if showDetails {
                    statsView
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Spacer()

                // Action buttons
                HStack(spacing: 16) {
                    SecondaryButton(title: "Explore Again", action: onTryAgain)
                    AnimatedButton(title: "Return to Lab", color: .successGreen, action: onContinue)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
            }
        }
        .onAppear {
            withAnimation(Anim.spring.delay(0.2)) {
                appeared = true
            }
            withAnimation(Anim.standard.delay(0.8)) {
                showDetails = true
            }
            HapticManager.notification(.success)
        }
    }

    private var moleculeDisplayName: String {
        switch explorerState.selectedMolecule {
        case .dna: return "DNA Double Helix"
        case .protein: return "Protein"
        case .cellMembrane: return "Cell Membrane"
        case .atp: return "ATP"
        case .hemoglobin: return "Hemoglobin"
        case .water: return "Water Molecule"
        case .glucose: return "Glucose"
        }
    }

    private var completionMessage: String {
        "You've explored \(moleculeDisplayName) and discovered all \(explorerState.totalStops) key features."
    }

    private var statsView: some View {
        VStack(spacing: 12) {
            HStack(spacing: 24) {
                statBadge(
                    value: "\(explorerState.visitedStops.count)",
                    label: "Discoveries",
                    color: .dnaTeal
                )
                statBadge(
                    value: moleculeDisplayName,
                    label: "Structure",
                    color: .monumentPeach
                )
                statBadge(
                    value: explorerState.exploreMode == .guided ? "Guided" : "Free",
                    label: "Mode",
                    color: .monumentLavender
                )
            }
        }
        .padding(.horizontal, 20)
    }

    private func statBadge(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(color)
            Text(label)
                .font(.system(size: 11, weight: .light))
                .foregroundStyle(.white.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.08))
        )
    }
}
