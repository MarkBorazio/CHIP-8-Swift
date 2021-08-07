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
    
    func startTone() {
        Synth.shared.start()
        print("PLAYING TONE")
    }
    
    func stopTone() {
        Synth.shared.stop()
        print("STOPPING TONE")
    }
}
