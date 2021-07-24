//
//  Memory.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 24/7/21.
//

import Foundation

class Memory {
    
    private static let memorySizeBytes = 4906
    static let startingRomAddress: UInt16 = 0x200
    
    private let data: [UInt8]
    
    init(path: String) {
        
        // TODO: Get data and convert into bytes
//        let romData = Data()
        let romBytes: [UInt8] = []
        
        var data: [UInt8] = Array(repeating: 0, count: Self.memorySizeBytes)
        for i in 0...romBytes.count {
            data[Self.startingRomAddress + i] = romBytes[i]
        }
        
        self.data = data
    }
    
    func readOpcode(address: UInt16) -> UInt16 {
        let addressBytes = address.asBytes()
        let opcodeBytes = addressBytes.map { data[$0] }
        return UInt16(bytes: opcodeBytes)!
    }
}
