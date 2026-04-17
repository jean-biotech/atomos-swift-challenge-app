import SwiftUI

enum Anim {
    static let standard: Animation = .easeInOut(duration: 0.6)
    static let spring: Animation = .spring(response: 0.6, dampingFraction: 0.8)
    static let slow: Animation = .easeInOut(duration: 1.5)
    static let fast: Animation = .easeInOut(duration: 0.3)
    static let bouncy: Animation = .spring(response: 0.4, dampingFraction: 0.6)

    static let standardDuration: Double = 0.6
    static let slowDuration: Double = 1.5
    static let fastDuration: Double = 0.3

    // Explorer scene
    static let sceneTransition: Animation = .easeInOut(duration: 1.0)
    static let cameraMove: Animation = .easeInOut(duration: 1.5)
    static let characterWalkDuration: Double = 2.0
    static let infoCardSlide: Animation = .spring(response: 0.5, dampingFraction: 0.8)
}
