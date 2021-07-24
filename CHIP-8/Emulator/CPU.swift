//
//  CPU.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 24/7/21.
//

import Foundation

class CPU {
    
    var v: [UInt8] = Array(repeating: 0, count: 16) // V registers
    var i: UInt16 = 0 // I register
    var pc: UInt16 = 0 // Program Counter
    var sp: UInt8 = 0 // Stack Pointer
    var dt: UInt8 = 0 // Delay Timer
    var st: UInt8 = 0 // Sound Timer
    
    init() {
        // Set program counter to beginning of ROM
        pc = Memory.startingRomAddress
    }
    
    func cycle(memory: Memory) {
        
        // Read the 2 byte opcode at the PC
        let rawOpcode = memory.readOpcode(address: pc)
        let opcode = Opcode(rawOpcode: rawOpcode)
        
        // Increment PC
        pc += 2
        
        switch(opcode.z) {
        case 0x0:
            switch(opcode.kk) {
            case 0xE0: clearDisplay()
            case 0xEE: returnFromSubroutine()
            default: fatalError("Unrecognised opcode found. Got: \(rawOpcode)")
            }
        case 0x1: setPcToVal(nnn: opcode.nnn)
        case 0x2: callSubroutine(nnn: opcode.nnn)
        case 0x3: skipNextInstructionIfVxEqualsVal(x: opcode.x, kk: opcode.kk)
        case 0x4: skipNextInstructionIfVxNotEqualsVal(x: opcode.x, kk: opcode.kk)
        case 0x5: skipNextInstructionIfVxEqualsVy(x: opcode.x, y: opcode.y) // This doesn't check the last nibble, which should always be 0
        case 0x6: setVxToVal(x: opcode.x, kk: opcode.kk)
        case 0x7: addValToVx(x: opcode.x, kk: opcode.kk)
        case 0x8:
            switch(opcode.n) {
            case 0x0: setVxToVy(x: opcode.x, y: opcode.y)
            case 0x1: setVxToVxOrVy(x: opcode.x, y: opcode.y)
            case 0x2: setVxToVxAndVy(x: opcode.x, y: opcode.y)
            case 0x3: setVxToVxXorVy(x: opcode.x, y: opcode.y)
            case 0x4: setVxToVxPlusVy(x: opcode.x, y: opcode.y)
            case 0x5: setVxToVxMinusVy(x: opcode.x, y: opcode.y)
            case 0x6: setVxToVyShiftedRight(x: opcode.x, y: opcode.y)
            case 0x7: setVxToVyMinusVx(x: opcode.x, y: opcode.y)
            case 0x0E: setVxToVyShiftedLeft(x: opcode.x, y: opcode.y)
            default: fatalError("Unrecognised opcode found. Got: \(rawOpcode)")
            }
        case 0x9: skipNextInstructionIfVxNotEqualsVy(x: opcode.x, y: opcode.y)
        case 0xA: setIRegToVal(nnn: opcode.nnn)
        case 0xB: setPcToValPlusV0(nnn: opcode.nnn)
        case 0xC: setVxToRandomByteAndVal(x: opcode.x)
        case 0xD: draw(x: opcode.x, y: opcode.y, n: opcode.n)
        case 0xE:
            switch(opcode.kk) {
            case 0x9E: skipNextInstructionIfKeyPressed(x: opcode.x)
            case 0xA1: skipNextInstructionIfKeyNotPressed(x: opcode.x)
            default: fatalError("Unrecognised opcode found. Got: \(rawOpcode)")
            }
        case 0xF:
            switch(opcode.kk) {
            case 0x07: setVxToDt(x: opcode.x)
            case 0x0A: setVxToPressedKeyValue(x: opcode.x)
            case 0x15: setDtToVx(x: opcode.x)
            case 0x18: setStToVx(x: opcode.x)
            case 0x1E: setIRegToIRegPlusVx(x: opcode.x)
            case 0x29: setIRegToAddressOfSpriteForVx(x: opcode.x)
            case 0x33: storeBCDRepresentationOfVx(x: opcode.x)
            case 0x55: storeAllVRegistersUpToVx(x: opcode.x)
            case 0x65: setAllVRegistersUpToVx(x: opcode.x)
            default: fatalError("Unrecognised opcode found. Got: \(rawOpcode)")
            }
        default: fatalError("Unrecognised opcode found. Got: \(rawOpcode)")
        }
    }
}

// MARK: - Instruction Functions

extension CPU {
    
    func clearDisplay() {
        
    }
    
    func returnFromSubroutine() {
    
    }
    
    func setPcToVal(nnn: UInt16) {
        
    }
    
    func callSubroutine(nnn: UInt16) {
        
    }
    
    func skipNextInstructionIfVxEqualsVal(x: UInt8, kk: UInt8) {
        
    }
    
    func skipNextInstructionIfVxNotEqualsVal(x: UInt8, kk: UInt8) {
        
    }
    
    func skipNextInstructionIfVxEqualsVy(x: UInt8, y: UInt8) {
        
    }
    
    func setVxToVal(x: UInt8, kk: UInt8) {
        
    }
    
    func addValToVx(x: UInt8, kk: UInt8) {
        
    }
    
    func setVxToVy(x: UInt8, y: UInt8) {
        
    }
    
    func setVxToVxOrVy(x: UInt8, y: UInt8) {
        
    }
    
    func setVxToVxAndVy(x: UInt8, y: UInt8) {
        
    }
    
    func setVxToVxXorVy(x: UInt8, y: UInt8) {
        
    }
    
    func setVxToVxPlusVy(x: UInt8, y: UInt8) {
        
    }
    
    func setVxToVxMinusVy(x: UInt8, y: UInt8) {
        
    }
    
    func setVxToVyShiftedRight(x: UInt8, y: UInt8) {
        
    }
    
    func setVxToVyMinusVx(x: UInt8, y: UInt8) {
        
    }
    
    func setVxToVyShiftedLeft(x: UInt8, y: UInt8) {
        
    }
    
    func skipNextInstructionIfVxNotEqualsVy(x: UInt8, y: UInt8) {
        
    }
    
    func setIRegToVal(nnn: UInt16) {
        
    }
    
    func setPcToValPlusV0(nnn: UInt16) {
        
    }
    
    func setVxToRandomByteAndVal(x: UInt8) {
        
    }
    
    func draw(x: UInt8, y: UInt8, n: UInt8) {
        
    }
    
    func skipNextInstructionIfKeyPressed(x: UInt8) {
        
    }
    
    func skipNextInstructionIfKeyNotPressed(x: UInt8) {
        
    }
    
    func setVxToDt(x: UInt8) {
        
    }
    
    func setVxToPressedKeyValue(x: UInt8) {
        
    }
    
    func setDtToVx(x: UInt8) {
        
    }
    
    func setStToVx(x: UInt8) {
        
    }
    
    func setIRegToIRegPlusVx(x: UInt8) {
        
    }
    
    func setIRegToAddressOfSpriteForVx(x: UInt8) {
        
    }
    
    func storeBCDRepresentationOfVx(x: UInt8) {
        
    }
    
    func storeAllVRegistersUpToVx(x: UInt8) {
        
    }
    
    func setAllVRegistersUpToVx(x: UInt8) {
        
    }
}
