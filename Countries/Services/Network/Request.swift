//
//  Request.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-09-30.
//

import Foundation

/// Defines when the time out occurs if service is down or slow.
fileprivate let requestTimeoutInterval: TimeInterval = 30

/// A typealias for better readability of headers
typealias HTTPHeaders = [String: String]

/// Defines all the HTTP method that are available
/// for network processing.
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ContentType {
    case json, xml
    case other(code: String)
    
    var value: String {
        switch self {
        case .json: return "application/json"
        case .xml: return "application/xml"
        case .other(let code): return code
        }
    }
}

/// Defines the structure of a network request
struct Request {
    let endpoint: Endpoint
    let method: HTTPMethod
    let contentType: ContentType
    let body: Data?
    let headers: HTTPHeaders?
    
    /// Creates a new URLRequest from the endpoint and other information
    /// stored in this request
    var urlRequest: URLRequest {
        var urlRequest = URLRequest(
            url: endpoint.url(withHost: .standard),
            cachePolicy: .returnCacheDataElseLoad,
            timeoutInterval: requestTimeoutInterval
        )
        urlRequest.httpMethod = method.rawValue
        urlRequest.httpBody = body
        urlRequest.allHTTPHeaderFields = headers
        return urlRequest
    }
    
    /// Creates a new instance of Request
    ///
    /// - Parameters:
    ///   - endpoint: Endpoint that defines the path & query parameters
    ///   - method: HTTPMethod. Default = "GET"
    ///   - contentType: ContentType = "JSON"
    ///   - body: Data containing byte code of the actual content type.
    ///   - headers: A string array for headers.
    init(with endpoint: Endpoint, method: HTTPMethod = .get, contentType: ContentType = .json,
         body: Data? = nil, headers: HTTPHeaders? = nil) {
        self.endpoint = endpoint
        self.method = method
        self.contentType = contentType
        self.body = body
        self.headers = headers
    }
}
