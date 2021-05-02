//
//  LabelledScannedDetailsStackView.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/1/21.
//

import Foundation
import UIKit

class LabelledScannedDetailsStackView: UIStackView {
    func configure() {
        self.axis = .vertical

        let dataView1 = dataView()
        let divider1 = dividerView()
        let dataView2 = dataView()
        let divider2 = dividerView()
        addArrangedSubview(dataView1)
        addArrangedSubview(divider1)
        addArrangedSubview(dataView2)
        addArrangedSubview(divider2)

    }

    func dataView() -> UIView {

//        image view
        let imageView = generateImageView(image: K.Images.phone)

//        title label
        let labelTitle = titleLabel()
        labelTitle.text = "PHONE NUMBER"

        let captionLabel = subTitleLabel()
        captionLabel.text = "Primary"
        captionLabel.textColor = K.Colors.Green

//        details label
        let detailLabel = detailsLabel()
        detailLabel.text = "0203940292"

        let verticalSubView = verticalStackView()
        verticalSubView.addArrangedSubview(labelTitle)
        verticalSubView.addArrangedSubview(detailLabel)
        verticalSubView.addArrangedSubview(captionLabel)

        let actionView = UIView()
        actionView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let untagButton = generateButton(image: K.Images.untag)
        let editButton = generateButton(image: K.Images.edit)
        let changeButton = generateButton(image: K.Images.swap)

        let horizontalSubView = horizontalStackView()
        horizontalSubView.distribution = .fillProportionally
        horizontalSubView.addArrangedSubview(imageView)
        horizontalSubView.alignment = .leading
        horizontalSubView.addArrangedSubview(verticalSubView)

        let actionStackView = horizontalStackView()
        actionStackView.spacing = 24
        actionView.addSubview(actionStackView)

        NSLayoutConstraint.activate([
            actionStackView.topAnchor.constraint(equalTo: actionView.topAnchor, constant: 0),
            actionStackView.bottomAnchor.constraint(equalTo: actionView.bottomAnchor, constant: 0),
            actionStackView.trailingAnchor.constraint(equalTo: actionView.trailingAnchor, constant: 0)
        ])
        actionStackView.addArrangedSubview(changeButton)
        actionStackView.addArrangedSubview(editButton)
        actionStackView.addArrangedSubview(untagButton)

        let stackView = verticalStackView()
        stackView.addArrangedSubview(horizontalSubView)
        stackView.addArrangedSubview(actionView)
        return stackView
    }

    func dividerView() -> UIView {
        let dividerContainer = UIView()
        dividerContainer.translatesAutoresizingMaskIntoConstraints = false
        dividerContainer.heightAnchor.constraint(equalToConstant: 32).isActive = true
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        dividerContainer.addSubview(divider)

        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.trailingAnchor.constraint(equalTo: dividerContainer.trailingAnchor, constant: 0),
            divider.centerYAnchor.constraint(equalTo: dividerContainer.centerYAnchor),
            divider.leadingAnchor.constraint(equalTo: dividerContainer.leadingAnchor, constant: 56)
        ])

        divider.backgroundColor = K.Colors.Black5
        return dividerContainer
    }

    func titleLabel() -> UILabel {
        let label = UILabel()
        label.style(with: K.TextStyles.captionBlack60)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func detailsLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.style(with: K.TextStyles.bodyBlack)
        return label
    }

    func horizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 16
        return stackView
    }

    func generateButton(image: UIImage) -> UIButton {
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.tintColor = .black
        return button
    }

    func verticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        return stackView
    }

    func subTitleLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.style(with: K.TextStyles.captionBlack60)
        return label
    }

    func generateImageView (image: UIImage) -> UIView {
        let imageContainerView = UIView()
        imageContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageContainerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        imageContainerView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        imageContainerView.cornerRadius = 20
        imageContainerView.backgroundColor = K.Colors.Black40

        let imageView = UIImageView(image: image)
        imageView.tintColor = K.Colors.White
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageContainerView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
        return imageContainerView
    }

}
