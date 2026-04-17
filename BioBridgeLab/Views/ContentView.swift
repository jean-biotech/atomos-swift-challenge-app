import SwiftUI

struct ContentView: View {
    @State private var showHub = false
    @State private var dnaScale: CGFloat = 1.0
    @State private var dnaOpacity: Double = 1.0
    @State private var tapHintOpacity: Double = 0.0
    @State private var titleOpacity: Double = 0.0
    @State private var isExiting = false

    var body: some View {
        if showHub {
            NavigationStack {
                LabHubView()
            }
            .transition(.opacity)
        } else {
            splashScreen
        }
    }

    private func triggerExit() {
        guard !isExiting else { return }
        isExiting = true
        HapticManager.impact(.light)

        // DNA zoom + dissolve
        withAnimation(.easeIn(duration: 0.6)) {
            dnaScale = 3.0
            dnaOpacity = 0
            titleOpacity = 0
            tapHintOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showHub = true
            }
        }
    }

    private var splashScreen: some View {
        ZStack {
            GradientBackground()

            // Floating molecule icons in the background
            FloatingMoleculeBackground()

            // Particles behind DNA
            ParticleEmitterView(
                particleCount: 30,
                colors: [.dnaTeal.opacity(0.5), .dnaPink.opacity(0.5), .white.opacity(0.3)],
                areaSize: CGSize(width: 350, height: 500)
            )

            VStack(spacing: 0) {
                Spacer()

                // DNA Helix
                DNAHelixView(
                    helixHeight: 280,
                    helixWidth: 100,
                    basePairCount: 14,
                    glowIntensity: 0.4
                )
                .scaleEffect(dnaScale)
                .opacity(dnaOpacity)
                .padding(.bottom, 40)

                // Title
                VStack(spacing: 10) {
                    Text("BIOBRIDGE LAB")
                        .font(.appLargeTitle)
                        .tracking(6)
                        .foregroundStyle(.white)

                    // Decorative line
                    HStack(spacing: 8) {
                        Rectangle()
                            .fill(Color.dnaTeal.opacity(0.5))
                            .frame(width: 32, height: 1)
                        Image(systemName: "atom")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.dnaTeal.opacity(0.7))
                        Rectangle()
                            .fill(Color.dnaTeal.opacity(0.5))
                            .frame(width: 32, height: 1)
                    }

                    Text("Your Molecule Explorer")
                        .font(.system(size: 13, weight: .light))
                        .tracking(0.5)
                        .foregroundStyle(.white.opacity(0.55))
                }
                .opacity(titleOpacity)
                .padding(.bottom, 60)

                Spacer()

                // Tap hint
                VStack(spacing: 6) {
                    Image(systemName: "hand.tap")
                        .font(.system(size: 20))
                    Text("Tap to enter")
                        .font(.appCaption)
                }
                .foregroundStyle(.white.opacity(0.6))
                .opacity(tapHintOpacity)
                .padding(.bottom, 50)
            }
        }
        .ignoresSafeArea()
        .onTapGesture {
            triggerExit()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0).delay(0.3)) {
                titleOpacity = 1.0
            }
            withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true).delay(1.0)) {
                tapHintOpacity = 0.8
            }
            // Auto-advance after 2.5s so judges don't get stuck on the splash
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                triggerExit()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(AppState())
}
