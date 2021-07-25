//
//  Video.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 25/7/21.
//

import Foundation

class Video {
    
    var display: [[Bool]]
    
    init() {
        display = Self.blankDisplay
    }
    
    /// Returns true if there was a collision
    func drawSpriteReportingCollision(data: [UInt8], xCo: UInt8, yCo: UInt8) -> Bool {
        let boolData = data.map { $0.asBoolArray }
        let spriteWidth = boolData[0].count
        let spriteHeight = boolData.count
        
        var collisionDetected = false
        
        for spriteY in 0..<spriteHeight {
            let wrappedY = Self.wrappedCoordinate(spriteCoord: spriteY, originCoord: Int(yCo), coordBound: Self.height)
    
            for spriteX in 0..<spriteWidth {
                let wrappedX = Self.wrappedCoordinate(spriteCoord: spriteX, originCoord: Int(xCo), coordBound: Self.width)
                
                let currentValue = display[wrappedY][wrappedX]
                let newValue = currentValue != boolData[spriteY][spriteX]
                
                collisionDetected = collisionDetected || (currentValue && !newValue)
                display[wrappedY][wrappedX] = newValue
            }
        }
        
        return collisionDetected
    }
    
    func clearDisplay() {
        display = Self.blankDisplay
    }
    
    private static func wrappedCoordinate(spriteCoord: Int, originCoord: Int, coordBound: Int) -> Int {
        let screenCoord = spriteCoord + originCoord
        let shouldWrap = screenCoord > (coordBound - 1)
        let wrappedCoord = shouldWrap ? ((screenCoord) % (coordBound - 1)) : screenCoord
        return wrappedCoord
    }
}

// MARK: - Convenience

extension Video {
    
    private static let width = 64
    private static let height = 32
    
    private static let blankDisplay: [[Bool]] = {
        let row: [Bool] = Array(repeating: false, count: width)
        return Array(repeating: row, count: height)
    }()
}
