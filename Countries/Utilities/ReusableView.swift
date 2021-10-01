//
//  ReusableView.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-10-01.
//

import Foundation
import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
