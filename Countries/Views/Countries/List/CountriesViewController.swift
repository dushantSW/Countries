//
//  ViewController.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-09-30.
//

import UIKit
import Combine

class CountriesViewController: UIViewController {
    private let viewModel = CountriesViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var subscribers = [AnyCancellable]()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup search controller
        configureSearchController()
        
        // Bind to publishers
        viewModel.$loadingState.dropFirst().sink { self.handleLoadingStateChanged(to: $0) }.store(in: &subscribers)
        viewModel.$displayCountries.sink { _ in self.updateCollectionView() }.store(in: &subscribers)
        
        // Fetch countries
        viewModel.loadCountries()
    }
    
    // MARK: - Helper methods
    private func configureSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func handleLoadingStateChanged(to state: LoadingState) {
        switch state {
        case .loading:
            break
        case .success:
            self.updateCollectionView()
        case .failed(let error):
            self.displayError(error: error)
        default: break
        }
    }
    
    private func updateCollectionView() {
        collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension CountriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let country = viewModel.displayCountries[safe: indexPath.row] else { return }
    }
}

// MARK: - UICollectionViewDataSource
extension CountriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.displayCountries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let country = viewModel.displayCountries[safe: indexPath.row] else { return UICollectionViewCell() }
        let cell: CountryFlagViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(for: country)
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension CountriesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchByCountryName = ""
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchByCountryName = searchText
    }
}
