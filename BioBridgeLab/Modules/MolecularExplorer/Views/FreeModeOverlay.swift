import SwiftUI

struct FreeModeOverlay: View {
    @Bindable var explorerState: ExplorerState
    let onComplete: () -> Void

    @State private var showHint = true

    var body: some View {
        ZStack {
            // Top instruction hint
            VStack {
                if showHint && !explorerState.showingPopup {
                    InstructionBanner(text: "Drag to orbit \u{2022} Pinch to zoom \u{2022} Tap to learn")
                        .padding(.top, 60)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                        .onAppear {
                            // Auto-hide hint after 4 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                withAnimation(Anim.standard) {
                                    showHint = false
                                }
                            }
                        }
                }
                Spacer()
            }

            // Info popup when a component is tapped
            VStack {
                Spacer()

                if explorerState.showingPopup, let componentName = explorerState.selectedComponent {
                    componentInfoPopup(for: componentName)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }

            // Done button (always accessible)
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        HapticManager.impact(.light)
                        onComplete()
                    }) {
                        Text("Done")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.successGreen.opacity(0.8))
                            )
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 56)
                }
                Spacer()
            }
        }
    }

    @ViewBuilder
    private func componentInfoPopup(for name: String) -> some View {
        let info = resolveComponentInfo(name)

        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: info.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(Color.dnaTeal)
                Text(info.title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                Spacer()
                Button(action: {
                    withAnimation(Anim.fast) {
                        explorerState.showingPopup = false
                        explorerState.selectedComponent = nil
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(.white.opacity(0.4))
                }
            }
            Text(info.description)
                .font(.appCaption)
                .foregroundStyle(.white.opacity(0.7))
                .lineSpacing(2)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
    }

    private func resolveComponentInfo(_ name: String) -> (title: String, description: String, icon: String) {
        // Match against educational stops for the current molecule
        if let stop = explorerState.stops.first(where: { $0.nodeIdentifier == name }) {
            return (stop.title, stop.detail, stop.icon)
        }

        // Fallback for general components
        if name.hasPrefix("backbone_") {
            return ("Sugar-Phosphate Backbone", "The structural framework of DNA, made of alternating sugar and phosphate groups.", "link")
        } else if name.hasPrefix("basePair_") {
            let index = name.replacingOccurrences(of: "basePair_", with: "")
            return ("Base Pair #\(index)", "A hydrogen-bonded pair of nucleotides connecting the two DNA strands.", "equal.circle")
        } else if name.hasPrefix("helix_") {
            return ("Alpha Helix", "A spiral secondary structure stabilized by hydrogen bonds every 3.6 residues.", "tornado")
        } else if name.hasPrefix("sheet_") {
            return ("Beta Sheet", "Side-by-side protein strands connected by backbone hydrogen bonds.", "rectangle.split.3x1")
        } else if name.hasPrefix("loop_") {
            return ("Loop Region", "A flexible connecting segment, often found on the protein surface.", "arrow.triangle.turn.up.right.diamond")
        } else if name.hasPrefix("amino_") {
            return ("Amino Acid", "One of 20 building blocks that make up proteins.", "circle.fill")
        }

        return ("Structure", "Part of the molecular structure. Tap different parts to learn more.", "cube.transparent")
    }
}
