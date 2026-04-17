import SwiftUI

struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
    var speed: CGFloat
    var color: Color
    var animatedOffsetX: CGFloat
    var animatedOffsetY: CGFloat
}

struct ParticleEmitterView: View {
    var particleCount: Int = 25
    var colors: [Color] = [.dnaTeal, .dnaPink, .white]
    var areaSize: CGSize = CGSize(width: 300, height: 400)

    @State private var particles: [Particle] = []
    @State private var animationPhase: Bool = false

    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .opacity(animationPhase ? particle.opacity : particle.opacity * 0.3)
                    .position(
                        x: particle.x + (animationPhase ? particle.animatedOffsetX : 0),
                        y: particle.y + (animationPhase ? particle.animatedOffsetY : 0)
                    )
                    .blur(radius: particle.size > 3 ? 1 : 0)
            }
        }
        .frame(width: areaSize.width, height: areaSize.height)
        .onAppear {
            generateParticles()
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animationPhase = true
            }
        }
    }

    private func generateParticles() {
        particles = (0..<particleCount).map { _ in
            Particle(
                x: CGFloat.random(in: 0...areaSize.width),
                y: CGFloat.random(in: 0...areaSize.height),
                size: CGFloat.random(in: 2...5),
                opacity: Double.random(in: 0.2...0.7),
                speed: CGFloat.random(in: 0.5...2),
                color: colors.randomElement() ?? .white,
                animatedOffsetX: CGFloat.random(in: -20...20),
                animatedOffsetY: CGFloat.random(in: -30...10)
            )
        }
    }
}
