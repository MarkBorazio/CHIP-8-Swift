//
//  Audio.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 31/7/21.
//

import Foundation
import AudioUnit
import AVFoundation

class Audio {
    
    private var isPlaying = false
    var toneFrequencyHz: Int = 400
    
    func startTone() {
        guard !isPlaying else { return }
        isPlaying = true
        print("PLAYING TONE")
    }
    
    func stopTone() {
        guard isPlaying else { return }
        isPlaying = false
        print("STOPPING TONE")
    }
}
