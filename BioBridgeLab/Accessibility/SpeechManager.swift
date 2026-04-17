import AVFoundation
import SwiftUI

// MARK: - Speech Manager
// Wraps AVSpeechSynthesizer to read instruction text aloud when
// the user enables "Read Aloud" in Accessibility Settings.

@Observable
final class SpeechManager: NSObject, AVSpeechSynthesizerDelegate {

    static let shared = SpeechManager()

    nonisolated(unsafe) private let synthesizer = AVSpeechSynthesizer()
    var isSpeaking = false

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    /// Speak the given text, interrupting any currently speaking utterance.
    func speak(_ text: String) {
        guard !text.isEmpty else { return }
        synthesizer.stopSpeaking(at: .immediate)
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate * 0.9   // slightly slower for clarity
        utterance.pitchMultiplier = 1.05
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.preUtteranceDelay = 0.1
        isSpeaking = true
        synthesizer.speak(utterance)
    }

    /// Stop speaking immediately.
    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
    }

    // MARK: - AVSpeechSynthesizerDelegate

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didFinish utterance: AVSpeechUtterance) {
        isSpeaking = false
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didCancel utterance: AVSpeechUtterance) {
        isSpeaking = false
    }
}
