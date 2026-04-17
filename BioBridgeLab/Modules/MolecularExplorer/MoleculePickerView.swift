import SwiftUI

struct MoleculePickerView: View {
    @Bindable var explorerState: ExplorerState
    let onBegin: () -> Void

    @State private var appeared = false

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [.explorerBackground1, .explorerBackground2],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer().frame(height: 80)

                // Title
                VStack(spacing: 8) {
                    Text("Molecular Explorer")
                        .font(.appLargeTitle)
                        .foregroundStyle(.white)
                    Text("Choose a structure to explore")
                        .font(.appCaption)
                        .foregroundStyle(.white.opacity(0.5))
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 15)

                // Molecule selection — horizontal scrolling cards
                VStack(spacing: 8) {
                    Text("Structure")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 28)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(ExplorerState.MoleculeType.allCases, id: \.rawValue) { molecule in
                                moleculeCard(molecule)
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)

                Spacer()

                // Selected molecule detail
                selectedMoleculeDetail
                    .opacity(appeared ? 1 : 0)

                Spacer()

                // Mode selection
                VStack(spacing: 14) {
                    Text("Mode")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 4)

                    ForEach(ExplorerState.ExploreMode.allCases, id: \.rawValue) { mode in
                        modeCard(mode)
                    }
                }
                .padding(.horizontal, 24)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 25)

                Spacer()

                // Begin button
                AnimatedButton(title: "Begin Exploration", color: .dnaTeal) {
                    explorerState.loadStops(for: explorerState.selectedMolecule)
                    onBegin()
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
            }
        }
        .onAppear {
            withAnimation(Anim.standard.delay(0.2)) {
                appeared = true
            }
        }
    }

    // MARK: - Molecule Card (compact for horizontal scroll)
    private func moleculeCard(_ molecule: ExplorerState.MoleculeType) -> some View {
        let isSelected = explorerState.selectedMolecule == molecule

        return Button(action: {
            HapticManager.impact(.light)
            withAnimation(Anim.fast) {
                explorerState.selectedMolecule = molecule
            }
        }) {
            VStack(spacing: 10) {
                Image(systemName: molecule.icon)
                    .font(.system(size: 26))
                    .foregroundStyle(isSelected ? molecule.accentColor : .white.opacity(0.4))
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(isSelected ? molecule.accentColor.opacity(0.15) : Color.white.opacity(0.05))
                    )

                Text(molecule.rawValue)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(width: 80)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 8)
            .frame(width: 100)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? molecule.accentColor.opacity(0.1) : Color.white.opacity(0.03))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(
                                isSelected ? molecule.accentColor.opacity(0.5) : .white.opacity(0.08),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
        }
    }

    // MARK: - Selected Detail
    private var selectedMoleculeDetail: some View {
        let molecule = explorerState.selectedMolecule

        return VStack(spacing: 8) {
            Image(systemName: molecule.icon)
                .font(.system(size: 36))
                .foregroundStyle(molecule.accentColor)

            Text(molecule.rawValue)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)

            Text(molecule.subtitle)
                .font(.system(size: 13, weight: .light))
                .foregroundStyle(.white.opacity(0.5))
        }
        .animation(Anim.fast, value: explorerState.selectedMolecule)
    }

    // MARK: - Mode Card
    private func modeCard(_ mode: ExplorerState.ExploreMode) -> some View {
        let isSelected = explorerState.exploreMode == mode

        return Button(action: {
            HapticManager.impact(.light)
            withAnimation(Anim.fast) {
                explorerState.exploreMode = mode
            }
        }) {
            HStack(spacing: 14) {
                Image(systemName: mode.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Color.monumentPeach : .white.opacity(0.4))
                    .frame(width: 36)

                VStack(alignment: .leading, spacing: 2) {
                    Text(mode.rawValue)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                    Text(mode.description)
                        .font(.system(size: 12, weight: .light))
                        .foregroundStyle(.white.opacity(0.5))
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.monumentPeach)
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? Color.monumentPeach.opacity(0.1) : Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .strokeBorder(isSelected ? Color.monumentPeach.opacity(0.4) : .white.opacity(0.08), lineWidth: 1)
                    )
            )
        }
    }
}
