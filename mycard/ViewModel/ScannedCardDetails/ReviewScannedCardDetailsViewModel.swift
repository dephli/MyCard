//
//  ReviewScannedCardDetailsViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 5/1/21.
//

import Foundation
import RxCocoa

class ReviewScannedCardDetailsViewModel {
    enum DetailType {
        case unlabelled
        case labelled
    }

    enum BusinessInfoType: String {
        case companyName = "Company name"
        case role = "Role"
        case workLocation = "Work location"
        case website = "Website"
    }

    var currentUnlabelledDetailIndex: Int?

    let labelledScannedDetails: BehaviorRelay<Contact> = BehaviorRelay(value: Contact(name: Name()))
    let unlabelledScannedDetails: BehaviorRelay<[String]> = BehaviorRelay(value: [])

    var unlabelledScannedDetailsArray: [String] {
        unlabelledScannedDetails.value
    }

    init(scannedDetailsArray: [String], scannedDetails: String) {
        splitDetails(scannedDetailsArray, scannedDetails)
    }

    func splitDetails (_ detailsArray: [String], _ details: String) {
        var contact = Contact(
            name: Name(),
            phoneNumbers: [],
            emailAddresses: [],
            businessInfo: BusinessInfo()
        )
        var unlabelledArray: [String] = []
        detailsArray.forEach { text in
            if text.getEmails()?.isEmpty == false, let emails = text.getEmails() {
                emails.forEach { email in
                    contact.emailAddresses?.append(Email(type: .Work, address: email))
                }
            } else if text.getWebsite()?.isEmpty == false, let websites = text.getWebsite() {
                contact.businessInfo?.website = websites[0]
            } else if text.getPhoneNumbers()?.isEmpty == false, let phoneNumbers = text.getPhoneNumbers() {
                phoneNumbers.forEach { phoneNumber in
                    contact.phoneNumbers?.append(
                        PhoneNumber(
                            type: .Work,
                            number: phoneNumber)
                    )
                }
            } else {
                unlabelledArray.append(text)
            }
        }
        labelledScannedDetails.accept(contact)
        unlabelledScannedDetails.accept(unlabelledArray)
    }

    func duplicateDetail(at index: Int) {
        var unlabelledDetails = unlabelledScannedDetailsArray
        let detail = unlabelledDetails[index]
        unlabelledDetails.insert(detail, at: index)
        self.unlabelledScannedDetails.accept(unlabelledDetails)
    }

    func deleteUnlabelledDetail(at index: Int) {
        var unlabelledDetails = unlabelledScannedDetailsArray
        unlabelledDetails.remove(at: index)
        self.unlabelledScannedDetails.accept(unlabelledDetails)
    }

    func setFullName() {
        var contact = labelledScannedDetails.value
        let unlabelledDetails = unlabelledScannedDetailsArray
        contact.name.fullName = unlabelledDetails[currentUnlabelledDetailIndex!]
        labelledScannedDetails.accept(contact)
        removeUnlabelledDetail()
    }

    func setPhoneNumber(type: String) {
        var contact = labelledScannedDetails.value
        let unlabelledDetails = unlabelledScannedDetailsArray

        let phoneNumber = PhoneNumber(
            type: PhoneNumberType.init(rawValue: type)!,
            number: unlabelledDetails[currentUnlabelledDetailIndex!])
        contact.phoneNumbers?.append(phoneNumber)
        labelledScannedDetails.accept(contact)
        removeUnlabelledDetail()

    }

    func setEmail(type: String) {
        var contact = labelledScannedDetails.value
        let unlabelledDetails = unlabelledScannedDetailsArray

        let email = Email(
            type: EmailType.init(rawValue: type)!,
            address: unlabelledDetails[currentUnlabelledDetailIndex!]
        )
        contact.emailAddresses?.append(email)
        labelledScannedDetails.accept(contact)
        removeUnlabelledDetail()
    }

    func setBusinessInfo(type: String) {
        let infoType = BusinessInfoType.init(rawValue: type)
        var contact = labelledScannedDetails.value
        let unlabelledDetails = unlabelledScannedDetailsArray

        let unlabelledDetail = unlabelledDetails[currentUnlabelledDetailIndex!]

        switch infoType {
        case .companyName:
            contact.businessInfo?.companyName = unlabelledDetail
        case .role:
            contact.businessInfo?.role = unlabelledDetail
        case .workLocation:
            contact.businessInfo?.companyAddress = unlabelledDetail
        case .website:
            contact.businessInfo?.website = unlabelledDetail
        case .none:
            return
        }

        labelledScannedDetails.accept(contact)
        removeUnlabelledDetail()
    }

    private func removeUnlabelledDetail() {
        var unlabelledDetails = unlabelledScannedDetailsArray
        unlabelledDetails.remove(at: currentUnlabelledDetailIndex!)
        unlabelledScannedDetails.accept(unlabelledDetails)
    }

}
