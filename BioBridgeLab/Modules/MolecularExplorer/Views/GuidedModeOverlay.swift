import SwiftUI

struct GuidedModeOverlay: View {
    @Bindable var explorerState: ExplorerState
    let onComplete: () -> Void

    @State private var showHint = true

    var body: some View {
        ZStack {
            // Top hint + Find Next button
            VStack {
                HStack(alignment: .top) {
                    // Hint banner
                    if showHint && !explorerState.showingInfoCard {
                        InstructionBanner(text: explorerState.visitedStops.isEmpty
                            ? "Tap a glowing marker to begin exploring"
                            : "Tap the next marker to continue")
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    Spacer()

                    // "Find Next" spotlight button
                    if !explorerState.showingInfoCard && !explorerState.isComplete {
                        Button(action: {
                            HapticManager.impact(.medium)
                            explorerState.hintRequested = true
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 11))
                                Text("Find Next")
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 7)
                            .background(
                                Capsule()
                                    .fill(Color.hotspotGlow.opacity(0.75))
                            )
                        }
                        .transition(.opacity.combined(with: .scale))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)

                Spacer()
            }

            // Bottom area: progress + info card
            VStack(spacing: 12) {
                Spacer()

                // Info card (slides up when active)
                if explorerState.showingInfoCard, let content = explorerState.currentInfoContent {
                    InfoCardView(stop: content) {
                        withAnimation(Anim.standard) {
                            explorerState.showingInfoCard = false
                            if explorerState.isComplete {
                                onComplete()
                            }
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                // Progress bar
                VStack(spacing: 8) {
                    // Stop indicators
                    HStack(spacing: 6) {
                        ForEach(0..<explorerState.totalStops, id: \.self) { i in
                            Circle()
                                .fill(circleColor(for: i))
                                .frame(width: 10, height: 10)
                                .scaleEffect(i == explorerState.currentStopIndex && explorerState.showingInfoCard ? 1.4 : 1.0)
                                .animation(Anim.spring, value: explorerState.currentStopIndex)
                        }
                    }

                    // Progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.15))

                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.dnaTeal)
                                .frame(width: geo.size.width * explorerState.progress)
                                .animation(Anim.standard, value: explorerState.progress)
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal, 40)

                    Text("\(explorerState.visitedStops.count) of \(explorerState.totalStops) discoveries")
                        .font(.system(size: 12, weight: .light))
                        .foregroundStyle(.white.opacity(0.5))
                }
                .padding(.bottom, 20)
            }
        }
        .onChange(of: explorerState.showingInfoCard) { _, showing in
            withAnimation(Anim.fast) {
                showHint = !showing
            }
        }
    }

    private func circleColor(for index: Int) -> Color {
        if explorerState.visitedStops.contains(index) {
            return .dnaTeal
        } else if explorerState.canVisitStop(index) {
            return .hotspotGlow
        } else {
            return .white.opacity(0.2)
        }
    }
}
