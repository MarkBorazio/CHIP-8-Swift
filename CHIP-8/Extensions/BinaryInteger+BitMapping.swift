//
//  BinaryInteger+BitMapping.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 25/7/21.
//

import Foundation

extension BinaryInteger {

    /// Return an array of booleans mapped to each bit.
    ///
    ///     let value: UInt8 = 37 // 00100101
    ///     print(value.asBigEndianBoolArray) // [true, false, true, false, false, true, false, false]
    var asBoolArray: [Bool] {
        return Array(0 ..< bitWidth)
            .map { 1 << $0 } // Map to bit mask
            .map { ($0 & self) != 0 } // Apply mask and map to bool
            .reversed()
    }
}
