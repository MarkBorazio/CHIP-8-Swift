//
//  Oscillator.swift
//  Swift Synth
//
//  Created by Mark Borazio [Personal] on 7/8/21.
//

import Foundation

typealias Signal = (Float) -> Float

struct Oscillator {
    
    static var amplitude: Float = 1
    static var frequency: Float = 440
    
    static let sine: Signal = { (time: Float) -> Float in
       sin(2 * .pi * frequency * time) * amplitude
    }
    
    static let triangle: Signal = { (time: Float) -> Float in
        let period = 1 / Double(frequency)
        let currentTime = fmod(Double(time), period)
        let value = currentTime / period
        
        var result = 0.0
        if value < 0.25 {
            result = value * 4
        } else if value < 0.75 {
            result = 2 - (value * 4)
        } else {
            result = (value * 4) - 4
        }
        
        return amplitude * Float(result)
     }
    
    static let sawtooth: Signal = { (time: Float) -> Float in
        let period = 1 / Double(frequency)
        let currentTime = fmod(Double(time), period)
        return amplitude * Float(((currentTime / period) * 2) - 1)
     }
    
    static let square: Signal = { (time: Float) -> Float in
        let period = 1 / Double(frequency)
        let currentTime = fmod(Double(time), period)
        return ((currentTime / period) < 0.5) ? amplitude : -amplitude
     }
    
    static let whiteNoise: Signal = { (time: Float) -> Float in
        amplitude * .random(in: -1...1)
     }
}
