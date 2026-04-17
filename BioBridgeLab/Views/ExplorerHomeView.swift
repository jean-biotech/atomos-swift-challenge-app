import SwiftUI

struct ExplorerHomeView: View {
    @Environment(AppState.self) private var appState

    @State private var selectedMolecule: ExplorerState.MoleculeType = .dna
    @State private var selectedMode: ExplorerState.ExploreMode = .guided
    @State private var appeared = false
    @State private var showExplorer = false
    @State private var showJournal = false
    @State private var showInfoSheet = false
    @State private var showAccessibilitySheet = false
    @State private var showAccessibilityWelcome = false

    private var isSelectedMoleculeLocked: Bool {
        !appState.isMoleculeUnlocked(selectedMolecule)
    }

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [.explorerBackground1, .explorerBackground2],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Floating molecule ambient layer
            FloatingMoleculeBackground()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Top bar
                    topBar
                        .padding(.horizontal, 20)
                        .padding(.top, 8)

                    // Hero molecule
                    heroSection
                        .padding(.top, 32)

                    // Molecule carousel
                    moleculeCarousel
                        .padding(.top, 28)

                    // Mode picker
                    modePicker
                        .padding(.top, 28)
                        .padding(.horizontal, 24)

                    // Begin button
                    if isSelectedMoleculeLocked {
                        lockedMessage
                            .padding(.top, 28)
                            .padding(.horizontal, 40)
                            .opacity(appeared ? 1 : 0)
                    } else {
                        AnimatedButton(title: "Begin Exploration", color: .dnaTeal, glow: true) {
                            showExplorer = true
                        }
                        .padding(.top, 28)
                        .padding(.horizontal, 40)
                        .opacity(appeared ? 1 : 0)
                        .offset(y: appeared ? 0 : 20)
                    }

                    // Journal card
                    journalCard
                        .padding(.top, 32)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(isPresented: $showExplorer) {
            MolecularExplorerModuleView(
                molecule: selectedMolecule,
                mode: selectedMode
            )
        }
        .navigationDestination(isPresented: $showJournal) {
            MoleculeJournalView()
        }
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
            // Auto-select next unlocked molecule
            if let next = appState.nextUnlockedMolecule {
                selectedMolecule = next
            }
            withAnimation(Anim.standard.delay(0.2)) {
                appeared = true
            }
        }
    }

    // MARK: - Top Bar

    private var topBar: some View {
        HStack {
            Text("BioBridge Lab")
                .font(.callout.weight(.medium))
                .foregroundStyle(.white.opacity(0.6))

            Spacer()

            // Progress pill
            HStack(spacing: 4) {
                Image(systemName: "flask.fill")
                    .font(.system(size: 11))
                Text("\(appState.completedCount)/\(appState.totalModules)")
                    .font(.footnote.weight(.semibold))
            }
            .foregroundStyle(.white.opacity(0.7))
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Color.white.opacity(0.1))
            )

            Button(action: { showAccessibilitySheet = true }) {
                HStack(spacing: 5) {
                    Image(systemName: "figure.accessibility")
                        .font(.system(size: 14, weight: .medium))
                    Text("Accessibility")
                        .font(.system(size: 12, weight: .semibold))
                }
                .foregroundStyle(Color.dnaTeal)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.dnaTeal.opacity(0.15))
                )
            }
            .accessibilityLabel("Accessibility settings")
            .padding(.leading, 8)

            Button(action: { showInfoSheet = true }) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 20))
                    .foregroundStyle(.white.opacity(0.4))
            }
            .accessibilityLabel("About BioBridge Lab")
            .padding(.leading, 8)
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Image(systemName: selectedMolecule.icon)
                    .font(.system(size: 56))
                    .foregroundStyle(isSelectedMoleculeLocked ? .white.opacity(0.2) : selectedMolecule.accentColor)
                    .shadow(color: isSelectedMoleculeLocked ? .clear : selectedMolecule.accentColor.opacity(0.4), radius: 12)

                if isSelectedMoleculeLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }

            Text(selectedMolecule.rawValue)
                .font(.appLargeTitle)
                .foregroundStyle(isSelectedMoleculeLocked ? .white.opacity(0.4) : .white)

            Text(isSelectedMoleculeLocked ? "Complete previous molecules to unlock" : selectedMolecule.subtitle)
                .font(.appCaption)
                .foregroundStyle(.white.opacity(0.45))
        }
        .animation(Anim.fast, value: selectedMolecule)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 15)
    }

    // MARK: - Molecule Carousel

    private var moleculeCarousel: some View {
        VStack(spacing: 8) {
            Text("Structure")
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.4))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 28)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(AppState.unlockOrder, id: \.rawValue) { molecule in
                        moleculeCard(molecule)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
    }

    private func moleculeCard(_ molecule: ExplorerState.MoleculeType) -> some View {
        let isSelected = selectedMolecule == molecule
        let isLocked = !appState.isMoleculeUnlocked(molecule)
        let isCompleted = appState.isMoleculeCompleted(molecule)

        return Button(action: {
            HapticManager.impact(.light)
            withAnimation(Anim.fast) {
                selectedMolecule = molecule
            }
        }) {
            VStack(spacing: 10) {
                ZStack {
                    Image(systemName: molecule.icon)
                        .font(.system(size: 26))
                        .foregroundStyle(
                            isLocked ? .white.opacity(0.15) :
                            isSelected ? molecule.accentColor : .white.opacity(0.4)
                        )
                        .frame(width: 50, height: 50)
                        .background(
                            Circle()
                                .fill(isSelected ? molecule.accentColor.opacity(0.15) : Color.white.opacity(0.05))
                        )

                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12))
                            .foregroundStyle(.white.opacity(0.4))
                    }

                    if isCompleted {
                        Circle()
                            .fill(Color.successGreen)
                            .frame(width: 18, height: 18)
                            .overlay(
                                Image(systemName: "checkmark")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(.white)
                            )
                            .offset(x: 18, y: -18)
                    }
                }

                Text(molecule.rawValue)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(isLocked ? .white.opacity(0.3) : .white)
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
                                isSelected ? molecule.accentColor.opacity(0.5) :
                                isCompleted ? Color.successGreen.opacity(0.3) :
                                .white.opacity(0.08),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .opacity(isLocked ? 0.7 : 1.0)
        }
    }

    // MARK: - Mode Picker

    private var modePicker: some View {
        VStack(spacing: 14) {
            Text("Mode")
                .font(.footnote.weight(.medium))
                .foregroundStyle(.white.opacity(0.4))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 4)

            ForEach(ExplorerState.ExploreMode.allCases, id: \.rawValue) { mode in
                modeCard(mode)
            }
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 25)
    }

    private func modeCard(_ mode: ExplorerState.ExploreMode) -> some View {
        let isSelected = selectedMode == mode

        return Button(action: {
            HapticManager.impact(.light)
            withAnimation(Anim.fast) {
                selectedMode = mode
            }
        }) {
            HStack(spacing: 14) {
                Image(systemName: mode.icon)
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Color.monumentPeach : .white.opacity(0.4))
                    .frame(width: 36)

                VStack(alignment: .leading, spacing: 2) {
                    Text(mode.rawValue)
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.white)
                    Text(mode.description)
                        .font(.caption.weight(.light))
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
                            .strokeBorder(
                                isSelected ? Color.monumentPeach.opacity(0.4) : .white.opacity(0.08),
                                lineWidth: 1
                            )
                    )
            )
        }
    }

    // MARK: - Locked Message

    private var lockedMessage: some View {
        HStack(spacing: 10) {
            Image(systemName: "lock.fill")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.4))

            Text("Complete previous molecules to unlock")
                .font(.subheadline.weight(.medium))
                .foregroundStyle(.white.opacity(0.4))
        }
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(
            Capsule()
                .fill(Color.white.opacity(0.06))
                .overlay(
                    Capsule()
                        .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }

    // MARK: - Journal Card

    private var journalCard: some View {
        Button(action: {
            HapticManager.impact(.light)
            showJournal = true
        }) {
            HStack(spacing: 14) {
                Image(systemName: "book.closed.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(Color.monumentLavender)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.monumentLavender.opacity(0.12))
                    )

                VStack(alignment: .leading, spacing: 3) {
                    Text("Lab Journal")
                        .font(.callout.weight(.medium))
                        .foregroundStyle(.white)

                    Text("\(appState.completedCount) of \(appState.totalModules) documented")
                        .font(.caption.weight(.light))
                        .foregroundStyle(.white.opacity(0.5))
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.3))
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .strokeBorder(Color.monumentLavender.opacity(0.2), lineWidth: 1)
                    )
            )
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
    }

    // MARK: - Info Sheet

    private var infoSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("What is BioBridge Lab?")
                            .font(.system(size: 22, weight: .bold))
                        Text("An interactive journey through molecular biology. Explore 7 stunning 3D molecular structures, from the iconic DNA double helix to the oxygen-carrying hemoglobin.")
                            .font(.system(size: 14))
                            .foregroundStyle(.secondary)
                            .lineSpacing(2)
                    }

                    Divider()

                    VStack(alignment: .leading, spacing: 14) {
                        Text("How It Works")
                            .font(.system(size: 18, weight: .semibold))

                        infoRow(
                            icon: "cube.transparent",
                            color: .monumentLavender,
                            title: "Explore Molecules",
                            text: "Orbit, zoom, and tap on 3D structures to discover their key features and functions."
                        )

                        infoRow(
                            icon: "lock.open.fill",
                            color: .dnaTeal,
                            title: "Unlock Progression",
                            text: "Complete each molecule to unlock the next. Work your way from DNA to hemoglobin."
                        )

                        infoRow(
                            icon: "book.closed.fill",
                            color: .monumentPeach,
                            title: "Lab Journal",
                            text: "Every completed molecule is documented in your journal with key takeaways."
                        )
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

#Preview {
    NavigationStack {
        ExplorerHomeView()
    }
    .environment(AppState())
}
