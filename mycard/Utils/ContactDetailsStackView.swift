//
//  ContactDetailsStackView.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/14/21.
//

import Foundation
import UIKit

class ContactDetailsStackView: UIStackView {
    
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
//        stackView.alignment = .top
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
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageContainerView.addSubview(imageView)
        imageView.centerXAnchor.constraint(equalTo: imageContainerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageContainerView.centerYAnchor).isActive = true
        return imageContainerView
    }
    
    
    func singleValueStackView(icon: UIImage, label: String, text: String?, stackViewType: SingleValueStackViewTypes, otherText: String? = nil) -> UIView {
        let outerStackView = horizontalStackView()
        outerStackView.alignment = .leading
        let imageView = generateImageView(image: icon)
        outerStackView.addArrangedSubview(imageView)

        let detailLabel = detailsLabel()
        detailLabel.text = text
        
        let nameLabel = titleLabel()
        nameLabel.text = label
        
        if stackViewType == .workInfo {
            let roleLabel = detailsLabel()
            roleLabel.text = otherText
        }

        let innerStackView = verticalStackView()
        innerStackView.addArrangedSubview(nameLabel)
        innerStackView.addArrangedSubview(detailLabel)
        outerStackView.addArrangedSubview(innerStackView)
        
        return outerStackView
    }
    
    func multiValueStackView(icon: UIImage, label: String, data: [Any]) -> UIView {
        let outerStackView = horizontalStackView()
        outerStackView.alignment = .leading
        let imageView = generateImageView(image: icon)
        outerStackView.addArrangedSubview(imageView)
        
        let innerStackView = DetailsMultiPhoneEmailStackView()
        innerStackView.axis = .vertical
        innerStackView.configure(with: data)
        outerStackView.addArrangedSubview(innerStackView)
        
        return outerStackView
    }
    
    func socialMediaStackView(data: [SocialMedia]) -> UIView {
        let outerStackView = horizontalStackView()
        let dummyView = UIView()
        dummyView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        outerStackView.addArrangedSubview(dummyView)
        let innerStackView = verticalStackView()
        
        let label = titleLabel()
        label.text = "SOCIAL MEDIA"
        let socialMediaListStackView = SocialMediaListStackView()
        socialMediaListStackView.axis = .vertical
        socialMediaListStackView.configure(with: data)
        innerStackView.addArrangedSubview(label)
        innerStackView.addArrangedSubview(socialMediaListStackView)
        outerStackView.addArrangedSubview(innerStackView)
        
        return outerStackView
    }
    
    func configure(contact: Contact?) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.spacing = 16
        
//        NAME
        if ((contact?.name.fullName) != nil) && contact?.name.fullName != "" {
            let nameView = singleValueStackView(icon: K.Images.user_light!, label: "NAME", text: contact?.name.fullName,  stackViewType: .other)
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
        
        
//        PHONE NUMBER
        
        if contact?.phoneNumbers.isEmpty == false && contact?.phoneNumbers[0].number != "" {
        let phoneNumberView = multiValueStackView(icon: K.Images.phone!, label: "PHONE", data: contact!.phoneNumbers)
        
        self.addArrangedSubview(phoneNumberView)
        phoneNumberView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        phoneNumberView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
//        DIVIDER
        let divider2 = UIView()
        divider2.backgroundColor = K.Colors.Black5
        self.addArrangedSubview(divider2)
        divider2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider2.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 56).isActive = true
        divider2.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        }
        
        
        if contact?.emailAddresses.isEmpty == false && contact?.emailAddresses.first?.address != "" {
//        EMAIL ADDRESS
        let emailAddressView = multiValueStackView(icon: K.Images.mail!, label: "EMAIL", data: contact!.emailAddresses)
        
        self.addArrangedSubview(emailAddressView)
        emailAddressView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        emailAddressView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        
//        DIVIDER
        let divider3 = UIView()
        divider3.backgroundColor = K.Colors.Black5
        self.addArrangedSubview(divider3)
        divider3.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider3.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 56).isActive = true
        divider3.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        }
        
        if contact?.businessInfo.companyName != "" || contact?.businessInfo.role != ""{
//        WORK INFO
            let companyView = singleValueStackView(icon: K.Images.office!, label: "WORK INFO", text: contact?.businessInfo.companyName,  stackViewType: .workInfo, otherText: contact?.businessInfo.role)
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
        
        if contact?.businessInfo.companyAddress != "" {
//        WORK LOCATION
            let workInfoView = singleValueStackView(icon: K.Images.location!, label: "WORK LOCATION", text: contact?.businessInfo.companyAddress,  stackViewType: .other)
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
        
        if contact?.socialMediaProfiles != nil && contact?.socialMediaProfiles.isEmpty == false {
//        SOCIAL MEDIA
        let socialMediaView = socialMediaStackView(data: contact!.socialMediaProfiles)
        
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
    

}
