//
//  SocialMediaListStackView.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/15/20.
//

import Foundation
import UIKit

class SocialMediaListStackView: UIStackView {
    func configure() {
        
        let innerStack = UIStackView()
        innerStack.axis = .horizontal
        innerStack.distribution = .fillProportionally
        innerStack.spacing = 16
        
        let image = createImageView()
        let label = createLabel()
        let button = createButton()

        innerStack.addArrangedSubview(image)
        innerStack.addArrangedSubview(label)
        innerStack.addArrangedSubview(button)
        self.addArrangedSubview(innerStack)
    }
    
    func createImageView() -> UIImageView {
        let image = UIImageView(image: UIImage(named: K.Images.facebook))
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
    
    func createLabel() -> UILabel {
        let label = UILabel()
        label.text = "Joseph Maclean"
        let labelLayoutPriority = UILayoutPriority(1000)
        label.setContentCompressionResistancePriority(labelLayoutPriority, for: .horizontal)
        
        return label
    }
    
}
