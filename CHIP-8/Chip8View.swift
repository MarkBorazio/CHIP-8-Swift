//
//  Chip8View.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 31/7/21.
//

import Cocoa

class Chip8View: NSView {
    
    private static let pixelWidth = 64
    private static let pixelHeight = 32
    private static let size = NSSize(width: pixelWidth, height: pixelHeight)
    
    private let colourSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
    
    var alpha: UInt8 = 0xFF
    var red: UInt8 = 0xA4
    var green: UInt8 = 0x50
    var blue: UInt8 = 0xF0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.wantsLayer = true
        layer?.magnificationFilter = .nearest
    }
    
    private func generatePixelData(isOn: Bool) -> UInt32 {
        guard isOn else { return UInt32() } // Transparent
        return UInt32(bytes: [red, green, blue, alpha])! // rgba
    }
    
    private func constructImage(argbPixels: [UInt32]) -> CGImage? {
        var data = argbPixels
        let context = CGContext(
            data: &data,
            width: Self.pixelWidth,
            height: Self.pixelHeight,
            bitsPerComponent: UInt8.bitWidth,
            bytesPerRow: Self.pixelWidth * MemoryLayout<UInt32>.size,
            space: colourSpace,
            bitmapInfo: bitmapInfo.rawValue
        )
        return context?.makeImage()
    }
}

// MARK: - Chip8Delegate Implementation

extension Chip8View: Chip8Delegate {
    
    func draw(pixelArray: [[Bool]]) {
        DispatchQueue.main.async { [unowned self] in
            let pixels = pixelArray
                .flatMap { $0 }
                .map(generatePixelData)
            let constructedImage = constructImage(argbPixels: pixels)
            layer?.contents = constructedImage
        }
    }
}
