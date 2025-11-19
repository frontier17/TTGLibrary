//
//  Spotlight.swift
//  SpotlightTest
//
//  Created by Tre Cooper on 1/25/23.
//

import struct CoreGraphics.CGFloat

/// A struct modeling a spotlight sequence.
public struct Spotlight {
    let elements: [Element]
    let cancellable: Bool
    
    /// A struct modeling an individual element within a
    /// spotlight sequence.
    public struct Element: Equatable {
        public typealias Key = String
        
        let key: Key
        let message: String
        
        /// An enum representing the possible focus shapes
        /// a spotlight element can have.
        public enum Shape {
            case circle
            case rectangle(_ cornerRadius: CGFloat = 3)
        }
    }
}
