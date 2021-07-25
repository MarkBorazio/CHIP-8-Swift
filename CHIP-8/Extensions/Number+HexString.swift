//
//  Number+HexString.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 26/7/21.
//

import Foundation

// There is probably a better way to do this rather than define the extension on all type individually.
extension UInt8 {
    
    func asHexString() -> String {
        "0x\(String(format:"%02X", self))"
    }
}

extension UInt16 {
    
    func asHexString() -> String {
        "0x\(String(format:"%02X", self))"
    }
}
