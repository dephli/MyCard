//
//  SocialMediaListStackView.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/15/20.
//

import Foundation
import UIKit

protocol SocialMediaStackViewDelegate: AnyObject {
    func onArrowButtonPressed()
}
class SocialMediaListStackView: UIStackView {
    enum ListType {
        case creation
        case viewing
    }

    let accountImageMap: [String: UIImage] = [
        K.SocialMedia.facebook: K.Images.facebook,
        K.SocialMedia.instagram: K.Images.instagram,
        K.SocialMedia.linkedin: K.Images.linkedin,
        K.SocialMedia.twitter: K.Images.twitter
    ]

    weak var delegate: SocialMediaStackViewDelegate?

    func configure(with accounts: [SocialMedia], type: ListType) {

        DispatchQueue.main.async {
            self.removeAllArrangedSubviews()
            for account in accounts {
                let innerStack = UIStackView()
                innerStack.axis = .horizontal
                innerStack.distribution = .fillProportionally
                innerStack.spacing = 16

                let image = self.createImageView(type: account.type.rawValue)
                let label = self.createLabel(text: account.usernameOrUrl)

                innerStack.addArrangedSubview(image)
                innerStack.addArrangedSubview(label)
                if type == .creation {
                    let button = self.createButton()
                    innerStack.addArrangedSubview(button)
                    let gestureRecognizer = UITapGestureRecognizer(
                        target: self,
                        action: #selector(self.handleButtonTapped))
                    button.addGestureRecognizer(gestureRecognizer)
                }
                self.spacing = 24
                self.addArrangedSubview(innerStack)
            }
        }
    }

    @objc func handleButtonTapped() {
        delegate?.onArrowButtonPressed()
    }

    func createImageView(type: String) -> UIImageView {
        let image = UIImageView(image: accountImageMap[type.lowercased()])
        image.widthAnchor.constraint(equalToConstant: 24).isActive = true
        image.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return image
    }

    func createButton() -> UIButton {
        let button = UIButton()
        let buttonImage = K.Images.chevronRight
        button.setImage(buttonImage, for: .normal)
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        return button
    }

    func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        let labelLayoutPriority = UILayoutPriority(1000)
        label.setContentCompressionResistancePriority(labelLayoutPriority, for: .horizontal)
        label.style(with: K.TextStyles.bodyBlack)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail

        return label
    }

}
