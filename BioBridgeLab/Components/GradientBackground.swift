import SwiftUI

struct GradientBackground: View {
    var colors: [Color] = [.primaryGradientStart, .primaryGradientEnd]
    var startPoint: UnitPoint = .top
    var endPoint: UnitPoint = .bottom

    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: startPoint,
            endPoint: endPoint
        )
        .ignoresSafeArea()
    }
}

struct LabBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.93, green: 0.87, blue: 0.98),  // soft purple
                Color(red: 0.85, green: 0.93, blue: 0.98),  // soft blue
                Color(red: 0.98, green: 0.93, blue: 0.90),  // warm peach
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}
