//
//  Memory.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 24/7/21.
//

import Foundation

class Memory {
    
    private static let memorySizeBytes = 4096 // 4KB
    static let startingRomAddress: UInt16 = 0x200
    
    var data: [UInt8]
    
    init(rom: ROM) {
        
        data = Array(repeating: 0, count: Self.memorySizeBytes)
        
        // Load sprite data into memory starting at 0x0000
        Self.allSprites
            .flatMap { $0 }
            .enumerated()
            .forEach { (index, value) in
                data[index] = value
            }
        
        // Load ROM data into memory starting at 0x0200
        rom.bytes.enumerated().forEach { (index, value) in
            let offsetIndex = Int(Self.startingRomAddress) + index
            data[offsetIndex] = value
        }
    }
    
    func readOpcode(address: UInt16) -> Opcode {
        let opcodeBytes = [data[address], data[address + 1]]
        let rawOpcode = UInt16(bytes: opcodeBytes, endianness: .bigEndian)!
        return Opcode(rawOpcode: rawOpcode)
    }
}

// MARK: - Font Sprite Data

extension Memory {
    private static let sprite0: [UInt8] = [0xF0, 0x90, 0x90, 0x90, 0xF0]
    private static let sprite1: [UInt8] = [0x20, 0x60, 0x20, 0x20, 0x70]
    private static let sprite2: [UInt8] = [0xF0, 0x10, 0xF0, 0x80, 0xF0]
    private static let sprite3: [UInt8] = [0xF0, 0x10, 0xF0, 0x10, 0xF0]
    private static let sprite4: [UInt8] = [0x90, 0x90, 0xF0, 0x10, 0x10]
    private static let sprite5: [UInt8] = [0xF0, 0x80, 0xF0, 0x10, 0xF0]
    private static let sprite6: [UInt8] = [0xF0, 0x80, 0xF0, 0x90, 0xF0]
    private static let sprite7: [UInt8] = [0xF0, 0x10, 0x20, 0x40, 0x40]
    private static let sprite8: [UInt8] = [0xF0, 0x90, 0xF0, 0x90, 0xF0]
    private static let sprite9: [UInt8] = [0xF0, 0x90, 0xF0, 0x10, 0xF0]
    private static let spriteA: [UInt8] = [0xF0, 0x90, 0xF0, 0x90, 0x90]
    private static let spriteB: [UInt8] = [0xE0, 0x90, 0xE0, 0x90, 0xE0]
    private static let spriteC: [UInt8] = [0xF0, 0x80, 0x80, 0x80, 0xF0]
    private static let spriteD: [UInt8] = [0xE0, 0x90, 0x90, 0x90, 0xE0]
    private static let spriteE: [UInt8] = [0xF0, 0x80, 0xF0, 0x80, 0xF0]
    private static let spriteF: [UInt8] = [0xF0, 0x80, 0xF0, 0x80, 0x80]
    
    private static let allSprites = [
        sprite0,
        sprite1,
        sprite2,
        sprite3,
        sprite4,
        sprite5,
        sprite6,
        sprite7,
        sprite8,
        sprite9,
        spriteA,
        spriteB,
        spriteC,
        spriteD,
        spriteE,
        spriteF
    ]
}
