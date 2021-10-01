//
//  Endpoint.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-09-30.
//

import Foundation

/// The base scheme we will use for making network calls
fileprivate let baseScheme = "https"

/// Host name of the api we will use for the application.
fileprivate let baseHost = "restcountries.com"

/// Image storage host image of the api
fileprivate let imageHost = "raw.githubusercontent.com"

fileprivate enum EndpointType {
    case base, image
    
    var hostName: String {
        switch self {
        case .base: return baseHost
        case .image: return imageHost
        }
    }
}

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
    var url: URL {
        return constructURL()
    }
    
    var imageUrl: URL {
        return constructURL(by: .image)
    }
    
    private func constructURL(by type: EndpointType = .base) -> URL {
        var components = URLComponents()
        components.scheme = baseScheme
        components.host = type.hostName
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
