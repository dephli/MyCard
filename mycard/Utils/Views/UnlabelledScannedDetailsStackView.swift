//
//  UnlabelledScannedDetailsStackView.swift
//  Pods
//
//  Created by Joseph Maclean Arhin on 5/2/21.
//

import Foundation
import UIKit

class UnlabelledScannedDetailsStackView: UIStackView {
    func configure() {
        self.axis = .vertical
        self.spacing = 16

        for _ in 1...2 {
            let dataView = dataView()
            addArrangedSubview(dataView)
            addArrangedSubview(divider())

        }

    }

    func dataView() -> UIView {

        let detailLabel = detailsLabel()
        detailLabel.text = "Mr. John Agyekum"

        let verticalSubView = verticalStackView()
        verticalSubView.addArrangedSubview(detailLabel)

        let actionView = UIView()
        let copyRemoveActionView = horizontalStackView()
//        actionView.distribution = .equalSpacing

        let addLabelButton = UIButton()
        addLabelButton.translatesAutoresizingMaskIntoConstraints = false
        addLabelButton.setImage(K.Images.tag, for: .normal)
        addLabelButton.tintColor = K.Colors.Blue
        addLabelButton.titleLabel?.lineBreakMode = .byWordWrapping
        addLabelButton.setTitle("Add label", for: .normal)
        addLabelButton.setTitle(with: K.TextStyles.captionBlue, for: .normal)

        actionView.addSubview(addLabelButton)
        actionView.addSubview(copyRemoveActionView)
        NSLayoutConstraint.activate([
            actionView.heightAnchor.constraint(equalToConstant: 40),
            addLabelButton.leadingAnchor.constraint(equalTo: actionView.leadingAnchor, constant: 0),
            addLabelButton.centerYAnchor.constraint(equalTo: actionView.centerYAnchor),
            addLabelButton.heightAnchor.constraint(equalToConstant: 40),
            copyRemoveActionView.heightAnchor.constraint(equalToConstant: 40),
            copyRemoveActionView.trailingAnchor.constraint(equalTo: actionView.trailingAnchor, constant: 0),
            copyRemoveActionView.centerYAnchor.constraint(equalTo: actionView.centerYAnchor)
        ])

        let removeButton = generateButton(image: K.Images.minus)
        let copyButton = generateButton(image: K.Images.copy)

        NSLayoutConstraint.activate([
            removeButton.heightAnchor.constraint(equalToConstant: 40),
            removeButton.widthAnchor.constraint(equalToConstant: 40),
            copyButton.heightAnchor.constraint(equalToConstant: 40),
            copyButton.widthAnchor.constraint(equalToConstant: 40)

        ])

        copyRemoveActionView.addArrangedSubview(copyButton)
        copyRemoveActionView.addArrangedSubview(removeButton)

        verticalSubView.addArrangedSubview(actionView)

        return verticalSubView
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

    func divider() -> UIView {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.backgroundColor = K.Colors.Black5

        return divider
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
        stackView.spacing = 20
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
