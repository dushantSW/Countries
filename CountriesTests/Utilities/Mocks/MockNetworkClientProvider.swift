//
//  MockNetworkClientProvider.swift
//  CountriesTests
//
//  Created by Dushant  Singh on 2021-10-01.
//

import Foundation
import Combine
@testable import Countries

class MockNetworkClientProvider: NetworkClientProvider {
    private let customResponses: [String: Any]
    
    public init(customResponses: [String: Any]) {
        self.customResponses = customResponses
    }
    
    func performRequest<Value>(_ request: Request) -> AnyPublisher<Value, Error> where Value : Decodable {
        if let response = customResponses[request.endpoint.url().path] as? Value {
            return .just(response)
        } else if let networkError = customResponses[request.endpoint.url().path] as? RequestError {
            return .fail(networkError)
        } else {
            return .fail(RequestError.invalidRequest)
        }
    }
}
