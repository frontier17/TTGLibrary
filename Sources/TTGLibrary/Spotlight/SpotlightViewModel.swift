//
//  SpotlightViewModel.swift
//  SpotlightTest
//
//  Created by Tre Cooper on 1/25/23.
//

import Combine
import Foundation

/// An object representing the state of a spotlight view.
class SpotlightViewModel: ObservableObject {
    @Published private(set) var target: Spotlight.Element?
    
    var cancellable: Bool { spotlight?.cancellable ?? true }
    var isActive: Bool { target != nil }
    
    private var pointer = Int.zero
    private var sink: AnyCancellable?
    private var spotlight: Spotlight?
    
    init<T: Publisher>(
        publisher: T
    ) where T.Output == Spotlight?, T.Failure == Never {
        self.sink = publisher.sink(receiveValue: setSpotlight)
    }
    
    /// Routine to end the current spotlight sequence by setting the
    /// intended target to `nil`.
    func targetNone() {
        NotificationCenter.default.post(name: NSNotification.spotliteSkip, object: nil, userInfo: ["key": target?.key as Any])
        target = nil
    }
    
    /// Routine to target the next element in the spotlight sequence.
    ///
    /// - note: Ends the sequence if targeting the final element.
    func targetNext() {
        let elements = spotlight?.elements
        let element = elements?[safe: pointer]
        
        if element != nil {
            pointer += 1
        }

        if elements != nil && element == nil {
            NotificationCenter.default.post(name: NSNotification.spotliteDone, object: nil, userInfo: ["key": target?.key as Any])
            print("end")
        }

        target = element
    }
}

// MARK: - Helper Functions / Routines

extension SpotlightViewModel {
    private func setSpotlight(_ spotlight: Spotlight?) {
        self.spotlight = spotlight
        pointer = .zero
        
        targetNext()
    }
}

/// Convenience extension for Collection helper functions and routines.
private extension Collection {
    /// A subscript to safely index the receiving collection.
    ///
    /// - parameter index: The index to query.
    /// - returns: The element at the given index or `nil`
    ///            if the index is invalid.
    subscript(safe index: Index) -> Element? {
        let inRange = index >= startIndex && index < endIndex
        return !isEmpty && inRange ? self[index] : nil
    }
}
