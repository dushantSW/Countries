//
//  CountryDetailsViewModel.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-09-30.
//

import Foundation

struct CountryDetailsViewModel {
    private let country: Country
    
    let nonSymbolNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = ""
        numberFormatter.maximumFractionDigits = 0
        return numberFormatter
    }()
    
    init(country: Country) {
        self.country = country
    }
    
    /// Returns name of the country
    var countryName: String {
        return country.name
    }
    
    /// Returns alpha 3 code of the country
    var alphaCode: String {
        return "(\(country.alpha3Code))"
    }
    
    /// Returns if the country has area information
    var hasAreaInfo: Bool {
        return country.area != nil
    }
    
    /// Returns the native name of the country
    var nativeName: String {
        return country.nativeName
    }
    
    /// Returns the capital of the country
    var capital: String {
        return country.capital
    }
    
    /// Returns the flag image url. Default: Largest size
    var imageURL: URL {
        return country.imageURL(of: .large)
    }
    
    /// Returns the area in string
    var area: String? {
        guard let area = country.area else {
            return nil
        }
        
        guard let fmArea = nonSymbolNumberFormatter.string(for: area) else {
            return nil
        }
        
        return "\(fmArea) sq.km"
    }
    
    var currencies: String {
        return country.currencies.compactMap { $0.name }.joined(separator: ", ")
    }
    
    var languages: String {
        return country.languages.compactMap { $0.name }.joined(separator: ", ")
    }
    
    /// Returns the region and subregion in a populated format
    var region: String {
        return "\(country.region), \(country.subregion)"
    }
    
    /// Returns the population counted in million or thousands
    var population: String? {
        return nonSymbolNumberFormatter.string(for: country.population)
    }
}
