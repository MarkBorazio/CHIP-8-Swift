//
//  ViewController.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 24/7/21.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var imageView: NSImageView!
    
    let cpu = CPU()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        cpu.crappyDelegate = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func startPressed(_ sender: Any) {
        cpu.startTicking()
    }
    
    @IBAction func stopPressed(_ sender: Any) {
        cpu.stopTicking()
    }
}

extension ViewController: CrappyDelegate {
    func draw(pixels: [[Bool]]) {
        let actualPixels = pixels
            .flatMap { $0 }
            .map { !$0 ? Pixel.white : Pixel.transparent }
        let image = NSImage(pixels: actualPixels, width: pixels[0].count, height: pixels.count)
        DispatchQueue.main.async { [weak self] in
            self?.imageView.image = image
        }
    }
}

public struct Pixel {
    var a,r,g,b: UInt8
    
    static let white = Pixel(a: 0x00, r: 0xFF, g: 0xFF, b: 0xFF)
    static let transparent = Pixel(a: 0xFF, r: 0xFF, g: 0xFF, b: 0xFF)
}

extension NSImage {
    convenience init?(pixels: [Pixel], width: Int, height: Int) {
        guard width > 0 && height > 0, pixels.count == width * height else { return nil }
        var data = pixels
        guard let providerRef = CGDataProvider(data: Data(bytes: &data, count: data.count * MemoryLayout<Pixel>.size) as CFData)
            else { return nil }
        guard let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: width * MemoryLayout<Pixel>.size,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        )
        else { return nil }
        self.init(cgImage: cgim, size: NSSize(width: width, height: height))
    }
}
