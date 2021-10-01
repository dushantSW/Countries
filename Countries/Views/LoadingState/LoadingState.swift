//
//  LoadingState.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-10-01.
//

import Foundation
import UIKit

public enum LoadingState: Equatable {
    case idle, loading, success, failed(error: LocalizedError)
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle),
            (.loading, .loading),
            (.success, .success):
            return true
        case let (.failed(lhsError), .failed(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

// MARK: - UIViewController + LoadingState
extension UIViewController {
    
    /// Convenience method for showing a error message
    /// - Parameter error: LocalizedError
    func displayError(error: LocalizedError) {
        displayAlert(title: "Error", message: error.localizedDescription)
    }
    
    /// Convenience method for showing a generic alert with the given actions.
    /// If no actions given then use a generic OK action to dismiss the alert.
    ///
    /// - Parameters:
    ///   - title: The title to display on the alert
    ///   - message: The message to display on the alert
    ///   - actions: A list of action buttons to display
    ///   - completion: block called on completion
    func displayAlert(title: String, message: String, actions:[UIAlertAction]? = nil, completion: VoidCompletion? = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.view.accessibilityIdentifier = Accessibility.alertTitle(title)
        ac.view.accessibilityLabel = title
        
        if let actions = actions, !actions.isEmpty {
            actions.forEach { ac.addAction($0) }
        } else {
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
        }

        self.present(ac, animated: true, completion: completion)
    }
}
