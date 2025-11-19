// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

enum ViewVisibility: CaseIterable {
    case visible, // view is fully visible
         invisible, // view is hidden but takes up space
         gone // view is fully removed from the view hierarchy
}

enum Utils {
    static var isRightToLeft: Bool {
        Locale.current.languageCode == "ar"
    }
}

extension NSNotification {
    static let spotliteSkip = Notification.Name("spotliteSkip")
    static let spotliteDone = Notification.Name("spotliteDone")
}

extension View {
    @ViewBuilder func visibility(_ visibility: ViewVisibility) -> some View {
        if visibility != .gone {
            if visibility == .visible {
                self
            } else {
                hidden()
            }
        }
    }

    @ViewBuilder func visible(by value: Any?) -> some View {
        if value != nil {
            self
        }
    }

    @ViewBuilder func visible(by value: Bool) -> some View {
        if value {
            self
        }
    }

    @ViewBuilder func `if`(_ condition: Bool, transform: (Self) -> some View) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    func onTap(_ tap: @escaping () -> Void) -> some View {
        contentShape(Rectangle()).onTapGesture(perform: tap)
    }
}
