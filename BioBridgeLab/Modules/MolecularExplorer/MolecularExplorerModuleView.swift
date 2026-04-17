import SwiftUI

enum ExplorerPhase: Int, CaseIterable {
    case exploring = 0
    case complete = 1
}

struct MolecularExplorerModuleView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let molecule: ExplorerState.MoleculeType
    let mode: ExplorerState.ExploreMode

    @State private var currentPhase: ExplorerPhase = .exploring
    @State private var explorerState: ExplorerState

    init(molecule: ExplorerState.MoleculeType, mode: ExplorerState.ExploreMode) {
        self.molecule = molecule
        self.mode = mode
        let state = ExplorerState()
        state.selectedMolecule = molecule
        state.exploreMode = mode
        state.loadStops(for: molecule)
        _explorerState = State(initialValue: state)
    }

    var body: some View {
        ZStack {
            // Scene content
            switch currentPhase {
            case .exploring:
                ExplorerContainerView(
                    explorerState: explorerState,
                    onComplete: {
                        withAnimation(Anim.standard) {
                            currentPhase = .complete
                        }
                    }
                )
            case .complete:
                ExplorerCompletionView(
                    explorerState: explorerState,
                    onTryAgain: {
                        dismiss()
                    },
                    onContinue: {
                        appState.completeMolecule(explorerState.selectedMolecule)
                        dismiss()
                    }
                )
            }

            // Top overlay
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(.white.opacity(0.5))
                    }
                    .accessibilityLabel("Close")

                    Spacer()

                    phaseIndicator
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                Spacer()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var phaseIndicator: some View {
        HStack(spacing: 6) {
            ForEach(ExplorerPhase.allCases, id: \.rawValue) { phase in
                Circle()
                    .fill(phase == currentPhase ? Color.dnaTeal : Color.white.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .scaleEffect(phase == currentPhase ? 1.3 : 1.0)
                    .animation(Anim.spring, value: currentPhase)
            }
        }
    }
}

// MARK: - Explorer Container

struct ExplorerContainerView: View {
    @Bindable var explorerState: ExplorerState
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            // Background gradient (visible through transparent SceneKit bg)
            LinearGradient(
                colors: [.explorerBackground1, .explorerBackground2],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // SceneKit 3D view
            ExplorerSceneView(
                explorerState: explorerState,
                onNodeTapped: handleNodeTap
            )
            .ignoresSafeArea()

            // Mode-specific SwiftUI overlay
            if explorerState.exploreMode == .guided {
                GuidedModeOverlay(explorerState: explorerState, onComplete: onComplete)
            } else {
                FreeModeOverlay(explorerState: explorerState, onComplete: onComplete)
            }
        }
        .onAppear {
            // Auto-show first info card in guided mode
            if explorerState.exploreMode == .guided {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    if let firstStop = explorerState.stops.first {
                        explorerState.visitStop(0)
                        explorerState.currentInfoContent = firstStop
                        withAnimation(Anim.infoCardSlide) {
                            explorerState.showingInfoCard = true
                        }
                    }
                }
            }
        }
    }

    private func handleNodeTap(_ nodeName: String) {
        HapticManager.impact(.light)

        if explorerState.exploreMode == .guided {
            handleGuidedTap(nodeName)
        } else {
            handleFreeTap(nodeName)
        }
    }

    private func handleGuidedTap(_ nodeName: String) {
        // Find which stop this node corresponds to
        guard let stopIndex = explorerState.stops.firstIndex(where: { $0.nodeIdentifier == nodeName }) else { return }
        guard explorerState.canVisitStop(stopIndex) else { return }
        guard !explorerState.isCharacterMoving else { return }

        // Trigger character movement
        explorerState.isCharacterMoving = true
        explorerState.currentStopIndex = stopIndex
    }

    private func handleFreeTap(_ nodeName: String) {
        withAnimation(Anim.fast) {
            explorerState.selectedComponent = nodeName
            explorerState.showingPopup = true
        }
    }
}

#Preview {
    MolecularExplorerModuleView(molecule: .dna, mode: .guided)
        .environment(AppState())
}
