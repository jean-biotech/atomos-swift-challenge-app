import SwiftUI

// MARK: - Color palette for the physical journal

private extension Color {
    static let journalCover    = Color(red: 0.20, green: 0.13, blue: 0.07)   // dark leather brown
    static let journalSpine    = Color(red: 0.14, green: 0.09, blue: 0.04)   // darker spine
    static let journalPage     = Color(red: 0.97, green: 0.93, blue: 0.83)   // aged parchment
    static let journalPageAlt  = Color(red: 0.94, green: 0.89, blue: 0.78)   // slightly darker parchment
    static let journalInk      = Color(red: 0.12, green: 0.08, blue: 0.03)   // dark sepia ink
    static let journalFaintInk = Color(red: 0.12, green: 0.08, blue: 0.03).opacity(0.35)
    static let journalRuleLine = Color(red: 0.65, green: 0.55, blue: 0.38).opacity(0.3)
    static let journalRedLine  = Color(red: 0.72, green: 0.18, blue: 0.12).opacity(0.45)
    static let journalGold     = Color(red: 0.75, green: 0.58, blue: 0.22)
}

// MARK: - Main View

struct MoleculeJournalView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    @State private var currentPage = 0

    // Total pages: cover (0) + 7 molecule pages
    private var totalPages: Int { 1 + AppState.unlockOrder.count }

    var body: some View {
        ZStack {
            // Dark frame behind the book
            Color(red: 0.07, green: 0.05, blue: 0.03).ignoresSafeArea()

            TabView(selection: $currentPage) {
                // Page 0: Cover
                JournalCoverPage(
                    completedCount: appState.completedCount,
                    totalCount: appState.totalModules
                )
                .tag(0)

                // Pages 1–7: Molecule entries
                ForEach(Array(AppState.unlockOrder.enumerated()), id: \.element.rawValue) { index, molecule in
                    JournalMoleculePage(
                        molecule: molecule,
                        entryNumber: index + 1,
                        isCompleted: appState.isMoleculeCompleted(molecule),
                        isUnlocked: appState.isMoleculeUnlocked(molecule),
                        previousMoleculeName: index > 0 ? AppState.unlockOrder[index - 1].rawValue : nil
                    )
                    .tag(index + 1)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            // Page indicator dots
            VStack {
                Spacer()
                pageIndicator
                    .padding(.bottom, 28)
            }

            // Back button (always accessible)
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        HStack(spacing: 5) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 12, weight: .semibold))
                            Text("Lab")
                                .font(.system(size: 13, weight: .medium))
                        }
                        .foregroundStyle(currentPage == 0
                            ? Color.journalGold.opacity(0.85)
                            : Color.journalInk.opacity(0.6))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            Capsule()
                                .fill(currentPage == 0
                                    ? Color.white.opacity(0.08)
                                    : Color.journalInk.opacity(0.07))
                                .overlay(Capsule().strokeBorder(
                                    currentPage == 0
                                        ? Color.journalGold.opacity(0.25)
                                        : Color.journalInk.opacity(0.12),
                                    lineWidth: 1
                                ))
                        )
                    }
                    .padding(.leading, 20)
                    .padding(.top, 56)
                    Spacer()
                }
                Spacer()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onDisappear {
            SpeechManager.shared.stop()
        }
    }

    // MARK: - Page Indicator

    private var pageIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<totalPages, id: \.self) { i in
                Capsule()
                    .fill(i == currentPage
                          ? (currentPage == 0 ? Color.journalGold : Color.journalInk.opacity(0.6))
                          : (currentPage == 0 ? Color.white.opacity(0.25) : Color.journalInk.opacity(0.2)))
                    .frame(width: i == currentPage ? 18 : 6, height: 6)
                    .animation(Anim.fast, value: currentPage)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(
            Capsule()
                .fill(currentPage == 0
                    ? Color.white.opacity(0.08)
                    : Color.journalInk.opacity(0.07))
        )
    }
}

// MARK: - Cover Page

private struct JournalCoverPage: View {
    let completedCount: Int
    let totalCount: Int

    var body: some View {
        ZStack {
            // Leather gradient
            LinearGradient(
                colors: [
                    Color.journalCover,
                    Color(red: 0.28, green: 0.18, blue: 0.09),
                    Color.journalCover
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Left spine accent
            HStack(spacing: 0) {
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [Color.journalSpine, Color.journalCover, Color.journalSpine],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(width: 28)
                    Rectangle()
                        .fill(Color.journalGold.opacity(0.25))
                        .frame(width: 1)
                        .offset(x: 8)
                    Text("BIOBRIDGE LAB")
                        .font(.system(size: 7, weight: .bold))
                        .tracking(2.5)
                        .foregroundStyle(Color.journalGold.opacity(0.7))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 160)
                }
                Spacer()
            }
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // Gold decorative top border
                RoundedRectangle(cornerRadius: 4)
                    .strokeBorder(Color.journalGold.opacity(0.4), lineWidth: 1)
                    .frame(height: 36)
                    .padding(.horizontal, 48)
                    .overlay(
                        Text("MOLECULAR LAB JOURNAL")
                            .font(.system(size: 9, weight: .bold))
                            .tracking(3)
                            .foregroundStyle(Color.journalGold.opacity(0.8))
                    )
                    .padding(.bottom, 28)

                // Atom icon
                Image(systemName: "atom")
                    .font(.system(size: 52, weight: .ultraLight))
                    .foregroundStyle(Color.journalGold.opacity(0.55))
                    .padding(.bottom, 20)

                // Title
                Text("Field Notes")
                    .font(.system(size: 30, weight: .light))
                    .tracking(4)
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(.bottom, 6)

                Text("on Molecular Biology")
                    .font(.system(size: 13, weight: .light))
                    .tracking(1.5)
                    .foregroundStyle(Color.journalGold.opacity(0.7))
                    .padding(.bottom, 36)

                // Progress stamp
                ZStack {
                    Circle()
                        .strokeBorder(Color.journalGold.opacity(0.35), lineWidth: 1.5)
                        .frame(width: 78, height: 78)
                    Circle()
                        .strokeBorder(Color.journalGold.opacity(0.15), lineWidth: 0.5)
                        .frame(width: 68, height: 68)
                    VStack(spacing: 2) {
                        Text("\(completedCount)")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(Color.journalGold)
                        Text("of \(totalCount)")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(Color.journalGold.opacity(0.7))
                    }
                }
                .padding(.bottom, 36)

                // Bottom rule
                Rectangle()
                    .fill(Color.journalGold.opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, 56)

                // Swipe hint
                HStack(spacing: 6) {
                    Text("Swipe to read")
                        .font(.system(size: 11, weight: .light))
                        .tracking(0.5)
                        .foregroundStyle(Color.journalGold.opacity(0.5))
                    Image(systemName: "arrow.right")
                        .font(.system(size: 10))
                        .foregroundStyle(Color.journalGold.opacity(0.4))
                }
                .padding(.top, 14)

                Spacer()
            }
            .padding(.leading, 28) // clear of spine
        }
    }
}

// MARK: - Molecule Page

private struct JournalMoleculePage: View {
    let molecule: ExplorerState.MoleculeType
    let entryNumber: Int
    let isCompleted: Bool
    let isUnlocked: Bool
    let previousMoleculeName: String?

    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            // Parchment background
            Color.journalPage.ignoresSafeArea()

            // Subtle paper texture
            LinearGradient(
                colors: [
                    Color(red: 0.85, green: 0.78, blue: 0.62).opacity(0.14),
                    Color.clear,
                    Color(red: 0.70, green: 0.60, blue: 0.42).opacity(0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // Horizontal ruled lines
            GeometryReader { geo in
                let lineCount = Int(geo.size.height / 28)
                VStack(spacing: 0) {
                    ForEach(0..<max(lineCount, 0), id: \.self) { _ in
                        Spacer()
                        Rectangle()
                            .fill(Color.journalRuleLine)
                            .frame(height: 0.5)
                    }
                }
            }

            // Left binding shadow
            HStack(spacing: 0) {
                LinearGradient(
                    colors: [
                        Color.journalInk.opacity(0.18),
                        Color.journalInk.opacity(0.06),
                        Color.clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .frame(width: 32)
                Spacer()
            }
            .ignoresSafeArea()

            // Red margin line
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.journalRedLine)
                    .frame(width: 1)
                    .offset(x: 55)
                Spacer()
            }
            .ignoresSafeArea(edges: .vertical)

            // Entry number in margin
            VStack {
                HStack {
                    VStack(spacing: 3) {
                        Text(String(format: "%02d", entryNumber))
                            .font(.system(size: 11, weight: .bold, design: .monospaced))
                            .foregroundStyle(Color.journalGold.opacity(isCompleted ? 0.9 : 0.4))
                        if isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 9, weight: .bold))
                                .foregroundStyle(Color(red: 0.2, green: 0.5, blue: 0.2))
                        }
                    }
                    .frame(width: 55)
                    .padding(.top, 64)
                    Spacer()
                }
                Spacer()
            }

            // Scrollable page content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    pageContent
                }
                .padding(.leading, 68) // past margin line
                .padding(.trailing, 24)
                .padding(.top, 60)
                .padding(.bottom, 80)
            }
        }
    }

    // MARK: - Page Content

    @ViewBuilder
    private var pageContent: some View {
        // Header: icon + title
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                if isCompleted {
                    Circle()
                        .fill(molecule.accentColor.opacity(0.18))
                        .frame(width: 50, height: 50)
                } else {
                    Circle()
                        .strokeBorder(Color.journalInk.opacity(isUnlocked ? 0.18 : 0.08), lineWidth: 1)
                        .frame(width: 50, height: 50)
                }
                Image(systemName: isUnlocked ? molecule.icon : "lock")
                    .font(.system(size: isUnlocked ? 22 : 18))
                    .foregroundStyle(
                        isCompleted ? molecule.accentColor :
                        isUnlocked ? Color.journalInk.opacity(0.45) :
                        Color.journalInk.opacity(0.2)
                    )
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(molecule.rawValue)
                    .font(.system(size: 18, weight: isCompleted ? .semibold : .regular))
                    .foregroundStyle(
                        isCompleted ? Color.journalInk :
                        isUnlocked ? Color.journalInk.opacity(0.55) :
                        Color.journalInk.opacity(0.3)
                    )
                statusLabel
            }
        }
        .padding(.bottom, 22)

        if isCompleted {
            completedContent
        } else if isUnlocked {
            availableContent
        } else {
            lockedContent
        }
    }

    @ViewBuilder
    private var statusLabel: some View {
        if isCompleted {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(molecule.accentColor)
                Text("Documented")
                    .font(.system(size: 12, weight: .light).italic())
                    .foregroundStyle(Color.journalFaintInk)
            }
        } else if isUnlocked {
            Text("Not yet explored")
                .font(.system(size: 12, weight: .light).italic())
                .foregroundStyle(Color.journalFaintInk.opacity(0.7))
        } else if let prev = previousMoleculeName {
            Text("Unlock after: \(prev)")
                .font(.system(size: 11, weight: .light).italic())
                .foregroundStyle(Color.journalFaintInk.opacity(0.5))
        }
    }

    @ViewBuilder
    private var completedContent: some View {
        // Divider
        HStack(spacing: 8) {
            Rectangle().fill(Color.journalRuleLine).frame(height: 1)
            Text("observations")
                .font(.system(size: 9, weight: .light).italic())
                .foregroundStyle(Color.journalFaintInk)
                .fixedSize()
            Rectangle().fill(Color.journalRuleLine).frame(height: 1)
        }
        .padding(.bottom, 16)

        HStack(alignment: .firstTextBaseline) {
            Text("What You Learned")
                .font(.system(size: 12, weight: .semibold))
                .tracking(0.5)
                .foregroundStyle(Color.journalInk.opacity(0.45))

            Spacer()

            Button(action: {
                SpeechManager.shared.speak(learningSummary.joined(separator: ". "))
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.system(size: 10))
                    Text("Read")
                        .font(.system(size: 11, weight: .medium))
                }
                .foregroundStyle(molecule.accentColor)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(molecule.accentColor.opacity(0.1))
                        .overlay(Capsule().strokeBorder(molecule.accentColor.opacity(0.3), lineWidth: 1))
                )
            }
            .accessibilityLabel("Read what you learned aloud")
        }
        .padding(.bottom, 14)

        ForEach(Array(learningSummary.enumerated()), id: \.offset) { _, note in
            HStack(alignment: .top, spacing: 8) {
                Text("•")
                    .font(.system(size: 13, weight: .light))
                    .foregroundStyle(Color.journalInk.opacity(0.35))
                Text(note)
                    .font(.footnote.weight(.regular))
                    .foregroundStyle(Color.journalInk.opacity(0.82))
                    .lineSpacing(4)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.bottom, 10)
        }

        // Wax seal
        HStack {
            Spacer()
            ZStack {
                Circle()
                    .fill(molecule.accentColor.opacity(0.15))
                    .frame(width: 44, height: 44)
                Circle()
                    .strokeBorder(molecule.accentColor.opacity(0.45), lineWidth: 1)
                    .frame(width: 44, height: 44)
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(molecule.accentColor)
            }
            .padding(.top, 22)
        }
    }

    @ViewBuilder
    private var availableContent: some View {
        HStack(spacing: 8) {
            Rectangle().fill(Color.journalRuleLine).frame(height: 1)
            Text("awaiting entry")
                .font(.system(size: 9, weight: .light).italic())
                .foregroundStyle(Color.journalFaintInk)
                .fixedSize()
            Rectangle().fill(Color.journalRuleLine).frame(height: 1)
        }
        .padding(.bottom, 14)

        Text(molecule.subtitle)
            .font(.system(size: 13, weight: .light).italic())
            .foregroundStyle(Color.journalFaintInk)
            .lineSpacing(3)
            .padding(.bottom, 16)

        ForEach(0..<5, id: \.self) { _ in
            Rectangle()
                .fill(Color.journalRuleLine.opacity(0.5))
                .frame(height: 0.5)
                .padding(.vertical, 12)
        }
    }

    @ViewBuilder
    private var lockedContent: some View {
        HStack(spacing: 8) {
            Rectangle().fill(Color.journalRuleLine.opacity(0.4)).frame(height: 1)
            Text("sealed")
                .font(.system(size: 9, weight: .light).italic())
                .foregroundStyle(Color.journalFaintInk.opacity(0.4))
                .fixedSize()
            Rectangle().fill(Color.journalRuleLine.opacity(0.4)).frame(height: 1)
        }
        .padding(.bottom, 14)

        if let prev = previousMoleculeName {
            Text("Complete \(prev) to reveal this entry.")
                .font(.system(size: 12, weight: .light).italic())
                .foregroundStyle(Color.journalFaintInk.opacity(0.5))
                .lineSpacing(3)
        }
    }

    // MARK: - Learning Summaries

    private var learningSummary: [String] {
        switch molecule {
        case .dna:
            return [
                "DNA is a double helix: two strands twist around each other in a right-handed spiral, running in opposite directions (antiparallel).",
                "Base pairing is strict. Adenine (A) always bonds to thymine (T), and guanine (G) always bonds to cytosine (C). This is why each strand can template a perfect copy.",
                "The sugar-phosphate backbone forms the outer rails of the ladder. Phosphate groups link the sugars together and give DNA its slight negative charge.",
                "A single human cell contains about 1.8 metres of DNA, tightly packed into a nucleus only 6 micrometres wide.",
                "DNA encodes genes, the instructions for building proteins. Only about 1.5% of your DNA codes for proteins; the rest regulates, organises, or is still being understood.",
                "Every time a cell divides, each strand serves as a template so both daughter cells inherit an identical copy of the genome."
            ]
        case .water:
            return [
                "The 104.5-degree bond angle is caused by two lone electron pairs on the oxygen atom. These pairs repel the hydrogen atoms, bending the molecule away from linear.",
                "Oxygen pulls shared electrons toward itself much more strongly than hydrogen, creating partial negative (delta-) and positive (delta+) charges on the molecule.",
                "Each water molecule can form up to four hydrogen bonds with its neighbours. These bonds are weak individually, but together they give water its unusually high boiling point of 100 degrees C.",
                "This polarity makes water the most effective natural solvent. Ions and polar molecules dissolve easily because water molecules surround and stabilise them.",
                "Water's high specific heat capacity resists temperature change, helping moderate Earth's climate and stabilise body temperature in warm-blooded animals.",
                "Nearly every biochemical reaction in living cells happens in water solution. Life as we know it would be impossible without water's unique combination of properties."
            ]
        case .protein:
            return [
                "Proteins are made by stringing together amino acids in a specific order determined by your DNA. There are 20 different amino acids, each with a unique side chain.",
                "Alpha helices form when the backbone coils into a tight right-handed spiral, stabilised by hydrogen bonds between every fourth amino acid. Think of it as a molecular spring.",
                "Beta sheets form flat, rigid platforms where extended strands lie side by side, linked by hydrogen bonds between backbones. Silk gets its extraordinary tensile strength from stacked beta sheets.",
                "Loop regions are flexible connectors between helices and sheets. Because they sit on the protein surface, they often form the active site where binding and catalysis happen.",
                "Disulfide bridges form between cysteine residues when their sulfur atoms bond covalently. These act as molecular staples, locking the 3D shape in place even under harsh conditions.",
                "The tertiary structure (the complete 3D fold) is driven mainly by the hydrophobic effect: water-fearing side chains bury themselves in the interior, forcing the chain into its functional shape.",
                "Heat or pH extremes disrupt these forces and unfold the protein (denaturation). This is exactly what happens when you cook an egg: the proteins unfold and clump into a firm white solid."
            ]
        case .glucose:
            return [
                "At body temperature, glucose spontaneously closes into a six-membered pyranose ring. The ring form is far more stable than the open-chain version under biological conditions.",
                "The ring can form in two ways, producing alpha-glucose and beta-glucose. The difference is just which way one hydroxyl group points at carbon 1, but it has enormous consequences.",
                "Beta-glucose chains form cellulose (the rigid material in plant cell walls), while alpha-glucose chains form starch and glycogen (energy storage). Same atoms, different bonds, totally different materials.",
                "Five hydroxyl (-OH) groups stud the ring. These interact strongly with water, making glucose highly soluble and easy to transport through the bloodstream.",
                "Cells break glucose down through glycolysis and the citric acid cycle, extracting energy in a controlled, step-by-step process rather than burning it all at once.",
                "One glucose molecule, fully oxidised, produces roughly 30 to 32 ATP molecules. Disruption of glucose regulation causes diabetes, one of the world's most common metabolic diseases."
            ]
        case .atp:
            return [
                "ATP (adenosine triphosphate) consists of three linked parts: an adenine nitrogen base, a five-carbon ribose sugar, and a chain of three phosphate groups.",
                "The three phosphate groups are all negatively charged. Packing these repulsive charges together in the terminal bond creates a high-energy, strained state ready to release energy.",
                "Hydrolysis (breaking the bond to the terminal phosphate) releases about 7.3 kcal per mole of free energy. Cells use this energy release to power otherwise unfavourable reactions.",
                "ATP powers an enormous range of cellular work: muscle contraction, active transport of ions across membranes, building new molecules, and sending nerve signals.",
                "Your body turns over roughly its own body weight in ATP every single day. A sprinting athlete can churn through 0.5 kg of ATP per minute.",
                "Mitochondria regenerate ATP from ADP using the electron transport chain. Oxygen is the final electron acceptor, which is exactly why we need to breathe to stay alive."
            ]
        case .cellMembrane:
            return [
                "Phospholipids have a water-loving (hydrophilic) head and two water-fearing (hydrophobic) fatty acid tails. In water, they spontaneously arrange into a bilayer to hide the tails.",
                "The bilayer forms a flexible, self-sealing barrier. If punctured, the hydrophobic forces automatically pull the gap closed, making membranes extraordinarily resilient.",
                "Integral proteins span the bilayer and act as selective channels or pumps, controlling exactly which ions, nutrients, and signals enter or exit the cell.",
                "Cholesterol molecules are wedged between the phospholipids. They reduce fluidity at high temperatures and prevent the membrane from freezing rigid at low temperatures.",
                "Glycoproteins on the outer surface carry the cell's identity tags. The immune system reads these markers to distinguish the body's own cells from invaders.",
                "The membrane maintains a resting voltage of about -70 millivolts in neurons. Rapid changes in this voltage (action potentials) are the electrical signals that power your nervous system."
            ]
        case .hemoglobin:
            return [
                "Adult hemoglobin (HbA) is a tetramer: two alpha subunits and two beta subunits, held together by a network of non-covalent bonds.",
                "Each of the four subunits contains one heme group: a flat, ring-shaped molecule with an iron (Fe2+) atom at its centre that binds one oxygen molecule.",
                "Hemoglobin is a cooperative protein. Binding the first O2 causes a small shape change that makes each additional subunit bind oxygen more eagerly. The result is an S-shaped binding curve, not a simple line.",
                "In the lungs (high O2, low CO2), hemoglobin loads up to 98% of its capacity. In working tissues (low O2, high CO2, lower pH), it releases oxygen precisely where it is needed.",
                "Sickle cell disease is caused by a single nucleotide change in the beta-globin gene, swapping glutamic acid for valine at position 6. This one swap makes hemoglobin molecules clump into rigid fibres under low-oxygen conditions, distorting red blood cells into a sickle shape.",
                "CRISPR-based gene therapies are now approved to treat sickle cell disease by reactivating fetal hemoglobin (HbF), which does not carry the mutation and works normally."
            ]
        }
    }
}

#Preview {
    NavigationStack {
        MoleculeJournalView()
    }
    .environment(AppState())
}
