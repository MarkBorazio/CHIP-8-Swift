//
//  Keypad.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 25/7/21.
//

import AppKit

class Keypad {
    
    private var key0: Bool = false
    private var key1: Bool = false
    private var key2: Bool = false
    private var key3: Bool = false
    private var key4: Bool = false
    private var key5: Bool = false
    private var key6: Bool = false
    private var key7: Bool = false
    private var key8: Bool = false
    private var key9: Bool = false
    private var keyA: Bool = false
    private var keyB: Bool = false
    private var keyC: Bool = false
    private var keyD: Bool = false
    private var keyE: Bool = false
    private var keyF: Bool = false
    
    init() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let keyValue = event.characters?.first else { return event }
            self?.setKeyPressState(keyValue: keyValue, isPressed: true)
            return event
        }
        
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { [weak self] event in
            guard let keyValue = event.characters?.first else { return event }
            self?.setKeyPressState(keyValue: keyValue, isPressed: false)
            return event
        }
    }
    
    private func setKeyPressState(keyValue: Character, isPressed: Bool) {
        switch(keyValue.uppercased()) {
        case "0": self.key0 = isPressed
        case "1": self.key1 = isPressed
        case "2": self.key2 = isPressed
        case "3": self.key3 = isPressed
        case "4": self.key4 = isPressed
        case "5": self.key5 = isPressed
        case "6": self.key6 = isPressed
        case "7": self.key7 = isPressed
        case "8": self.key8 = isPressed
        case "9": self.key9 = isPressed
        case "A": self.keyA = isPressed
        case "B": self.keyB = isPressed
        case "C": self.keyC = isPressed
        case "D": self.keyD = isPressed
        case "E": self.keyE = isPressed
        case "F": self.keyF = isPressed
        default: break
        }
    }
    
    func getKeyPressState(keyValue: UInt8) -> Bool {
        switch(keyValue) {
        case 0x0: return key0
        case 0x1: return key1
        case 0x2: return key2
        case 0x3: return key3
        case 0x4: return key4
        case 0x5: return key5
        case 0x6: return key6
        case 0x7: return key7
        case 0x8: return key8
        case 0x9: return key9
        case 0xA: return keyA
        case 0xB: return keyB
        case 0xC: return keyC
        case 0xD: return keyD
        case 0xE: return keyE
        case 0xF: return keyF
        default: fatalError()
        }
    }
}
