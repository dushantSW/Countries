//
//  CountryServiceTests.swift
//  CountriesTests
//
//  Created by Dushant  Singh on 2021-10-01.
//

import XCTest
import Combine
@testable import Countries

class CountryServiceTests: XCTestCase {
    
    private var countryService = CountryService()
    private var networkClient = MockNetworkClientProvider(customResponses: [:])
    private var cancellables: Set<AnyCancellable> = []
    
    func testThatCountriesAreReturnedSuccessfully() {
        // WHEN
        var result: Result<[Country], Error>?
        let expectation = expectation(description: "Expecting to get successfull return")
        let country = Country(name: "Afghanistan", nativeName: "Afghan", alpha2Code: "AF", alpha3Code: "AFG",
                              capital: "Kabul", region: "Asia", subregion: "Southern Asia",
                              population: 3231, area: 123, currencies: [], languages: [])
        networkClient = MockNetworkClientProvider(customResponses: [Endpoint.all.url().path: [country]])
        countryService = CountryService(with: networkClient)
        
        // GIVEN
        countryService.fetchAllCountries()
            .sink { result = $0; expectation.fulfill() }
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0, handler: nil)
        
        // THEN
        XCTAssertNotNil(result)
        XCTAssertTrue(result!.isSuccess)
        XCTAssertFalse(try result!.get().isEmpty)
    }
    
    func testThatCountriesReturnErrorOnFailure() {
        // WHEN
        var result: Result<[Country], Error>?
        let expectation = expectation(description: "Expecting to get network error")
        networkClient = MockNetworkClientProvider(customResponses: [Endpoint.all.url().path: RequestError.badRequest])
        countryService = CountryService(with: networkClient)
        
        // GIVEN
        countryService.fetchAllCountries()
            .sink { result = $0; expectation.fulfill() }
            .store(in: &cancellables)
        waitForExpectations(timeout: 1.0, handler: nil)
        
        // THEN
        XCTAssertNotNil(result)
        XCTAssertFalse(result!.isSuccess)
    }
}
