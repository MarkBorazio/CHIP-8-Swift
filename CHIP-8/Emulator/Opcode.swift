//
//  Opcode.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 24/7/21.
//

import Foundation

struct Opcode {
    
    // I just made up this variable name to easily reference the first nibble.
    // The "z" naming convention isn't used in any documentation I found online.
    let z: UInt8

    let nnn: UInt16
    let n: UInt8
    let x: UInt8
    let y: UInt8
    let kk: UInt8
    
    init(rawOpcode: UInt16) {
        z = UInt8((rawOpcode & 0xF000) >> 12)
        
        nnn = UInt16(rawOpcode & 0x0FFF)
        n = UInt8(rawOpcode & 0x000F)
        x = UInt8((rawOpcode & 0x0F00) >> 8)
        y = UInt8((rawOpcode & 0x00F0) >> 4)
        kk = UInt8(rawOpcode & 0x00FF)
    }
}
