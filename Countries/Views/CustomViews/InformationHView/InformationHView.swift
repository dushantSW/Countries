//
//  InformationHView.swift
//  Countries
//
//  Created by Dushant  Singh on 2021-10-02.
//

import Foundation
import UIKit

@IBDesignable class InformationHView: UIView, ReusableNibView {

    @IBInspectable var label: String? = nil {
        didSet { self.labelLabel.text = label }
    }

    @IBInspectable var infoDescription: String? = nil {
        didSet { self.descriptionLabel.text = infoDescription }
    }
    
    @IBOutlet private weak var labelLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupFromNib()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupFromNib()
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func setContent(title: String, description: String?) {
        self.label = title
        self.infoDescription = description
    }
    
    private func setupFromNib() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Error loading \(self) from nib")
        }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}
