//
//  WorkInfoViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/12/21.
//

import Foundation

class WorkInfoViewModel {
    var contact: Contact {
        CardManager.shared.currentContact
    }
    var companyName = ""
    var role = ""
    var address = ""

    init() {
        role = contact.businessInfo?.role ?? ""
        companyName = contact.businessInfo?.companyName ?? ""
        address = contact.businessInfo?.companyAddress ?? ""
    }

    func saveCardData() {
        var contactCopy = contact

        if contact.businessInfo == nil {
            var businessInfo = BusinessInfo()
            businessInfo.companyAddress = address
            businessInfo.companyName = companyName
            businessInfo.role = role
            contactCopy.businessInfo = businessInfo
        } else {
            contactCopy.businessInfo?.companyAddress = address
            contactCopy.businessInfo?.companyName = companyName
            contactCopy.businessInfo?.role = role
        }
        CardManager.shared.setContact(with: contactCopy)
    }
}
