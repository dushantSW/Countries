//
//  AccessibilityConstants.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-10-01.
//

import Foundation

struct Accessibility {
    static func alertTitle(_ title: String) -> String {
        return "alert.title.\(title.lowercased().split(separator: " ").joined(separator: "."))"
    }
}
