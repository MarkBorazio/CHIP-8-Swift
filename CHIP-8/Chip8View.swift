//
//  Chip8View.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 31/7/21.
//

import Cocoa

class Chip8View: NSImageView {
    
    private static let pixelWidth = 64
    private static let pixelHeight = 32
    private static let size = NSSize(width: pixelWidth, height: pixelHeight)
    
    private let colourSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue)
    
    var alpha: UInt8 = 0xFF
    var red: UInt8 = 0xFF
    var green: UInt8 = 0xFF
    var blue: UInt8 = 0xFF
    
    private func generatePixelData(isOn: Bool) -> UInt32 {
        guard isOn else { return UInt32() } // Transparent
        return UInt32(bytes: [0xFF, red, green, blue])! // argb
    }
    
    private func constructImage(argbPixels: [UInt32]) -> NSImage? {
        var data = argbPixels
        guard let providerRef = CGDataProvider(data: Data(bytes: &data, count: data.count * MemoryLayout<UInt32>.size) as CFData) else { return nil }
        guard let cgImage = CGImage(
            width: Self.pixelWidth,
            height: Self.pixelHeight,
            bitsPerComponent: UInt8.bitWidth,
            bitsPerPixel: UInt32.bitWidth,
            bytesPerRow: Self.pixelWidth * MemoryLayout<UInt32>.size,
            space: colourSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef,
            decode: nil,
            shouldInterpolate: false,
            intent: .defaultIntent
        )
        else { return nil }
        
        return NSImage(cgImage: cgImage, size: Self.size)
    }
}

// MARK: - Chip8Delegate Implementation

extension Chip8View: Chip8Delegate {
    
    func draw(pixelArray: [[Bool]]) {
        let pixels = pixelArray
            .flatMap { $0 }
            .map(generatePixelData)
        DispatchQueue.main.async { [unowned self] in
            let constructedImage = constructImage(argbPixels: pixels)
            self.image = constructedImage
        }
    }
}
