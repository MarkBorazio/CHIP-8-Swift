//
//  CPU.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 24/7/21.
//

import Foundation

class CPU {
    
    private static let frequencyMicroSeconds: UInt32 = 16667 // 60Hz
    
    // CHIP-8 Components
    private let memory: Memory
    private let keypad: Keypad
    private let video: Video
    private let audio: Audio
    
    // Registers
    private var v: [UInt8] = Array(repeating: 0, count: 16) // V registers
    private var i: UInt16 = 0 // I register
    private var pc: UInt16 = Memory.startingRomAddress // Program Counter
    private var sp: UInt8 = 0 // Stack Pointer
    private var dt: UInt8 = 0 // Delay Timer
    private var st: UInt8 = 0 // Sound Timer
    private var stack: [UInt16] = Array(repeating: 0, count: 16)
    
    // State
    private var registerAwaitingKeyPressValue: UInt8?
    private var isTicking = false
    private var isResetting = false
    
    weak var delegate: CPUDelegate?
    
    init(memory: Memory, video: Video, audio: Audio, keypad: Keypad) {
        self.memory = memory
        self.keypad = keypad
        self.video = video
        self.audio = audio
    }
    
    func startTicking() {
        guard memory.isRomLoaded, !isTicking else { return }
        
        isTicking = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            while self.isTicking {
                self.tick()
                usleep(Self.frequencyMicroSeconds)
            }
            if self.isResetting {
                self.clearStates()
            }
        }
    }
    
    func stopTicking() {
        guard memory.isRomLoaded, isTicking else { return }
        isTicking = false
    }
    
    private func tick() {
        // 9 cycles occur per tick
        cycle()
        cycle()
        cycle()
        cycle()
        cycle()
        cycle()
        cycle()
        cycle()
        cycle()
        
        if dt > 0 {
            dt -= 1
        }
        
        if st > 0 {
            audio.startTone()
            st -= 1
        } else {
            audio.stopTone()
        }
        
        delegate?.draw(pixelArray: video.display)
    }
    
    private func cycle() {
        if let register = registerAwaitingKeyPressValue {
            checkKeyPress(register: register)
        } else {
            executeInstruction()
        }
    }
    
    private func executeInstruction() {
        
        // Read the 2 byte opcode at the PC
        let opcode = memory.readOpcode(address: pc)
        
        incrementProgramCounter()
        
        switch(opcode.z) {
        case 0x0:
            switch(opcode.kk) {
            case 0xE0: clearDisplay()
            case 0xEE: returnFromSubroutine()
            default: print("Unrecognised opcode found. Got: \(opcode.rawOpcodeString)")
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
            default: fatalError("Unrecognised opcode found. Got: \(opcode.rawOpcodeString)")
            }
        case 0x9: skipNextInstructionIfVxNotEqualsVy(x: opcode.x, y: opcode.y)
        case 0xA: setIRegToVal(nnn: opcode.nnn)
        case 0xB: setPcToValPlusV0(nnn: opcode.nnn)
        case 0xC: setVxToRandomByteAndVal(x: opcode.x, kk: opcode.kk)
        case 0xD: draw(x: opcode.x, y: opcode.y, n: opcode.n)
        case 0xE:
            switch(opcode.kk) {
            case 0x9E: skipNextInstructionIfKeyPressed(x: opcode.x)
            case 0xA1: skipNextInstructionIfKeyNotPressed(x: opcode.x)
            default: fatalError("Unrecognised opcode found. Got: \(opcode.rawOpcodeString)")
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
            default: fatalError("Unrecognised opcode found. Got: \(opcode.rawOpcodeString)")
            }
        default: fatalError("Unrecognised opcode found. Got: \(opcode.rawOpcodeString)")
        }
    }
    
    private func checkKeyPress(register: UInt8) {
        let keyPressStates: [UInt8] = Array(0x0...0xF)
        let possibleKeyPressValue = keyPressStates
            .first { keypad.getKeyPressState(keyValue: $0) }
        
        if let keyPressValue = possibleKeyPressValue {
            v[register] = keyPressValue
            registerAwaitingKeyPressValue = nil
        }
    }
    
    private func incrementProgramCounter() {
        pc &+= 2
    }
}

// MARK: - Instruction Functions

extension CPU {
    
    private func clearDisplay() {
        video.clearDisplay()
    }
    
    private func returnFromSubroutine() {
        let address = stack[sp]
        pc = address
        sp -= 1
    }
    
    private func setPcToVal(nnn: UInt16) {
        pc = nnn
    }
    
    private func callSubroutine(nnn: UInt16) {
        sp += 1
        stack[sp] = pc
        pc = nnn
    }
    
    private func skipNextInstructionIfVxEqualsVal(x: UInt8, kk: UInt8) {
        if v[x] == kk {
            incrementProgramCounter()
        }
    }
    
    private func skipNextInstructionIfVxNotEqualsVal(x: UInt8, kk: UInt8) {
        if v[x] != kk {
            incrementProgramCounter()
        }
    }
    
    private func skipNextInstructionIfVxEqualsVy(x: UInt8, y: UInt8) {
        if v[x] == v[y] {
            incrementProgramCounter()
        }
    }
    
    private func setVxToVal(x: UInt8, kk: UInt8) {
        v[x] = kk
    }
    
    private func addValToVx(x: UInt8, kk: UInt8) {
        let vx = v[x]
        v[x] = vx &+ kk
    }
    
    private func setVxToVy(x: UInt8, y: UInt8) {
        v[x] = v[y]
    }
    
    private func setVxToVxOrVy(x: UInt8, y: UInt8) {
        let vx = v[x]
        v[x] = vx | v[y]
    }
    
    private func setVxToVxAndVy(x: UInt8, y: UInt8) {
        let vx = v[x]
        v[x] = vx & v[y]
    }
    
    private func setVxToVxXorVy(x: UInt8, y: UInt8) {
        let vx = v[x]
        v[x] = vx ^ v[y]
    }
    
    private func setVxToVxPlusVy(x: UInt8, y: UInt8) {
        let (value, overflow) = v[x].addingReportingOverflow(v[y])
        v[0xF] = overflow ? 1 : 0
        v[x] = value
    }
    
    private func setVxToVxMinusVy(x: UInt8, y: UInt8) {
        let borrow = v[x] > v[y]
        v[0xF] = borrow ? 1 : 0
        
        let value = v[x] &- v[y]
        v[x] = value
    }
    
    // TODO: Last bit of Vy or Vx???
    private func setVxToVyShiftedRight(x: UInt8, y: UInt8) {
        v[0xF] = v[y] & 0b1
        v[x] = v[y] >> 1
    }
    
    private func setVxToVyMinusVx(x: UInt8, y: UInt8) {
        let borrow = v[y] > v[x]
        v[0xF] = borrow ? 1 : 0
        
        let value = v[y] &- v[x]
        v[x] = value
    }
    
    private func setVxToVyShiftedLeft(x: UInt8, y: UInt8) {
        v[0xF] = v[y] >> 7
        v[x] = v[y] << 1
    }
    
    private func skipNextInstructionIfVxNotEqualsVy(x: UInt8, y: UInt8) {
        if v[x] != v[y] {
            incrementProgramCounter()
        }
    }
    
    private func setIRegToVal(nnn: UInt16) {
        i = nnn
    }
    
    private func setPcToValPlusV0(nnn: UInt16) {
        pc = nnn &+ UInt16(v[0])
    }
    
    private func setVxToRandomByteAndVal(x: UInt8, kk: UInt8) {
        let randomByte = UInt8.random(in: UInt8.min ... UInt8.max)
        v[x] = kk & randomByte
    }
    
    private func draw(x: UInt8, y: UInt8, n: UInt8) {
        let spriteData = (0..<n).map { offset -> UInt8 in
            let index = i + UInt16(offset)
            return memory.data[index]
        }
        
        let xCo = v[x]
        let yCo = v[y]
        let collision = video.drawSpriteReportingCollision(data: spriteData, xCo: xCo, yCo: yCo)
        
        v[0xF] = collision ? 1 : 0
    }
    
    private func skipNextInstructionIfKeyPressed(x: UInt8) {
        let isPressed = keypad.getKeyPressState(keyValue: v[x])
        if isPressed {
            incrementProgramCounter()
        }
    }
    
    private func skipNextInstructionIfKeyNotPressed(x: UInt8) {
        let isPressed = keypad.getKeyPressState(keyValue: v[x])
        if !isPressed {
            incrementProgramCounter()
        }
    }
    
    private func setVxToDt(x: UInt8) {
        v[x] = dt
    }
    
    private func setVxToPressedKeyValue(x: UInt8) {
        registerAwaitingKeyPressValue = x
        checkKeyPress(register: x)
    }
    
    private func setDtToVx(x: UInt8) {
        dt = v[x]
    }
    
    private func setStToVx(x: UInt8) {
        st = v[x]
    }
    
    private func setIRegToIRegPlusVx(x: UInt8) {
        let value = i &+ UInt16(v[x])
        i = value
    }
    
    private func setIRegToAddressOfSpriteForVx(x: UInt8) {
        let spriteValue = v[x]
        let spriteAddress = UInt16(spriteValue * 5)
        i = spriteAddress
    }
    
    private func storeBCDRepresentationOfVx(x: UInt8) {
        memory.data[i] = (v[x] / 100) % 10 // Hundreds digit
        memory.data[i+1] = (v[x] / 10) % 10 // Tens digit
        memory.data[i+2] = v[x] % 10 // Ones digit
    }
    
    private func storeAllVRegistersUpToVx(x: UInt8) {
        (0...x).forEach {
            memory.data[i+UInt16($0)] = v[$0]
        }
    }
    
    private func setAllVRegistersUpToVx(x: UInt8) {
        (0...x).forEach {
            v[$0] = memory.data[i+UInt16($0)]
        }
    }
}

// MARK: - Reset

extension CPU {
    
    func reset() {
        // Need to wait for current tick to complete before clearing anything.
        isTicking = false
        isResetting = true
    }
    
    private func clearStates() {
        isTicking = false
        isResetting = false
        registerAwaitingKeyPressValue = nil
        
        v = Array(repeating: 0, count: 16)
        i = 0
        pc = Memory.startingRomAddress
        sp = 0
        dt = 0
        st = 0
        stack = Array(repeating: 0, count: 16)
        
        video.clearDisplay()
        audio.stopTone()
        memory.reset()
        
        startTicking()
    }
}

protocol CPUDelegate: AnyObject {
    func draw(pixelArray: [[Bool]])
}
