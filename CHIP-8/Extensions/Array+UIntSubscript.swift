//
//  Array+UIntSubscript.swift
//  CHIP-8
//
//  Created by Mark Borazio [Personal] on 25/7/21.
//

import Foundation

extension Array {

    subscript<T: UnsignedInteger>(index: T) -> Element {
        get {
            self[Int(index)]
        }
        set {
            self[Int(index)] = newValue
        }
    }
}
