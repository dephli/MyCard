//
//  ContactDetailsStackView.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/14/21.
//

import Foundation
import UIKit

protocol ContactDetailsStackViewDelegate: AnyObject {
    func socialMediaArrowButtonPressed()
}
class ContactDetailsStackView: UIStackView, SocialMediaStackViewDelegate {

    weak var delegate: ContactDetailsStackViewDelegate?

    enum SingleValueStackViewTypes {
        case workInfo
        case other
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

    func verticalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 4
        return stackView
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

    func singleValueStackView(
        icon: UIImage,
        label: String,
        text: String?,
        stackViewType: SingleValueStackViewTypes,
        otherText: String? = nil
    ) -> UIView {
        let outerStackView = horizontalStackView()
        outerStackView.alignment = .leading
        let imageView = generateImageView(image: icon)
        outerStackView.addArrangedSubview(imageView)

        let detailLabel = detailsLabel()
        detailLabel.text = text

        let nameLabel = titleLabel()
        nameLabel.text = label

        let innerStackView = verticalStackView()
        innerStackView.addArrangedSubview(nameLabel)
        innerStackView.addArrangedSubview(detailLabel)
        if stackViewType == .workInfo {
            let roleLabel = detailsLabel()
            roleLabel.text = otherText
            innerStackView.addArrangedSubview(roleLabel)
        }
        outerStackView.addArrangedSubview(innerStackView)

        return outerStackView
    }

    func multiValueStackView(icon: UIImage, label: String, data: [Any]) -> UIView {
        let outerStackView = horizontalStackView()
        outerStackView.alignment = .leading
        let imageView = generateImageView(image: icon)
        outerStackView.addArrangedSubview(imageView)

        let detailsStackView = DetailsMultiPhoneEmailStackView()

        let nameLabel = titleLabel()
        nameLabel.text = label

        detailsStackView.axis = .vertical
        detailsStackView.configure(with: data)
        let innerStackView = verticalStackView()
        innerStackView.addArrangedSubview(nameLabel)
        innerStackView.addArrangedSubview(detailsStackView)
        outerStackView.addArrangedSubview(innerStackView)

        return outerStackView
    }

    func socialMediaStackView(data: [SocialMedia]) -> UIView {
        let outerStackView = horizontalStackView()
        let dummyView = UIView()
        dummyView.widthAnchor.constraint(equalToConstant: 0).isActive = true
        outerStackView.addArrangedSubview(dummyView)
        let innerStackView = verticalStackView()

        let label = titleLabel()
        label.text = "Social media"
        let socialMediaListStackView = SocialMediaListStackView()
        socialMediaListStackView.axis = .vertical
        socialMediaListStackView.delegate = self
        socialMediaListStackView.configure(with: data, type: .viewing)
        innerStackView.addArrangedSubview(label)
        let labelView = UIView()
        labelView.addSubview(label)
        labelView.heightAnchor.constraint(equalToConstant: 16).isActive = true
        label.leftAnchor.constraint(equalTo: labelView.leftAnchor, constant: 40).isActive = true
        innerStackView.addArrangedSubview(labelView)
        innerStackView.addArrangedSubview(socialMediaListStackView)
        outerStackView.addArrangedSubview(innerStackView)

        return outerStackView
    }

    fileprivate func nameView(_ contact: Contact?) {
        //        NAME
        if ((contact?.name.fullName) != nil) && contact?.name.fullName != "" {
            let nameView = singleValueStackView(
                icon: K.Images.user,
                label: "Name",
                text: contact?.name.fullName,
                stackViewType: .other)
            self.addArrangedSubview(nameView)

            nameView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            nameView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true

            //        DIVIDER

            let divider1 = UIView()
            divider1.backgroundColor = K.Colors.Black5
            self.addArrangedSubview(divider1)
            divider1.heightAnchor.constraint(equalToConstant: 1).isActive = true
            divider1.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 56).isActive = true
            divider1.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        }
    }

    fileprivate func phoneNumbersView(_ contact: Contact?) {
        //        PHONE NUMBER

        if contact?.phoneNumbers?.isEmpty == false
            && contact?.phoneNumbers?[0].number != "" {
            let phoneNumberView = multiValueStackView(
                icon: K.Images.phone,
                label: "Phone",
                data: contact!.phoneNumbers ?? [])

            self.addArrangedSubview(phoneNumberView)
            phoneNumberView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 0)
                .isActive = true
            phoneNumberView.trailingAnchor
                .constraint(
                    equalTo: self.trailingAnchor,
                    constant: 0)
                .isActive = true

            //        DIVIDER
            let divider2 = UIView()
            divider2.backgroundColor = K.Colors.Black5
            self.addArrangedSubview(divider2)
            divider2.heightAnchor.constraint(equalToConstant: 1).isActive = true
            divider2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 56).isActive = true
            divider2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        }
    }

    fileprivate func emailAddressesView(_ contact: Contact?) {
        if contact?.emailAddresses?.isEmpty == false &&
            contact?.emailAddresses?.first?.address != "" {
            //        EMAIL ADDRESS
            let emailAddressView = multiValueStackView(
                icon: K.Images.mail,
                label: "Email",
                data: contact!.emailAddresses ?? [])

            self.addArrangedSubview(emailAddressView)
            emailAddressView.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 0).isActive = true
            emailAddressView.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: 0).isActive = true

            //        DIVIDER
            let divider3 = UIView()
            divider3.backgroundColor = K.Colors.Black5
            self.addArrangedSubview(divider3)
            divider3.heightAnchor.constraint(
                equalToConstant: 1).isActive = true
            divider3.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: 56).isActive = true
            divider3.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: 0).isActive = true
        }
    }

    fileprivate func workInfoView(_ contact: Contact?) {
        if contact?.businessInfo?
            .companyName?.isEmpty == false
            || contact?.businessInfo?.role?.isEmpty == false {
            //        WORK INFO
            let companyView = singleValueStackView(
                icon: K.Images.office,
                label: "Work info",
                text: contact?.businessInfo?.companyName,
                stackViewType: .workInfo,
                otherText: contact?.businessInfo?.role)
            self.addArrangedSubview(companyView)

            companyView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            companyView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true

            //        DIVIDER
            let divider4 = UIView()
            divider4.backgroundColor = K.Colors.Black5
            self.addArrangedSubview(divider4)
            divider4.heightAnchor.constraint(equalToConstant: 1).isActive = true
            divider4.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 56).isActive = true
            divider4.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        }
    }

    fileprivate func workLocationView(_ contact: Contact?) {
        if contact?.businessInfo?.companyAddress?.isEmpty == false {
            //        WORK LOCATION
            let workInfoView = singleValueStackView(
                icon: K.Images.location,
                label: "Work location",
                text: contact?.businessInfo?.companyAddress,
                stackViewType: .other)
            self.addArrangedSubview(workInfoView)

            workInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            workInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true

            //        DIVIDER
            let divider5 = UIView()
            divider5.backgroundColor = K.Colors.Black5
            self.addArrangedSubview(divider5)
            divider5.heightAnchor.constraint(equalToConstant: 1).isActive = true
            divider5.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 56).isActive = true
            divider5.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        }
    }

    fileprivate func websiteView(_ contact: Contact?) {
        if contact?.businessInfo?.website?.isEmpty == false {
            //        WORK LOCATION
            let workInfoView = singleValueStackView(
                icon: K.Images.location,
                label: "Website",
                text: contact?.businessInfo?.website,
                stackViewType: .other)
            self.addArrangedSubview(workInfoView)

            workInfoView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
            workInfoView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true

            //        DIVIDER
            let divider5 = UIView()
            divider5.backgroundColor = K.Colors.Black5
            self.addArrangedSubview(divider5)
            divider5.heightAnchor.constraint(equalToConstant: 1).isActive = true
            divider5.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 56).isActive = true
            divider5.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        }
    }

    fileprivate func socialMediaView(_ contact: Contact?) {
        if contact?.socialMediaProfiles != nil &&
            contact?.socialMediaProfiles?.isEmpty == false {
            //        SOCIAL MEDIA
            let socialMediaView = socialMediaStackView(data: contact!.socialMediaProfiles ?? [])

            self.addArrangedSubview(socialMediaView)

            //        DIVIDER
            let divider6 = UIView()
            divider6.backgroundColor = K.Colors.Black5
            self.addArrangedSubview(divider6)
            divider6.heightAnchor.constraint(equalToConstant: 1).isActive = true
            divider6.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 56).isActive = true
            divider6.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        }
    }

    func configure(contact: Contact?) {
        self.removeAllArrangedSubviews()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.spacing = 16

        nameView(contact)

        phoneNumbersView(contact)

        emailAddressesView(contact)

        workInfoView(contact)

        workLocationView(contact)

        socialMediaView(contact)

        websiteView(contact)
    }

}

extension ContactDetailsStackView {
    func onArrowButtonPressed() {
        delegate?.socialMediaArrowButtonPressed()
    }
}
