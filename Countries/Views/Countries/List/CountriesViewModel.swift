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
    @Published private(set) var loadingState: LoadingState = .idle
    @Published private(set) var displayCountries: [Country] = []
    @Published var searchByCountryName: String = ""
    
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
                self.displayCountries = countries
                self.loadingState = .success
            case .failure(let error):
                self.loadingState = .failed(error: error as? LocalizedError ?? RequestError.unknownError)
            }
        }.store(in: &cancellables)
        self.loadingState = .loading
    }
    
    // MARK: - Helper methods
    func configureSearchTextPublishing() {
        self.$searchByCountryName
            .removeDuplicates()
            .map { input in
                if input.isEmpty { return self.countries }
                return self.countries.filter {
                    $0.alpha2Code == input || $0.name.lowercased().contains(input.lowercased())
                }
            }
            .assign(to: \.displayCountries, on: self)
            .store(in: &cancellables)
    }
}
