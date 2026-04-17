import SwiftUI
import SceneKit

@Observable
class ExplorerState {
    enum MoleculeType: String, CaseIterable {
        case dna = "DNA Double Helix"
        case protein = "Protein Structure"
        case cellMembrane = "Cell Membrane"
        case atp = "ATP"
        case hemoglobin = "Hemoglobin"
        case water = "Water Molecule"
        case glucose = "Glucose"

        var icon: String {
            switch self {
            case .dna: return "hurricane"
            case .protein: return "cube.transparent"
            case .cellMembrane: return "circle.dotted"
            case .atp: return "bolt.circle"
            case .hemoglobin: return "drop.circle"
            case .water: return "drop.fill"
            case .glucose: return "hexagon"
            }
        }

        var subtitle: String {
            switch self {
            case .dna: return "Explore the iconic twisted ladder"
            case .protein: return "Navigate alpha helices & beta sheets"
            case .cellMembrane: return "The protective phospholipid bilayer"
            case .atp: return "The cell's energy currency"
            case .hemoglobin: return "Oxygen transport in your blood"
            case .water: return "The molecule that makes life possible"
            case .glucose: return "Fuel for cellular respiration"
            }
        }

        var accentColor: Color {
            switch self {
            case .dna: return .dnaTeal
            case .protein: return .monumentLavender
            case .cellMembrane: return .monumentPeach
            case .atp: return .enzymeOrange
            case .hemoglobin: return .warningRed
            case .water: return .monumentSky
            case .glucose: return .successGreen
            }
        }
    }

    enum ExploreMode: String, CaseIterable {
        case guided = "Guided Tour"
        case free = "Free Explore"

        var icon: String {
            switch self {
            case .guided: return "figure.walk"
            case .free: return "hand.draw"
            }
        }

        var description: String {
            switch self {
            case .guided: return "Follow a character through the structure, learning at each stop"
            case .free: return "Orbit, zoom, and tap to explore at your own pace"
            }
        }
    }

    // Selection
    var selectedMolecule: MoleculeType = .dna
    var exploreMode: ExploreMode = .guided

    // Guided mode state
    var currentStopIndex: Int = 0
    var visitedStops: Set<Int> = []
    var isCharacterMoving: Bool = false
    var showingInfoCard: Bool = false
    var currentInfoContent: EducationalStop? = nil
    var hintRequested: Bool = false

    var nextUnvisitedStopIndex: Int {
        (0..<stops.count).first { !visitedStops.contains($0) } ?? 0
    }

    // Free mode state
    var selectedComponent: String? = nil
    var showingPopup: Bool = false

    // Camera
    var cameraDistance: Float = 15.0

    // Educational stops
    var stops: [EducationalStop] = []

    var totalStops: Int { stops.count }

    var progress: Double {
        guard totalStops > 0 else { return 0 }
        return Double(visitedStops.count) / Double(totalStops)
    }

    var isComplete: Bool {
        totalStops > 0 && visitedStops.count >= totalStops
    }

    func visitStop(_ index: Int) {
        visitedStops.insert(index)
        currentStopIndex = index
    }

    func canVisitStop(_ index: Int) -> Bool {
        return true
    }

    func loadStops(for molecule: MoleculeType) {
        switch molecule {
        case .dna:
            stops = DNAEducationalContent.stops
        case .protein:
            stops = ProteinEducationalContent.stops
        case .cellMembrane:
            stops = CellMembraneEducationalContent.stops
        case .atp:
            stops = ATPEducationalContent.stops
        case .hemoglobin:
            stops = HemoglobinEducationalContent.stops
        case .water:
            stops = WaterMoleculeEducationalContent.stops
        case .glucose:
            stops = GlucoseEducationalContent.stops
        }
    }
}

struct EducationalStop: Identifiable {
    let id: Int
    let title: String
    let description: String
    let detail: String
    let icon: String
    let nodeIdentifier: String
    let position: SCNVector3
}
