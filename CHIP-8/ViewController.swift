//
//  ViewController.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 24/7/21.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var chip8View: Chip8View!
    
    
    let chip8 = Chip8()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chip8.delegate = chip8View
        
        try! chip8.loadRomFile(fileName: "GUESS")
        
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            self.keyPressed(with: event)
            return nil
        }
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { event in
            self.keyReleased(with: event)
            return nil
        }
    }
    
    @IBAction func startPressed(_ sender: Any) {
        chip8.unpause()
    }
    
    @IBAction func stopPressed(_ sender: Any) {
        chip8.pause()
    }
    
    @IBAction func resetPressed(_ sender: Any) {
        chip8.reset()
    }
    
    private func keyPressed(with event: NSEvent) {
        guard let keyValue = event.characters?.first else { return }
        switch(keyValue.uppercased()) {
        case "0": chip8.didPressKey(.zero)
        case "1": chip8.didPressKey(.one)
        case "2": chip8.didPressKey(.two)
        case "3": chip8.didPressKey(.three)
        case "4": chip8.didPressKey(.four)
        case "5": chip8.didPressKey(.five)
        case "6": chip8.didPressKey(.six)
        case "7": chip8.didPressKey(.seven)
        case "8": chip8.didPressKey(.e)
        case "9": chip8.didPressKey(.nine)
        case "A": chip8.didPressKey(.a)
        case "B": chip8.didPressKey(.b)
        case "C": chip8.didPressKey(.c)
        case "D": chip8.didPressKey(.d)
        case "E": chip8.didPressKey(.e)
        case "F": chip8.didPressKey(.f)
        default: break
        }
    }
    
    private func keyReleased(with event: NSEvent) {
        guard let keyValue = event.characters?.first else { return }
        switch(keyValue.uppercased()) {
        case "0": chip8.didReleaseKey(.zero)
        case "1": chip8.didReleaseKey(.one)
        case "2": chip8.didReleaseKey(.two)
        case "3": chip8.didReleaseKey(.three)
        case "4": chip8.didReleaseKey(.four)
        case "5": chip8.didReleaseKey(.five)
        case "6": chip8.didReleaseKey(.six)
        case "7": chip8.didReleaseKey(.seven)
        case "8": chip8.didReleaseKey(.e)
        case "9": chip8.didReleaseKey(.nine)
        case "A": chip8.didReleaseKey(.a)
        case "B": chip8.didReleaseKey(.b)
        case "C": chip8.didReleaseKey(.c)
        case "D": chip8.didReleaseKey(.d)
        case "E": chip8.didReleaseKey(.e)
        case "F": chip8.didReleaseKey(.f)
        default: break
        }
    }
}
