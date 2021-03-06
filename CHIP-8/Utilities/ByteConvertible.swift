//
//  ByteConvertible.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 24/7/21.
//

import Foundation

// Initialiser for all fixed width integer types (signed and unsigned)
extension FixedWidthInteger {
    
    public init?(bytes: [UInt8], endianness: Endianness = .littleEndian) {
        guard bytes.count <= Self.byteWidth else { return nil }

        let adjustedBytes = endianness.matchesPlatform ? bytes : bytes.reversed()
        let data = Data(adjustedBytes)

        let optionalValue = data.withUnsafeBytes {
            $0.baseAddress?.assumingMemoryBound(to: Self.self).pointee
        }
        guard let value = optionalValue else { return nil }
        self = value
    }
}

// `asBytes` method for unsigned integers
extension UnsignedInteger {
    public func asBytes(endianness: Endianness = .littleEndian) -> [UInt8] {
        let bytes = Array(0 ..< Self.byteWidth)
            .map { $0 * 8 }
            .map { (self >> $0) & 0xFF }
            .map { UInt8($0) }
        return endianness.matchesPlatform ? bytes : bytes.reversed()
    }
}

public enum Endianness {
    case bigEndian
    case littleEndian
    
    var matchesPlatform: Bool {
        switch self {
        case .bigEndian: return CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderBigEndian.rawValue)
        case .littleEndian: return CFByteOrderGetCurrent() == CFByteOrder(CFByteOrderLittleEndian.rawValue)
        }
    }
}

extension BinaryInteger {
    static var byteWidth: Int { MemoryLayout<Self>.size }
}
