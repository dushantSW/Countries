//
//  MockCountryServiceProvider.swift
//  CountriesTests
//
//  Created by Dushant  Singh on 2021-10-01.
//

import Foundation
import Combine
@testable import Countries

class MockCountryServiceProvider: CountryServiceProvider {
    private let countries: [Country]?
    private let error: Error?
    
    private(set) var numberOfTimesCalled = 0
    
    init(countries: [Country]? = nil, error: Error? = nil) {
        self.countries = countries
        self.error = error
    }
    
    func fetchAllCountries() -> AnyPublisher<Result<[Country], Error>, Never> {
        // Increment number of times called
        numberOfTimesCalled += 1
        
        // Return response depending on the saved values
        if let countries = countries {
            return .just(.success(countries))
        }
        if let error = error {
            return .just(.failure(error))
        }
        return .just(.failure(RequestError.unknownError))
    }
}
