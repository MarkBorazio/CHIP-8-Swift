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
    
    func setKeyPressState(key: Key, isPressed: Bool) {
        switch(key) {
        case .zero: self.key0 = isPressed
        case .one: self.key1 = isPressed
        case .two: self.key2 = isPressed
        case .three: self.key3 = isPressed
        case .four: self.key4 = isPressed
        case .five: self.key5 = isPressed
        case .six: self.key6 = isPressed
        case .seven: self.key7 = isPressed
        case .eight: self.key8 = isPressed
        case .nine: self.key9 = isPressed
        case .a: self.keyA = isPressed
        case .b: self.keyB = isPressed
        case .c: self.keyC = isPressed
        case .d: self.keyD = isPressed
        case .e: self.keyE = isPressed
        case .f: self.keyF = isPressed
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

// MARK: - Keys

extension Keypad {
    
    enum Key: Character {
        case zero = "0"
        case one = "1"
        case two = "2"
        case three = "3"
        case four = "4"
        case five = "5"
        case six = "6"
        case seven = "7"
        case eight = "8"
        case nine = "9"
        case a = "A"
        case b = "B"
        case c = "C"
        case d = "D"
        case e = "E"
        case f = "F"
    }
}
