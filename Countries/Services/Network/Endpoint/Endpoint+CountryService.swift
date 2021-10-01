//
//  Endpoint+CountryService.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-09-30.
//

import Foundation

extension Endpoint {
    static var all: Endpoint {
        let fields = ["name", "alpha2Code", "capital", "region", "population", "area", "nativeName", "currencies", "languages"]
        return Endpoint(path: "/v2/all", queryParameters: [
            URLQueryItem(name: "fields", value: fields.joined(separator: ","))
        ])
    }
    
    static func getImage(of country: Country, for size: ImageSize) -> Endpoint {
        // ex: https://raw.githubusercontent.com/hampusborgos/country-flags/main/png250px/ad.png
        let path = "/hampusborgos/country-flags/main/png\(size.value)px/\(country.alpha2Code.lowercased()).png"
        return Endpoint(path: path)
    }
}
