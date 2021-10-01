//
//  Result+Utils.swift
//  CountriesTests
//
//  Created by Dushant  Singh on 2021-10-01.
//

import Foundation

extension Result {
    var isSuccess: Bool {
        return (try? self.get()) != nil
    }
    
    var error: Error? {
        guard case .failure(let error) = self else { return nil }
        return error
    }
}
