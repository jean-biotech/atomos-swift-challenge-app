import SwiftUI

struct ProgressBarView: View {
    var progress: Double
    var color: Color = .dnaTeal
    var height: CGFloat = 8
    var glow: Bool = true

    @State private var animatedProgress: Double = 0

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: height)

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [color, color.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * animatedProgress, height: height)
                    .shadow(color: glow ? color.opacity(0.5) : .clear, radius: 4)
            }
        }
        .frame(height: height)
        .onAppear {
            withAnimation(Anim.standard) {
                animatedProgress = progress
            }
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(Anim.standard) {
                animatedProgress = newValue
            }
        }
    }
}
