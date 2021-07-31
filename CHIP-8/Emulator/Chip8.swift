//
//  Chip8.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 1/8/21.
//

import Foundation

class Chip8 {

    private var memory: Memory
    private var video: Video
    private var audio: Audio
    private var keypad: Keypad
    private var cpu: CPU
    
    weak var delegate: Chip8Delegate?
    
    init() {
        memory = Memory()
        video = Video()
        audio = Audio()
        keypad = Keypad()
        cpu = CPU(memory: memory, video: video, audio: audio, keypad: keypad)
        
        cpu.delegate = self
    }
    
    func loadRomFile(fileName: String) throws {
        let rom = try ROM(fileName: fileName)
        memory.loadRom(rom: rom)
        cpu.startTicking()
    }
    
    func pause() {
        cpu.stopTicking()
    }
    
    func unpause() {
        cpu.startTicking()
    }
    
    func reset() {
        cpu.reset()
    }
    
    func didPressKey(_ key: Keypad.Key) {
        keypad.setKeyPressState(key: key, isPressed: true)
    }
    
    func didReleaseKey(_ key: Keypad.Key) {
        keypad.setKeyPressState(key: key, isPressed: false)
    }
}

// MARK: - CPU Delegate Implementation

extension Chip8: CPUDelegate {
    func draw(pixelArray: [[Bool]]) {
        delegate?.draw(pixelArray: pixelArray)
    }
}

// MARK: - Chip8Delegate Protocol

protocol Chip8Delegate: AnyObject {
    func draw(pixelArray: [[Bool]])
}
