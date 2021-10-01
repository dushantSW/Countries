//
//  NetworkClient.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-09-30.
//

import Foundation
import Combine
import UIKit

/// Defines the public interface of the networking layer
protocol NetworkClientProvider {
    
    /// Performs the given network request,
    /// - Parameters:
    ///         - request: Defines all the information about a network request.
    /// - Returns: A publisher with either Decodable Value or Error
    func performRequest<Value: Decodable>(_ request: Request) -> AnyPublisher<Value, Error>
}

class NetworkClient {
    /// Shared instance of the network client. Use this as default.
    static let shared = NetworkClient()
    
    /// Property to make network calls
    private let urlSession: URLSession
    
    /// Initializes a new instance of the client
    ///
    /// - Parameter urlSession: Uses default URLSession
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

extension NetworkClient: NetworkClientProvider {
    func performRequest<Value: Decodable>(_ request: Request) -> AnyPublisher<Value, Error> {
        return urlSession.dataTaskPublisher(for: request.urlRequest)
            .mapError { _ in RequestError.invalidRequest }
            .print()
            .flatMap { data, response -> AnyPublisher<Data, Error> in
                guard let response = response as? HTTPURLResponse else {
                    return .fail(RequestError.unknownError)
                }
                
                guard 200..<300 ~= response.statusCode else {
                    return .fail(RequestError.httpError(response.statusCode))
                }
                return .just(data)
            }
            .decode(type: Value.self, decoder: JSONDecoder())
            .mapError { RequestError.handleError($0) }
            .eraseToAnyPublisher()
    }
}
