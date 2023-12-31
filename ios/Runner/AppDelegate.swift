import UIKit
import Flutter
import AVFoundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      if let registrar = self.registrar(forPlugin: "SwiftFlutterMethodChannelHandler") {
          SwiftFlutterMethodChannelHandler.register(with: registrar)
      }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

public class SwiftFlutterMethodChannelHandler: NSObject, FlutterPlugin {
    private var audioEngine: AVAudioEngine?
    private var playerNode: AVAudioPlayerNode?
    private let sampleRate: Double = 44100 // Example sample rate

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "htw.berlin.de/public_health/binaural_beats", binaryMessenger: registrar.messenger())
        let instance = SwiftFlutterMethodChannelHandler()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "playBinauralBeat":
            if let args = call.arguments as? [String: Double],
               let frequencyLeft = args["frequencyLeft"],
               let frequencyRight = args["frequencyRight"],
               let duration = args["duration"] {
                stopAudio() // Stop the existing audio engine and player node
                generateAndPlayTone(frequencyLeft: frequencyLeft, frequencyRight: frequencyRight, duration: duration)
                result(true)
            } else {
                result(FlutterError(code: "INVALID_PARAMETERS", message: "Invalid parameters for playBinauralBeat", details: nil))
            }
        case "stopBinauralBeat":
            stopAudio()
            result(true)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func stopAudio() {
        playerNode?.stop()
        audioEngine?.stop()
        audioEngine?.reset()
        playerNode = nil
        audioEngine = nil
    }


    private func generateAndPlayTone(frequencyLeft: Double, frequencyRight: Double, duration: Double) {
        audioEngine = AVAudioEngine()
        playerNode = AVAudioPlayerNode()
        audioEngine?.attach(playerNode!)

        let audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 2)
        audioEngine?.connect(playerNode!, to: audioEngine!.mainMixerNode, format: audioFormat!)

        let numSamples = Int(sampleRate * duration)
        let pcmBuffer = generateStereoSinWave(numSamples: numSamples, frequencyLeft: frequencyLeft, frequencyRight: frequencyRight, audioFormat: audioFormat!)

        // Schedule buffer on AVAudioPlayerNode
        playerNode?.scheduleBuffer(pcmBuffer, at: nil, options: .interrupts, completionHandler: nil)

        try? audioEngine?.start()
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        playerNode?.play()
    }

    private func generateStereoSinWave(numSamples: Int, frequencyLeft: Double, frequencyRight: Double, audioFormat: AVAudioFormat) -> AVAudioPCMBuffer {
        let pcmBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: AVAudioFrameCount(numSamples))!
        let leftChannel = pcmBuffer.floatChannelData![0]
        let rightChannel = pcmBuffer.floatChannelData![1]

        for i in 0..<numSamples {
            let sampleLeft = sin(2.0 * .pi * frequencyLeft * Double(i) / sampleRate)
            let sampleRight = sin(2.0 * .pi * frequencyRight * Double(i) / sampleRate)

            leftChannel[i] = Float(sampleLeft)
            rightChannel[i] = Float(sampleRight)
        }

        pcmBuffer.frameLength = AVAudioFrameCount(numSamples)
        return pcmBuffer
    }
}
