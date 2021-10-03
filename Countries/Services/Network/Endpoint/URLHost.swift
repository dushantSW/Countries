//
//  URLHost.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-10-03.
//

import Foundation

struct URLHost: RawRepresentable {
    var rawValue: String
}

extension URLHost {
    static var standard: Self {
        return URLHost(rawValue: "restcountries.eu")
    }
    
    static var image: Self {
        return URLHost(rawValue: "raw.githubusercontent.com")
    }
}
