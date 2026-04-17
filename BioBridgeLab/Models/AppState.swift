import SwiftUI

@Observable
class AppState {
    // Per-molecule tracking
    var completedMolecules: Set<String> = []

    // MARK: - Accessibility Settings
    var largeTextEnabled: Bool = false {
        didSet { UserDefaults.standard.set(largeTextEnabled, forKey: "largeTextEnabled") }
    }
    var readAloudEnabled: Bool = false {
        didSet {
            UserDefaults.standard.set(readAloudEnabled, forKey: "readAloudEnabled")
            if !readAloudEnabled { SpeechManager.shared.stop() }
        }
    }
    var hasSeenAccessibilityPrompt: Bool = false {
        didSet { UserDefaults.standard.set(hasSeenAccessibilityPrompt, forKey: "hasSeenAccessibilityPrompt") }
    }

    static let unlockOrder: [ExplorerState.MoleculeType] = [
        .dna, .water, .protein, .glucose, .atp, .cellMembrane, .hemoglobin
    ]

    init() {
        loadProgress()
        // Pre-unlock all content for review
        for molecule in ExplorerState.MoleculeType.allCases {
            completedMolecules.insert(molecule.rawValue)
        }
        largeTextEnabled = UserDefaults.standard.bool(forKey: "largeTextEnabled")
        readAloudEnabled = UserDefaults.standard.bool(forKey: "readAloudEnabled")
        hasSeenAccessibilityPrompt = UserDefaults.standard.bool(forKey: "hasSeenAccessibilityPrompt")
    }

    var completedCount: Int { completedMolecules.count }
    var totalModules: Int { 7 }

    // MARK: - Molecule Completion

    func completeMolecule(_ molecule: ExplorerState.MoleculeType) {
        completedMolecules.insert(molecule.rawValue)
        saveProgress()
    }

    func isMoleculeCompleted(_ molecule: ExplorerState.MoleculeType) -> Bool {
        completedMolecules.contains(molecule.rawValue)
    }

    func isMoleculeUnlocked(_ molecule: ExplorerState.MoleculeType) -> Bool {
        return true
    }

    var nextUnlockedMolecule: ExplorerState.MoleculeType? {
        Self.unlockOrder.first { isMoleculeUnlocked($0) && !isMoleculeCompleted($0) }
    }

    // MARK: - Persistence

    func saveProgress() {
        if let data = try? JSONEncoder().encode(Array(completedMolecules)) {
            UserDefaults.standard.set(data, forKey: "completedMolecules")
        }
    }

    func loadProgress() {
        if let data = UserDefaults.standard.data(forKey: "completedMolecules"),
           let molecules = try? JSONDecoder().decode([String].self, from: data) {
            completedMolecules = Set(molecules)
        }
    }

    func resetAll() {
        completedMolecules.removeAll()
        saveProgress()
    }
}
