//
//  SocialMediaListStackView.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/15/20.
//

import Foundation
import UIKit

class SocialMediaListStackView: UIStackView {
    func configure(with accounts: [SocialMedia]) {
        
        DispatchQueue.main.async {
            self.removeAllArrangedSubviews()
            for account in accounts {
                let innerStack = UIStackView()
                innerStack.axis = .horizontal
                innerStack.distribution = .fillProportionally
                innerStack.spacing = 16
                
                let image = self.createImageView(type: account.type.rawValue)
                let label = self.createLabel(text: account.usernameOrUrl)
                let button = self.createButton()

                innerStack.addArrangedSubview(image)
                innerStack.addArrangedSubview(label)
                innerStack.addArrangedSubview(button)
                self.spacing = 24
                self.addArrangedSubview(innerStack)
            }
        }
    }
    
    let accountImageMap: [String: UIImage] = [
        K.SocialMedia.facebook: UIImage(named: K.Images.facebook)!,
        K.SocialMedia.instagram: UIImage(named: K.Images.instagram)!,
        K.SocialMedia.linkedin: UIImage(named: K.Images.linkedin)!,
        K.SocialMedia.twitter: UIImage(named: K.Images.twitter)!
    ]
    
    func createImageView(type: String) -> UIImageView {
        let image = UIImageView(image: accountImageMap[type.lowercased()])
        image.widthAnchor.constraint(equalToConstant: 24).isActive = true
        image.heightAnchor.constraint(equalToConstant: 24).isActive = true
        return image
    }
    
    func createButton() -> UIButton {
        let button = UIButton()
        let buttonImage = UIImage(named: K.Images.chevron_right)
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
