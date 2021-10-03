//
//  CountryDetailViewController.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-09-30.
//

import UIKit
import Kingfisher

class CountryDetailViewController: UIViewController {
    var viewModel: CountryDetailsViewModel? = nil
    
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var alpha2CodeLabel: UILabel!
    
    @IBOutlet private weak var nativeNameLabel: InformationHView!
    @IBOutlet private weak var capitalLabel: InformationHView!
    @IBOutlet private weak var regionLabel: InformationHView!
    @IBOutlet private weak var populationLabel: InformationHView!
    @IBOutlet private weak var areaLabel: InformationHView!
    @IBOutlet private weak var currenciesLabel: InformationHView!
    @IBOutlet private weak var languagesLabel: InformationHView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Configure views
        flagImageView.layer.cornerRadius = 8
        flagImageView.layer.applyShadow(color: UIColor.black, alpha: 0.2, x: 0, y: 2, blur: 8, spread: 0)
        
        // Write content
        setup()
    }
    
    @IBAction private func didPressClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setup() {
        guard let viewModel = viewModel else {
            return
        }

        flagImageView.kf.setImage(with: viewModel.imageURL)
        titleLabel.text = viewModel.countryName
        alpha2CodeLabel.text = viewModel.alphaCode
        
        nativeNameLabel.setContent(title: NSLocalizedString("Native name", comment: "Title local name"), description: viewModel.nativeName)
        capitalLabel.setContent(title: NSLocalizedString("Capital", comment: "Title capital"), description: viewModel.capital)
        regionLabel.setContent(title: NSLocalizedString("Region", comment: "Title region"), description: viewModel.region)
        populationLabel.setContent(title: NSLocalizedString("Population", comment: "Title population"), description: viewModel.population)
        
        if viewModel.hasAreaInfo {
            areaLabel.setContent(title: NSLocalizedString("Area", comment: "Title area"), description: viewModel.area)
        } else {
            areaLabel.isHidden = true
        }
        currenciesLabel.setContent(title: NSLocalizedString("Currency", comment: "Title currency"), description: viewModel.currencies)
        languagesLabel.setContent(title: NSLocalizedString("Languages", comment: "Title official language"), description: viewModel.languages)
    }
}
