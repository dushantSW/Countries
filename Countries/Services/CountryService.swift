//
//  CountryService.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-09-30.
//

import Foundation
import Combine

/// Defines the country service and it's functions
protocol CountryServiceProvider {
    
    /// Fetches a list of all the country.
    /// - Returns: An array of Country or Error in a Result enum.
    func fetchAllCountries() -> AnyPublisher<Result<[Country], Error>, Never>
}

class CountryService: CountryServiceProvider {
    static let shared = CountryService()
    
    private let client: NetworkClientProvider
    
    /// Initializes a new instance with the given network client
    /// - Parameter client: NetworkClientProvider. Default: shared instance of NetworkClient
    init(with client: NetworkClientProvider = NetworkClient.shared) {
        self.client = client
    }
    
    // MARK: - Provider functions
    func fetchAllCountries() -> AnyPublisher<Result<[Country], Error>, Never> {
        return client.performRequest(Request(with: .all))
            .map { .success($0) }
            .catch { error -> AnyPublisher<Result<[Country], Error>, Never> in .just(.failure(error)) }
            .subscribe(on: Scheduler.background)
            .receive(on: Scheduler.main)
            .eraseToAnyPublisher()
    }
}
