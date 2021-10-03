//
//  CountryViewModel.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-09-30.
//

import Foundation
import Combine

class CountriesViewModel: ObservableObject {
    private var countries: [Country] = []
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Public properties
    public let detailSegueIdentifier = "countryDetail"
    
    @Published private(set) var loadingState: LoadingState = .idle
    @Published private(set) var displayCountries: [Country] = []
    @Published public var searchByCountryName: String = ""
    
    private(set) var currentSelectedCountry: Country? = nil
    
    // MARK: - Private properties
    private let service: CountryServiceProvider
    
    // MARK: - Initialization
    init(with service: CountryServiceProvider = CountryService.shared) {
        self.service = service
        self.configureSearchTextPublishing()
    }
    
    // MARK: - Public functions
    public func loadCountries() {
        service.fetchAllCountries().sink { result in
            switch result {
            case .success(let countries):
                self.countries = countries
                self.displayCountries = self.getDisplayCountries(from: countries)
                self.loadingState = .success
            case .failure(let error):
                self.loadingState = .failed(error: error as? LocalizedError ?? RequestError.unknownError)
            }
        }.store(in: &cancellables)
        self.loadingState = .loading
    }
    
    public func didSelectCountry(at row: Int) {
        guard let country = displayCountries[safe: row] else { return }
        currentSelectedCountry = country
    }
    
    // MARK: - Helper methods
    private func configureSearchTextPublishing() {
        self.$searchByCountryName
            .compactMap { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map { input in
                if input.isEmpty { return self.getDisplayCountries(from: self.countries) }
                return self.countries.filter { $0.alpha2Code == input || $0.name.lowercased().contains(input.lowercased()) }
            }
            .assign(to: \.displayCountries, on: self)
            .store(in: &cancellables)
    }
    
    private func getDisplayCountries(from countries: [Country]) -> [Country] {
        return countries.sorted(by: { $0.name < $1.name })
    }
}
