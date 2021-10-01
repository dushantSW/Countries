//
//  CountryFlagViewCell.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-10-01.
//

import Foundation
import UIKit
import Kingfisher

class CountryFlagViewCell: UICollectionViewCell, ReusableView {
    @IBOutlet private weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        imageView.layer.cornerRadius = 12.0
        imageView.layer.masksToBounds = false
        imageView.layer.applyShadow(color: UIColor.black, alpha: 0.2, x: 0, y: 2, blur: 8, spread: 0)
    }
    
    func configure(for country: Country) {
        let imageUrl = country.imageURL()
        imageView.kf.setImage(with: imageUrl)
    }
}
