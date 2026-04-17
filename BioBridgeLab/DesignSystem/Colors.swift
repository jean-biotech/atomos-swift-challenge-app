import SwiftUI

extension Color {
    // Primary Gradients
    static let primaryGradientStart = Color(red: 0.102, green: 0.102, blue: 0.243)  // #1a1a3e
    static let primaryGradientEnd = Color(red: 0.420, green: 0.294, blue: 0.651)     // #6b4ba6

    // Lab
    static let labBenchColor = Color(red: 0.961, green: 0.953, blue: 0.941)          // #f5f3f0

    // DNA Colors
    static let dnaTeal = Color(red: 0.373, green: 0.702, blue: 0.702)                // #5fb3b3
    static let dnaPink = Color(red: 0.969, green: 0.486, blue: 0.643)                // #f77ca4
    static let rnaColor = Color(red: 1.0, green: 0.420, blue: 0.616)                 // #ff6b9d
    static let proteinGold = Color(red: 1.0, green: 0.843, blue: 0.0)                // #ffd700
    static let enzymeOrange = Color(red: 1.0, green: 0.616, blue: 0.361)             // #ff9d5c

    // Base Pair Colors
    static let baseA = Color(red: 1.0, green: 0.843, blue: 0.0)                      // gold
    static let baseT = Color(red: 1.0, green: 0.843, blue: 0.0)                      // gold
    static let baseG = Color(red: 0.373, green: 0.702, blue: 0.702)                  // teal
    static let baseC = Color(red: 0.969, green: 0.486, blue: 0.643)                  // pink

    // Status Colors
    static let successGreen = Color(red: 0.490, green: 0.886, blue: 0.627)           // #7de2a0
    static let warningRed = Color(red: 1.0, green: 0.420, blue: 0.420)               // #ff6b6b

    // Hub Background
    static let hubLavender = Color(red: 0.910, green: 0.835, blue: 0.949)            // #e8d5f2
    static let hubBlue = Color(red: 0.831, green: 0.906, blue: 0.961)                // #d4e7f5

    static func forBase(_ base: String) -> Color {
        switch base.uppercased() {
        case "A": return .baseA
        case "T": return .baseT
        case "U": return .rnaColor
        case "G": return .baseG
        case "C": return .baseC
        default: return .white
        }
    }

    // Monument Valley Palette
    static let monumentLavender = Color(red: 0.75, green: 0.70, blue: 0.85)
    static let monumentPeach = Color(red: 1.0, green: 0.82, blue: 0.75)
    static let monumentSky = Color(red: 0.70, green: 0.85, blue: 0.95)
    static let monumentSand = Color(red: 0.96, green: 0.91, blue: 0.82)
    static let monumentShadow = Color(red: 0.25, green: 0.22, blue: 0.35)

    // Explorer-specific
    static let explorerBackground1 = Color(red: 0.12, green: 0.10, blue: 0.25)
    static let explorerBackground2 = Color(red: 0.22, green: 0.18, blue: 0.38)
    static let hotspotGlow = Color(red: 1.0, green: 0.95, blue: 0.80)
}
