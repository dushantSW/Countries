//
//  Endpoint.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-09-30.
//

import Foundation

/// The base scheme we will use for making network calls
fileprivate let baseScheme = "https"

struct Endpoint {
    let path: String
    let queryParameters: [URLQueryItem]
    
    init(path: String, queryParameters: [URLQueryItem] = []) {
        self.path = path
        self.queryParameters = queryParameters
    }
}

// MARK: - Endpoint + URL
extension Endpoint {
    func url(withHost host: URLHost = .standard) -> URL {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = host.rawValue
        components.path = path
        
        if !queryParameters.isEmpty {
            components.queryItems = queryParameters
        }
        
        guard let url = components.url else {
            preconditionFailure("Invalid URL components: \(components)")
        }
        
        return url
    }
}
