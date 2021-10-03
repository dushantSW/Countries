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
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        
        // Setup search controller
        configureSearchController()
        
        // Bind to publishers
        viewModel.$loadingState
            .receive(on: Scheduler.main)
            .sink { self.handleLoadingStateChanged(to: $0) }
            .store(in: &subscribers)
        
        viewModel.$displayCountries
            .receive(on: Scheduler.main, options: nil)
            .sink { _ in self.updateTableView() }
            .store(in: &subscribers)
        
        // Fetch countries
        viewModel.loadCountries()
    }
    
    // MARK: - Helper methods
    private func configureSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func handleLoadingStateChanged(to state: LoadingState) {
        switch state {
        case .loading:
            break
        case .success:
            self.updateTableView()
        case .failed(let error):
            self.displayError(error: error)
        default: break
        }
    }
    
    private func updateTableView() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == viewModel.detailSegueIdentifier {
            guard let destinationViewController = segue.destination as? CountryDetailViewController else { return }
            guard let currentSelectedCountry = viewModel.currentSelectedCountry else { return }
            destinationViewController.viewModel = CountryDetailsViewModel(country: currentSelectedCountry)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension CountriesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCountry(at: indexPath.row)
        performSegue(withIdentifier: viewModel.detailSegueIdentifier, sender: self)
    }
}

// MARK: - UICollectionViewDataSource
extension CountriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Log: Table count is: \(viewModel.displayCountries.count)")
        return viewModel.displayCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let country = viewModel.displayCountries[safe: indexPath.row] else { return UITableViewCell() }
        let cell: CountryFlagViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(for: country)
        return cell
    }
}

// MARK: - UISearchBarDelegate
extension CountriesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchByCountryName = ""
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.setContentOffset(.zero, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchByCountryName = searchText
    }
}
