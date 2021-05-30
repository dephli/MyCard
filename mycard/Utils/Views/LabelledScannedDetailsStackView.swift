//
//  LabelledScannedDetailsStackView.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/1/21.
//

import Foundation
import UIKit

protocol LabelledScannedDetailsDelegate: AnyObject {
    func untag(detail: (String, Int))
    func edit(detail: (String, Int))
    func swap(detail: (String, Int))
}

class LabelledScannedDetailsStackView: UIStackView {

    let colorCodes = [
        "Mobile": K.Colors.Blue,
        "Home": K.Colors.Yellow,
        "Work": K.Colors.Green,
        "Other": K.Colors.Green,
        "Personal": K.Colors.Blue
    ]

    weak var delegate: LabelledScannedDetailsDelegate!

    func configure(_ contact: Contact) {
        self.removeAllArrangedSubviews()
        self.axis = .vertical

        var viewArray: [UIView] = []
        if let name = contact.name.fullName {
            let nameView = nameView(name)
            viewArray.append(nameView)
        }

        if contact.phoneNumbers?.isEmpty == false {
            let phoneNumberView = phoneNumbersView(contact.phoneNumbers)
            viewArray.append(phoneNumberView)
        }

        if contact.emailAddresses?.isEmpty == false {
            let emailView = emailAddressesView(contact.emailAddresses)
            viewArray.append(emailView)
        }

        if let companyName = contact.businessInfo?.companyName {
            let companyView = companyNameView(companyName)
            viewArray.append(companyView)
        }

        if let role = contact.businessInfo?.role {
            let roleView = companyRoleView(role)
            viewArray.append(roleView)
        }

        if let address = contact.businessInfo?.companyAddress {
            let addressView = companyAddressView(address)
            viewArray.append(addressView)
        }

        if let website = contact.businessInfo?.website {
            let websiteView = websiteView(website)
            viewArray.append(websiteView)
        }

        if contact.socialMediaProfiles?.isEmpty == false {
            contact.socialMediaProfiles?.forEach({ socialMedia in
                let view = socialMediaView(
                    socialMedia: socialMedia.type.rawValue,
                    accountInfo: socialMedia.usernameOrUrl
                )
                viewArray.append(view)

            })
        }

        for (index, view) in viewArray.enumerated() {
            if index != 0 {
                addArrangedSubview(dividerView())
            }
            addArrangedSubview(view)
        }

    }

    func nameView(_ name: String?) -> UIView {
        let nameView = singleValueStackView(icon: K.Images.user, label: "Full name", detail: name!)
        return nameView
    }

    func phoneNumbersView(_ phoneNumbers: [PhoneNumber]?) -> UIView {
        let phoneNumberView = multiValueStackView(
            icon: K.Images.phone,
            label: "Phone number",
            data: phoneNumbers!
        )
        return phoneNumberView
    }

    func emailAddressesView(_ emailAddresses: [Email]?) -> UIView {
        let emailView = multiValueStackView(
            icon: K.Images.phone,
            label: "Email Addresses",
            data: emailAddresses!
        )
        return emailView
    }

    func companyNameView(_ companyName: String) -> UIView {
        let companyView = singleValueStackView(icon: K.Images.office, label: "Company Name", detail: companyName)
        return companyView
    }

    func companyRoleView(_ companyRole: String) -> UIView {
        let roleView = singleValueStackView(icon: K.Images.suitcase, label: "Role", detail: companyRole)
        return roleView
    }

    func companyAddressView(_ location: String) -> UIView {
        let view = singleValueStackView(icon: K.Images.location, label: "Work Address", detail: location)
        return view
    }

    func websiteView(_ website: String) -> UIView {
        let view = singleValueStackView(icon: K.Images.web, label: "Website", detail: website)
        return view
    }

    func socialMediaView(socialMedia: String, accountInfo: String) -> UIView {
        let view = socialMediaSingleValueStackView(
            icon: UIImage(named: "socials \(socialMedia.lowercased())")!,
            label: socialMedia, detail: accountInfo
        )
        return view
    }

    func singleValueStackView(
        icon: UIImage,
        label: String,
        detail: String
    ) -> UIView {

//        image view
        let imageView = generateImageView(image: icon)

        let horizontalSubView = horizontalStackView()
        horizontalSubView.distribution = .fillProportionally
        horizontalSubView.addArrangedSubview(imageView)
        horizontalSubView.alignment = .leading
        let detailView = detailView(detail: detail, extraArg: label)
        let labelTitle = titleLabel()
        labelTitle.text = label
        detailView.insertArrangedSubview(labelTitle, at: 0)
        horizontalSubView.addArrangedSubview(detailView)

        let stackView = verticalStackView()
        stackView.addArrangedSubview(horizontalSubView)
        return stackView
    }

    func socialMediaSingleValueStackView(
        icon: UIImage,
        label: String,
        detail: String
    ) -> UIView {

//        image view
        let imageView = generateSocialmediaImageView(image: icon)

        let horizontalSubView = horizontalStackView()
        horizontalSubView.distribution = .fillProportionally
        horizontalSubView.addArrangedSubview(imageView)
        horizontalSubView.alignment = .leading
        let detailView = detailView(detail: detail, extraArg: label)
        let labelTitle = titleLabel()
        labelTitle.text = label
        detailView.insertArrangedSubview(labelTitle, at: 0)
        horizontalSubView.addArrangedSubview(detailView)

        let stackView = verticalStackView()
        stackView.addArrangedSubview(horizontalSubView)
        return stackView
    }

    func multiValueStackView(
        icon: UIImage,
        label: String,
        data: [Any]
    ) -> UIView {
//        image view
        let imageView = generateImageView(image: icon)

        let horizontalSubView = horizontalStackView()
        horizontalSubView.distribution = .fillProportionally
        horizontalSubView.addArrangedSubview(imageView)
        horizontalSubView.alignment = .leading

        let labelTitle = titleLabel()
        labelTitle.text = label

        let verticalSubView = verticalStackView()
        verticalSubView.addArrangedSubview(labelTitle)

        for (index, item) in data.enumerated() {

            if index != 0 {
                verticalSubView.addArrangedSubview(dividerView(fullWidth: true))
            }
            if let phoneNumber = item as? PhoneNumber {
                let detailView = detailView(
                    detail: phoneNumber.number!,
                    caption: phoneNumber.type.rawValue,
                    captionColor: colorCodes[phoneNumber.type.rawValue]!,
                    extraArg: label,
                    index: index
                )
                verticalSubView.addArrangedSubview(detailView)
            }
            if let email = item as? Email {
                let detailView = detailView(
                    detail: email.address,
                    caption: email.type.rawValue,
                    captionColor: colorCodes[email.type.rawValue]!,
                    extraArg: label,
                    index: index
                )
                verticalSubView.addArrangedSubview(detailView)
            }
        }

        horizontalSubView.addArrangedSubview(verticalSubView)

        let stackView = verticalStackView()
        stackView.addArrangedSubview(horizontalSubView)
        return stackView
    }

    func detailView(
        detail: String,
        caption: String? = nil,
        captionColor: UIColor = K.Colors.Blue,
        extraArg: String = "",
        index: Int = 0
    ) -> UIStackView {

//        details label
        let detailLabel = detailsLabel()
        detailLabel.text = detail

        let verticalSubView = verticalStackView()
        verticalSubView.addArrangedSubview(detailLabel)

        if let caption = caption {
            let captionLabel = captionLabel()
            captionLabel.text = caption
            captionLabel.textColor = captionColor

            verticalSubView.addArrangedSubview(captionLabel)
        }

        let actionView = UIView()
        actionView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        let untagButton = generateButton(image: K.Images.untag)
        let editButton = generateButton(image: K.Images.edit)
        let changeButton = generateButton(image: K.Images.swap)

        untagButton.tag = 1
        editButton.tag = 2
        changeButton.tag = 3

        untagButton.labelledArgs = (name: extraArg, index: index)
        editButton.labelledArgs = (name: extraArg, index: index)
        changeButton.labelledArgs = (name: extraArg, index: index)

        untagButton.addTarget(self, action: #selector(untagButtonPressed(_:)), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
        changeButton.addTarget(self, action: #selector(changeButtonPressed(_:)), for: .touchUpInside)

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
        verticalSubView.addArrangedSubview(actionView)
        return verticalSubView
    }

    func dividerView(fullWidth: Bool = false) -> UIView {
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
            divider.leadingAnchor.constraint(equalTo: dividerContainer.leadingAnchor, constant: !fullWidth ? 56 : 0)
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

    func generateButton(image: UIImage) -> LabelledButton {
        let button = LabelledButton()
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

    func captionLabel() -> UILabel {
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

    func generateSocialmediaImageView(image: UIImage) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 40),
            view.heightAnchor.constraint(equalToConstant: 40),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0)
        ])

        return view
    }

    @objc func untagButtonPressed(_ sender: LabelledButton) {
        delegate.untag(detail: sender.labelledArgs as! (String, Int))
    }

    @objc func editButtonPressed(_ sender: LabelledButton) {
        delegate.edit(detail: sender.labelledArgs as! (String, Int))

    }

    @objc func changeButtonPressed(_ sender: LabelledButton) {
        delegate.swap(detail: sender.labelledArgs as! (String, Int))
    }

}
