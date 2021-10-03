//
//  CountriesViewModelTests.swift
//  CountriesTests
//
//  Created by Dushant  Singh on 2021-10-01.
//

import XCTest
import Combine
@testable import Countries

class CountriesViewModelTests: XCTestCase {

    private let fileName = "countries"
    
    private var countries: [Country] = []
    private var countryService: CountryServiceProvider = CountryService()
    private var cancellables: Set<AnyCancellable> = []
    private var testingViewModel = CountriesViewModel()
    
    override func setUpWithError() throws {
        countries = try readJson(from: "countries")
    }
    
    func testThatCountriesAreLoadedSuccessfully() {
        // GIVEN
        var loadingStates = [LoadingState]()
        let expectation = expectation(description: "Loading countries successfully")
        let updateExpectation: () -> Void = {
            if let state = loadingStates.last, ![.idle, .loading].contains(state) {
                expectation.fulfill()
            }
        }
        countryService = MockCountryServiceProvider(countries: countries)
        testingViewModel = CountriesViewModel(with: countryService)
        
        // WHEN
        testingViewModel.$loadingState
            .sink (receiveCompletion: { _ in }, receiveValue: {
                loadingStates.append($0)
                updateExpectation()
            })
            .store(in: &cancellables)
        
        testingViewModel.loadCountries()
        waitForExpectations(timeout: 1.0, handler: nil)
        
        // THEN
        XCTAssertTrue(loadingStates.first == .idle)
        XCTAssertTrue(loadingStates.contains(.loading))
        XCTAssertTrue(loadingStates.contains(.success))
        XCTAssertFalse(testingViewModel.displayCountries.isEmpty)
        XCTAssertEqual(testingViewModel.displayCountries.count, 250)
    }
    
    func testThatCountriesLoadingFailCalledFailed() {
        // GIVEN
        var loadingStates = [LoadingState]()
        let expectation = expectation(description: "Loading countries failed")
        let updateExpectation: () -> Void = {
            if let state = loadingStates.last, ![.idle, .loading].contains(state) {
                expectation.fulfill()
            }
        }
        countryService = MockCountryServiceProvider(error: RequestError.badRequest)
        testingViewModel = CountriesViewModel(with: countryService)
        
        // WHEN
        testingViewModel.$loadingState
            .sink { loadingStates.append($0); updateExpectation() }
            .store(in: &cancellables)
        testingViewModel.loadCountries()
        waitForExpectations(timeout: 1.0, handler: nil)
        
        // THEN
        XCTAssertTrue(loadingStates.first == .idle)
        XCTAssertTrue(loadingStates.contains(.loading))
        XCTAssertNotNil(loadingStates.first { $0 == .failed(error: RequestError.badRequest) })
    }
    
    func testThatSearchUpdatesDisplayCountriesList() {
        // GIVEN
        countryService = MockCountryServiceProvider(countries: countries)
        testingViewModel = CountriesViewModel(with: countryService)
        testingViewModel.loadCountries()
        
        // Should have 248 countries
        XCTAssertEqual(testingViewModel.displayCountries.count, 250)
        
        // Search for Afghanistan, should have 1 country
        testingViewModel.searchByCountryName = "Afghanistan"
        XCTAssertEqual(testingViewModel.displayCountries.count, 1)
        
        // Search for AFG, should return 1
        testingViewModel.searchByCountryName = "AFG"
        XCTAssertEqual(testingViewModel.displayCountries.count, 1)
        
        // Reset everything
        testingViewModel.searchByCountryName = ""
        XCTAssertEqual(testingViewModel.displayCountries.count, 250)
    }
}
