//
//  ContactCellViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/14/21.
//

import Foundation
import UIKit

class ContactsCellViewModel: BaseViewModel {
    var fullName: String!
    var companyName: String?
    var role: String?
    var nameInitials = ""
    var avatarImageUrl: String?
    var avatarImageIsHidden = true
    var color: UIColor!

    init(contact: Contact) {
        super.init()
        color = UIColor.random
        fullName = contact.name.fullName ?? ""
        companyName = contact.businessInfo?.companyName
        role = contact.businessInfo?.role
        setNameInitials(contact: contact)
        avatarImageUrl = contact.profilePicUrl
        if contact.profilePicUrl != nil {
            avatarImageIsHidden = false
        }
    }

    private func setNameInitials(contact: Contact) {
        let firstName = contact.name.firstName?.trimmingCharacters(in: .whitespaces)
        let lastName = contact.name.lastName?.trimmingCharacters(in: .whitespaces)
        if firstName != "" && lastName == "" {
            nameInitials = "\(firstName!.prefix(1))"

        } else if lastName != "" && firstName == "" {
            nameInitials = "\(lastName!.prefix(1))"

        } else if lastName != "" && firstName != "" {
            nameInitials = "\(firstName?.prefix(1) ?? "")\(lastName?.prefix(1) ?? "")"
        } else if firstName == "" && lastName == "" {
            nameInitials = "\(contact.name.fullName!.prefix(1))"
        }
    }
}
