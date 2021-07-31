//
//  ROM.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 26/7/21.
//

import Foundation

struct ROM {
    
    let bytes: [UInt8]
    
    init(fileName: String) throws {
        let url = Bundle.main.url(forResource: fileName, withExtension: nil)!
        let romData = try Data(contentsOf: url)
        bytes = [UInt8](romData)
    }
}
