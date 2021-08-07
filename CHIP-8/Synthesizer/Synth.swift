//
//  Synth.swift
//  Swift Synth
//
//  Created by Mark Borazio [Personal] on 7/8/21.
//

import Foundation
import AVFoundation

// Ref: https://betterprogramming.pub/building-a-synthesizer-in-swift-866cd15b731

class Synth {
    
    static let shared = Synth()
    
    var volume: Float {
        set {
            audioEngine.mainMixerNode.outputVolume = newValue
        }
        get {
            audioEngine.mainMixerNode.outputVolume
        }
    }
    
    private var audioEngine: AVAudioEngine
    private var time: Float = 0
    private let sampleRate: Double
    private let deltaTime: Float
    private var signal: Signal
    
    private lazy var sourceNode: AVAudioSourceNode = AVAudioSourceNode(renderBlock: { _, _, frameCount, audioBufferList -> OSStatus in
        let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
        for frame in 0..<Int(frameCount) {
            let sampleVal = self.signal(self.time)
            self.time += self.deltaTime
            
            for buffer in ablPointer {
                let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                buf[frame] = sampleVal
            }
        }
        return noErr
    })
    
    private init(signal: @escaping Signal = Oscillator.sine) {
        self.signal = signal
        
        audioEngine = AVAudioEngine()
        
        let format = audioEngine.outputNode.inputFormat(forBus: 0)
        sampleRate = format.sampleRate
        deltaTime = 1 / Float(format.sampleRate)

        audioEngine.attach(sourceNode)
        audioEngine.connect(sourceNode, to: audioEngine.mainMixerNode, format: format)
        audioEngine.connect(audioEngine.mainMixerNode, to: audioEngine.outputNode, format: nil)
        volume = 0.1
        
        start()
    }
    
    func setWaveformTo(_ signal: @escaping Signal) {
        self.signal = signal
    }
    
    func start() {
        do {
            try audioEngine.start()
        } catch {
            print("Could not start audio engine: \(error.localizedDescription)")
        }
    }
    
    func stop() {
        audioEngine.stop()
    }
}
