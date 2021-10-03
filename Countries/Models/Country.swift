//
//  Country.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-09-30.
//

import Foundation

enum ImageSize {
    case small, medium, large
    
    var value: Int {
        switch self {
        case .small:
            return 100
        case .medium:
            return 250
        case .large:
            return 1000
        }
    }
}

struct Country: Codable {
    let name: String
    let nativeName: String
    let alpha2Code: String
    let alpha3Code: String
    let capital: String
    let region: String
    let subregion: String
    let population: Int
    let area: Double?
    let currencies: [Currency]
    let languages: [Language]
    
    func imageURL(of size: ImageSize = .medium) -> URL {
        return Endpoint.getImage(of: self, for: size).imageUrl
    }
}
