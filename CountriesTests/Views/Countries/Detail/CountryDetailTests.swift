//
//  CountryDetailTests.swift
//  CountriesTests
//
//  Created by Dushant  Singh on 2021-10-03.
//

import XCTest
@testable import Countries

class CountryDetailTests: XCTestCase {

    private let country = Country(
        name: "Afghanistan",
        nativeName: "Afghan",
        alpha2Code: "AF",
        alpha3Code: "AFG",
        capital: "Kabul",
        region: "Asia",
        subregion: "Southern Asia",
        population: 32890765,
        area: 657189,
        currencies: [Currency(code: "AFG", name: "Afghan Afghani", symbol: "$")],
        languages: [Language(name: "Dari", code: "dari")]
    )
    
    func testDetailInformationLoadedCorrectly() {
        let viewModel = CountryDetailsViewModel(country: country)
        
        // Check name is correct
        XCTAssertEqual(viewModel.countryName, country.name)
        XCTAssertEqual(viewModel.nativeName, country.nativeName)
        XCTAssertEqual(viewModel.alphaCode, "(\(country.alpha3Code))")
        XCTAssertEqual(viewModel.capital, country.capital)
        XCTAssertEqual(viewModel.region, "\(country.region), \(country.subregion)")
        XCTAssertEqual(viewModel.population, "32,890,765")
        XCTAssertEqual(viewModel.area, "657,189 sq.km")
        XCTAssertEqual(viewModel.currencies, country.currencies.compactMap{ $0.name }.joined(separator: ", "))
        XCTAssertEqual(viewModel.languages, country.languages.compactMap{ $0.name }.joined(separator: ", "))
    }
}
