import SceneKit
import SwiftUI

// MARK: - DNA Structure Data

enum BasePairType: String, CaseIterable {
    case AT, TA, GC, CG

    var strandOneBase: String {
        switch self {
        case .AT: return "A"
        case .TA: return "T"
        case .GC: return "G"
        case .CG: return "C"
        }
    }

    var strandTwoBase: String {
        switch self {
        case .AT: return "T"
        case .TA: return "A"
        case .GC: return "C"
        case .CG: return "G"
        }
    }

    var primaryColor: Color {
        switch self {
        case .AT, .TA: return .baseA
        case .GC, .CG: return .baseG
        }
    }

    var secondaryColor: Color {
        switch self {
        case .AT, .TA: return .baseT
        case .GC, .CG: return .baseC
        }
    }
}

struct NucleotideData: Identifiable {
    let id: Int
    let basePair: BasePairType
    let position: SCNVector3
    let complementPosition: SCNVector3
    let backboneAngle: Float
}

struct DNAHelixData {
    let nucleotides: [NucleotideData]
    let backboneRadius: Float
    let risePerBasePair: Float
    let basePairsPerTurn: Int
    let totalBasePairs: Int

    static func generate(basePairs: Int = 30) -> DNAHelixData {
        let radius: Float = 1.5
        let rise: Float = 0.34
        let perTurn = 10
        let sequence: [BasePairType] = [.AT, .GC, .TA, .CG, .AT, .GC, .GC, .AT, .TA, .CG]

        var nucleotides: [NucleotideData] = []
        for i in 0..<basePairs {
            let angle = Float(i) * (2.0 * Float.pi / Float(perTurn))
            let y = Float(i) * rise
            let x1 = radius * cos(angle)
            let z1 = radius * sin(angle)
            let x2 = radius * cos(angle + Float.pi)
            let z2 = radius * sin(angle + Float.pi)

            nucleotides.append(NucleotideData(
                id: i,
                basePair: sequence[i % sequence.count],
                position: SCNVector3(x1, y, z1),
                complementPosition: SCNVector3(x2, y, z2),
                backboneAngle: angle
            ))
        }

        return DNAHelixData(
            nucleotides: nucleotides,
            backboneRadius: radius,
            risePerBasePair: rise,
            basePairsPerTurn: perTurn,
            totalBasePairs: basePairs
        )
    }
}

// MARK: - Protein Structure Data

enum SecondaryStructure: String {
    case alphaHelix
    case betaSheet
    case loop
    case turn
}

struct AminoAcidData: Identifiable {
    let id: Int
    let threeLetterCode: String
    let position: SCNVector3
    let secondaryStructure: SecondaryStructure
    let color: Color
}

struct HelixSegment {
    let startIndex: Int
    let endIndex: Int
    let center: SCNVector3
    let axis: SCNVector3
    let radius: Float
}

struct SheetSegment {
    let startIndex: Int
    let endIndex: Int
    let direction: SCNVector3
}

struct LoopSegment {
    let startIndex: Int
    let endIndex: Int
}

struct ProteinStructureData {
    let aminoAcids: [AminoAcidData]
    let helixSegments: [HelixSegment]
    let sheetSegments: [SheetSegment]
    let loops: [LoopSegment]

    /// Generates a simplified insulin-like protein structure for visualization
    static func generateInsulin() -> ProteinStructureData {
        var acids: [AminoAcidData] = []
        let residues = [
            ("Gly", Color.dnaTeal), ("Ile", Color.enzymeOrange), ("Val", Color.dnaTeal),
            ("Glu", Color.warningRed), ("Gln", Color.rnaColor), ("Cys", Color.proteinGold),
            ("Cys", Color.proteinGold), ("Thr", Color.dnaPink), ("Ser", Color.monumentSky),
            ("Ile", Color.enzymeOrange), ("Cys", Color.proteinGold), ("Ser", Color.monumentSky),
            ("Leu", Color.dnaTeal), ("Tyr", Color.rnaColor), ("Gln", Color.rnaColor),
            ("Leu", Color.dnaTeal), ("Glu", Color.warningRed), ("Asn", Color.monumentPeach),
            ("Tyr", Color.rnaColor), ("Cys", Color.proteinGold), ("Asn", Color.monumentPeach),
        ]

        // Alpha helix 1 (residues 0-6): spiral upward
        for i in 0..<7 {
            let angle = Float(i) * (2.0 * Float.pi / 3.6)
            let y = Float(i) * 0.54
            let x = 1.2 * cos(angle)
            let z = 1.2 * sin(angle)
            acids.append(AminoAcidData(
                id: i,
                threeLetterCode: residues[i].0,
                position: SCNVector3(x, y, z),
                secondaryStructure: .alphaHelix,
                color: residues[i].1
            ))
        }

        // Loop (residues 7-9): transition
        let loopBaseY: Float = Float(7) * 0.54
        for i in 7..<10 {
            let t = Float(i - 7) / 2.0
            let x: Float = 1.2 - t * 0.8
            let z: Float = t * 1.5 - 0.5
            acids.append(AminoAcidData(
                id: i,
                threeLetterCode: residues[i].0,
                position: SCNVector3(x, loopBaseY + t * 0.3, z),
                secondaryStructure: .loop,
                color: residues[i].1
            ))
        }

        // Beta sheet (residues 10-14): flat platform
        let sheetBaseY: Float = loopBaseY + 1.0
        for i in 10..<15 {
            let t = Float(i - 10)
            acids.append(AminoAcidData(
                id: i,
                threeLetterCode: residues[i].0,
                position: SCNVector3(-0.5 + t * 0.7, sheetBaseY, 1.0),
                secondaryStructure: .betaSheet,
                color: residues[i].1
            ))
        }

        // Alpha helix 2 (residues 15-20): another spiral
        let helix2BaseY = sheetBaseY + 0.5
        for i in 15..<21 {
            let angle = Float(i - 15) * (2.0 * Float.pi / 3.6) + Float.pi / 2
            let y = helix2BaseY + Float(i - 15) * 0.54
            let x = 1.0 * cos(angle) + 2.0
            let z = 1.0 * sin(angle)
            acids.append(AminoAcidData(
                id: i,
                threeLetterCode: residues[i % residues.count].0,
                position: SCNVector3(x, y, z),
                secondaryStructure: .alphaHelix,
                color: residues[i % residues.count].1
            ))
        }

        return ProteinStructureData(
            aminoAcids: acids,
            helixSegments: [
                HelixSegment(startIndex: 0, endIndex: 6, center: SCNVector3(0, 0, 0), axis: SCNVector3(0, 1, 0), radius: 1.2),
                HelixSegment(startIndex: 15, endIndex: 20, center: SCNVector3(2, 0, 0), axis: SCNVector3(0, 1, 0), radius: 1.0)
            ],
            sheetSegments: [
                SheetSegment(startIndex: 10, endIndex: 14, direction: SCNVector3(1, 0, 0))
            ],
            loops: [
                LoopSegment(startIndex: 7, endIndex: 9)
            ]
        )
    }
}
