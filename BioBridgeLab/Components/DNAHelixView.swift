import SwiftUI

struct DNAHelixView: View {
    var helixHeight: CGFloat = 300
    var helixWidth: CGFloat = 120
    var basePairCount: Int = 12
    var ribbonColor1: Color = .dnaTeal
    var ribbonColor2: Color = .dnaPink
    var rotationSpeed: Double = 8
    var glowIntensity: Double = 0.3
    var showBasePairs: Bool = true

    @State private var rotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            // Glow backdrop
            Ellipse()
                .fill(
                    RadialGradient(
                        colors: [Color.white.opacity(glowIntensity), .clear],
                        center: .center,
                        startRadius: 10,
                        endRadius: helixWidth * 1.5
                    )
                )
                .frame(width: helixWidth * 3, height: helixHeight * 0.6)

            Canvas { context, size in
                let centerX = size.width / 2
                let centerY = size.height / 2
                let amplitude = helixWidth / 2
                let verticalSpacing = helixHeight / CGFloat(basePairCount)
                let phaseOffset = rotation * .pi / 180

                for i in 0..<basePairCount {
                    let t = CGFloat(i) / CGFloat(basePairCount) * 4 * .pi
                    let y = centerY - helixHeight / 2 + CGFloat(i) * verticalSpacing

                    let x1 = centerX + amplitude * sin(t + phaseOffset)
                    let x2 = centerX + amplitude * sin(t + phaseOffset + .pi)

                    let depth1 = cos(t + phaseOffset)
                    let depth2 = cos(t + phaseOffset + .pi)

                    // Base pair connecting line
                    if showBasePairs {
                        let baseColor: Color = i % 2 == 0 ? .baseA : .baseG
                        var basePath = Path()
                        basePath.move(to: CGPoint(x: x1, y: y))
                        basePath.addLine(to: CGPoint(x: x2, y: y))
                        context.stroke(
                            basePath,
                            with: .color(baseColor.opacity(0.6)),
                            lineWidth: 1.5
                        )
                    }

                    // Draw the node that's further back first
                    let nodes: [(x: CGFloat, depth: CGFloat, color: Color)] = [
                        (x1, depth1, ribbonColor1),
                        (x2, depth2, ribbonColor2)
                    ].sorted { $0.depth < $1.depth }

                    for node in nodes {
                        let size = 8 + 4 * (node.depth + 1) / 2
                        let opacity = 0.5 + 0.5 * (node.depth + 1) / 2
                        let rect = CGRect(
                            x: node.x - size / 2,
                            y: y - size / 2,
                            width: size,
                            height: size
                        )
                        context.fill(
                            Path(ellipseIn: rect),
                            with: .color(node.color.opacity(opacity))
                        )
                    }
                }

                // Draw ribbon paths
                drawRibbon(context: context, centerX: centerX, centerY: centerY,
                          amplitude: amplitude, phaseOffset: phaseOffset,
                          extraPhase: 0, color: ribbonColor1, count: basePairCount,
                          height: helixHeight)
                drawRibbon(context: context, centerX: centerX, centerY: centerY,
                          amplitude: amplitude, phaseOffset: phaseOffset,
                          extraPhase: .pi, color: ribbonColor2, count: basePairCount,
                          height: helixHeight)
            }
            .frame(width: helixWidth * 2, height: helixHeight)
        }
        .scaleEffect(pulseScale)
        .onAppear {
            withAnimation(.linear(duration: rotationSpeed).repeatForever(autoreverses: false)) {
                rotation = 360
            }
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                pulseScale = 1.05
            }
        }
    }

    private func drawRibbon(context: GraphicsContext, centerX: CGFloat, centerY: CGFloat,
                            amplitude: CGFloat, phaseOffset: Double, extraPhase: Double,
                            color: Color, count: Int, height: CGFloat) {
        var path = Path()
        let steps = count * 4
        for s in 0...steps {
            let frac = CGFloat(s) / CGFloat(steps)
            let t = frac * 4 * .pi
            let y = centerY - height / 2 + frac * height
            let x = centerX + amplitude * sin(t + phaseOffset + extraPhase)
            if s == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        context.stroke(path, with: .color(color.opacity(0.8)), lineWidth: 3)
    }
}

#Preview {
    ZStack {
        Color.primaryGradientStart.ignoresSafeArea()
        DNAHelixView()
    }
}
