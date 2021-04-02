//
//  File.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/7/21.
//

import Foundation
import UIKit

class DetailsMultiPhoneEmailStackView: UIStackView {

    let colorCodes = [
        "Mobile": K.Colors.Blue,
        "Home": K.Colors.Yellow,
        "Work": K.Colors.Green,
        "Other": K.Colors.Green,
        "Personal": K.Colors.Blue
    ]

    func configure(with data: [Any]) {
        self.spacing = 8
        for item in data {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .leading
            stackView.spacing = 4
            let titleLabel = self.titleLabel()
            let subtitleLabel = self.subTitleLabel()

            if let phoneNumber = item as? PhoneNumber {
                titleLabel.text = phoneNumber.number
                subtitleLabel.text = phoneNumber.type.rawValue
                subtitleLabel.textColor = colorCodes[phoneNumber.type.rawValue]!

            }

            if let email = item as? Email {
                titleLabel.text = email.address
                subtitleLabel.text = email.type.rawValue
                subtitleLabel.textColor = self.colorCodes[email.type.rawValue]!
            }

            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(subtitleLabel)
            self.addArrangedSubview(stackView)
        }

    }

    func titleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.style(with: K.TextStyles.bodyBlack)
        return label
    }

    func subTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.style(with: K.TextStyles.captionBlack60)
        return label
    }

}
