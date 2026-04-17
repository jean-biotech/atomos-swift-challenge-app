import SwiftUI

// MARK: - Atom Data

private struct FloatingAtomData: Identifiable {
    let id: Int
    let symbol: String
    let x: CGFloat
    let startY: CGFloat
    let size: CGFloat
    let opacity: Double
    let duration: Double
    let color: Color
}

// MARK: - Individual Atom View (manages its own animation)

private struct FloatingAtomView: View {
    let data: FloatingAtomData
    let travelDistance: CGFloat
    @State private var moved = false

    var body: some View {
        Image(systemName: data.symbol)
            .font(.system(size: data.size, weight: .ultraLight))
            .foregroundStyle(data.color)
            .opacity(data.opacity)
            .shadow(color: data.color.opacity(min(data.opacity * 4, 0.9)), radius: data.size * 0.6)
            .position(x: data.x, y: moved ? data.startY - travelDistance : data.startY)
            .onAppear {
                withAnimation(
                    .linear(duration: data.duration)
                    .repeatForever(autoreverses: false)
                ) {
                    moved = true
                }
            }
    }
}

// MARK: - Background View

/// Renders floating glowing molecule icons that drift upward, pre-computed to avoid jitter.
struct FloatingMoleculeBackground: View {

    private static let symbols = [
        "atom", "hexagon", "hurricane", "drop.fill",
        "bolt.circle", "circle.dotted", "cube.transparent",
        "circle.grid.3x3.fill"
    ]

    private static let bgColors: [Color] = [
        .dnaTeal,
        .monumentLavender,
        .dnaPink,
        .monumentSky,
        .enzymeOrange,
        .successGreen,
        .white,
        .hotspotGlow
    ]

    // Deterministic position tables — no CGFloat.random in body
    private static let xFracs: [CGFloat] = [
        0.05, 0.14, 0.26, 0.38, 0.50, 0.62, 0.74, 0.88,
        0.09, 0.22, 0.35, 0.47, 0.60, 0.72, 0.84, 0.04,
        0.18, 0.44, 0.58, 0.82, 0.32, 0.96
    ]
    private static let yFracs: [CGFloat] = [
        1.10, 1.26, 1.42, 1.57, 1.14, 1.32, 1.48, 1.63,
        1.07, 1.35, 1.51, 1.21, 1.43, 1.17, 1.38, 1.61,
        1.27, 1.49, 1.05, 1.33, 1.58, 1.20
    ]
    private static let sizes: [CGFloat] = [
        12, 20, 8, 32, 16, 28, 10, 24,
        18, 36, 14, 22, 30, 12, 26, 16,
        10, 28, 20, 14, 18, 24
    ]
    private static let opacities: [Double] = [
        0.08, 0.12, 0.06, 0.15, 0.10, 0.07, 0.13, 0.09,
        0.11, 0.05, 0.14, 0.08, 0.10, 0.12, 0.06, 0.09,
        0.13, 0.07, 0.11, 0.15, 0.08, 0.10
    ]
    private static let durations: [Double] = [
        18, 14, 22, 16, 25, 12, 20, 17,
        23, 15, 19, 24, 13, 21, 16, 22,
        14, 20, 26, 15, 18, 23
    ]

    private static func buildAtoms(width w: CGFloat, height h: CGFloat) -> [FloatingAtomData] {
        (0..<22).map { i in
            FloatingAtomData(
                id: i,
                symbol: symbols[i % symbols.count],
                x: w * xFracs[i],
                startY: h * yFracs[i],
                size: sizes[i],
                opacity: opacities[i],
                duration: durations[i],
                color: bgColors[i % bgColors.count]
            )
        }
    }

    var body: some View {
        GeometryReader { geo in
            let atoms = Self.buildAtoms(width: geo.size.width, height: geo.size.height)
            ZStack {
                ForEach(atoms) { atom in
                    FloatingAtomView(
                        data: atom,
                        travelDistance: geo.size.height * 2.3
                    )
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }
}
