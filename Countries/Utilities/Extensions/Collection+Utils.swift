//
//  Collection+Utils.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-09-30.
//

import Foundation

extension Collection {
    /// Returns the element for the given index safely,
    /// if the index is not found then nil.
    ///
    /// - Parameter index: Index
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}


extension Array {
    /// Returns the element for the given index safely,
    /// if the index is not found then nil.
    ///
    /// - Parameter index: Index
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
