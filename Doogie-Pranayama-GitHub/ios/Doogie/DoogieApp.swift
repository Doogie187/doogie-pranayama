import SwiftUI
import WebKit
import AVFAudio
import UIKit

@main
struct DoogieApp: App {
    private let githubURL = URL(string: "https://doogie187.github.io/doogie-pranayama/")!

    var body: some Scene {
        WindowGroup {
            DoogieWebView(url: githubURL)
                .ignoresSafeArea()
        }
    }
}

struct DoogieWebView: UIViewRepresentable {
    let url: URL

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> WKWebView {
        let contentController = WKUserContentController()
        contentController.add(context.coordinator, name: "doogieNative")

        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.scrollView.bounces = false
        webView.isOpaque = false
        webView.backgroundColor = .black
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url, cachePolicy: .useProtocolCachePolicy))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    final class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        private let audio = DoogieAudioController()

        func userContentController(_ userContentController: WKUserContentController,
                                    didReceive message: WKScriptMessage) {
            guard message.name == "doogieNative",
                  let body = message.body as? [String: Any],
                  let action = body["action"] as? String else { return }

            switch action {
            case "sessionStart":
                audio.beginSession()
                UIApplication.shared.isIdleTimerDisabled = true

            case "sessionPause":
                UIApplication.shared.isIdleTimerDisabled = false
                audio.pauseSpeech()

            case "sessionResume":
                audio.beginSession()
                UIApplication.shared.isIdleTimerDisabled = true

            case "sessionEnd":
                UIApplication.shared.isIdleTimerDisabled = false
                audio.endSession()

            case "speak":
                let text = body["text"] as? String ?? ""
                audio.speak(text)

            default:
                break
            }
        }

        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(.allow)
        }
    }
}

final class DoogieAudioController: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    private let session = AVAudioSession.sharedInstance()

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func beginSession() {
        do {
            try session.setCategory(.playback, mode: .spokenAudio, options: [.mixWithOthers])
            try session.setActive(true)
        } catch {
            print("Doogie audio session error: \(error)")
        }
    }

    func speak(_ text: String) {
        guard !text.isEmpty else { return }
        beginSession()

        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "de-DE")
        utterance.rate = text == "Halten" ? 0.42 : 0.36
        utterance.pitchMultiplier = 1.02
        utterance.volume = 0.22
        synthesizer.speak(utterance)
    }

    func pauseSpeech() {
        if synthesizer.isSpeaking {
            synthesizer.pauseSpeaking(at: .immediate)
        }
    }

    func endSession() {
        if synthesizer.isSpeaking || synthesizer.isPaused {
            synthesizer.stopSpeaking(at: .immediate)
        }
        deactivate()
    }

    func deactivate() {
        do {
            try session.setActive(false, options: [.notifyOthersOnDeactivation])
        } catch {
            print("Doogie audio deactivate error: \(error)")
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didFinish utterance: AVSpeechUtterance) {
        // Let Spotify remain uninterrupted after the short voice prompt.
        deactivate()
    }
}
