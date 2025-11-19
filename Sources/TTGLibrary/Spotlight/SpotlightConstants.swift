//
//  SpotlightConstants.swift
//  Spotlight
//
//  Created by Tre Cooper on 6/3/23.
//

import SwiftUI

/// An enum housing constants for the spotlight feature.
enum SpotlightConstants {
    enum Strings {
        static let dismiss = NSLocalizedString("skip", comment: "") // L10n.General.skip
        static let next = NSLocalizedString("next", comment: "") // L10n.General.next
    }
    
    enum Assets {
        enum Keys {
            // Colors
            static let dimColor = "SLDimColor"
            static let highlightColor = "SLHighlightColor"
            static let primaryBackgroundColor = "SLPrimaryBackgroundColor"
        }
        
        enum Colors {
            static let dimColor = Color(Keys.dimColor)
            static let highlight = Color(Keys.highlightColor)
            static let primaryBackground = Color(Keys.primaryBackgroundColor)
        }
    }
}
