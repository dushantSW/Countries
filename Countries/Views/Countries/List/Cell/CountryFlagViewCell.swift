//
//  CountryFlagViewCell.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-10-01.
//

import Foundation
import UIKit
import Kingfisher

class CountryFlagViewCell: UITableViewCell, ReusableView {
    @IBOutlet private weak var flagImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        flagImageView.layer.cornerRadius = 4.0
    }
    
    func configure(for country: Country) {
        let imageUrl = country.imageURL()
        flagImageView.kf.setImage(with: imageUrl)
        titleLabel.text = "\(country.name.capitalized)"
    }
}
