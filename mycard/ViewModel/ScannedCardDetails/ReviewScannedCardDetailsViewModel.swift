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
        case workLocation = "Work address"
        case website = "Website"
    }

    var currentUnlabelledDetailIndex: Int?

    let labelledScannedDetails: BehaviorRelay<Contact> = BehaviorRelay(value: Contact(name: Name()))
    let unlabelledScannedDetails: BehaviorRelay<[String]> = BehaviorRelay(value: [])

    var unlabelledScannedDetailsArray: [String] {
        get {
            unlabelledScannedDetails.value
        }
        set {
            unlabelledScannedDetails.accept(newValue)
        }
    }

    var labelledContact: Contact {
        get {
            labelledScannedDetails.value
        }
        set {
            labelledScannedDetails.accept(newValue)
        }
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

    func addDetail(_ detail: String, args: (type: String, subType: String)) {
        var tempArray = unlabelledScannedDetailsArray
        tempArray.append(detail)
        currentUnlabelledDetailIndex = tempArray.count - 1
        unlabelledScannedDetailsArray = tempArray

        switch args.type.lowercased() {
        case "full name":
            untagFullName()
            setFullName()
        case "phone number":
            setPhoneNumber(type: args.subType)
        case "email address":
            setEmail(type: args.subType)
        case "company name":
            untagCompanyName()
            setBusinessInfo(type: "Company name")

        case "role":
            untagRole()
            setBusinessInfo(type: "Role")
        case "work address":
            untagWorkAddress()
            setBusinessInfo(type: "Work address")

        case "website":
            untagWebsite()
            setBusinessInfo(type: "Website")

        default:
            return
        }
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

    func changeToFullName(name: String, index: Int) {
        self.untagLabelledDetail(name: "full name", index: 0)
        self.untagLabelledDetail(name: name, index: index)
        self.currentUnlabelledDetailIndex = unlabelledScannedDetailsArray.count - 1
        self.setFullName()
    }

    func changeToPhoneNumber(name: String, index: Int, type: String) {
        self.untagLabelledDetail(name: name, index: index)
        self.currentUnlabelledDetailIndex = unlabelledScannedDetailsArray.count - 1
        self.setPhoneNumber(type: type)
    }

    func changeToEmail(name: String, index: Int, type: String) {
        self.untagLabelledDetail(name: name, index: index)
        self.currentUnlabelledDetailIndex = unlabelledScannedDetailsArray.count - 1
        self.setEmail(type: type)
    }

    func changeToBusinessInfo(name: String, index: Int, type: String) {
        self.untagLabelledDetail(name: type, index: 0)
        self.untagLabelledDetail(name: name, index: index)
        self.currentUnlabelledDetailIndex = unlabelledScannedDetailsArray.count - 1
        self.setBusinessInfo(type: type)
    }

    fileprivate func untagFullName() {
        var tempArray = unlabelledScannedDetailsArray
        if let name = labelledContact.name.fullName {
            tempArray.append(name)
        }
        unlabelledScannedDetailsArray = tempArray
        var contact = labelledContact
        contact.name.fullName = nil
        labelledContact = contact
    }

    fileprivate func untagPhoneNumber(_ index: Int) {
        var tempArray = unlabelledScannedDetailsArray
        if let number = labelledContact.phoneNumbers?[index].number {
            tempArray.append(number)
        }
        unlabelledScannedDetailsArray = tempArray
        var contact = labelledContact
        contact.phoneNumbers?.remove(at: index)
        labelledContact = contact
    }

    fileprivate func untagEmailAddress(_ index: Int) {
        var tempArray = unlabelledScannedDetailsArray
        if let address = labelledContact.emailAddresses?[index].address {
            tempArray.append(address)
        }
        unlabelledScannedDetailsArray = tempArray
        var contact = labelledContact
        contact.emailAddresses?.remove(at: index)
        labelledContact = contact
    }

    fileprivate func untagCompanyName() {
        var tempArray = unlabelledScannedDetailsArray
        if let company = labelledContact.businessInfo?.companyName {
            tempArray.append(company)
        }
        unlabelledScannedDetailsArray = tempArray
        var contact = labelledContact
        contact.businessInfo?.companyName = nil
        labelledContact = contact
    }

    fileprivate func untagRole() {
        var tempArray = unlabelledScannedDetailsArray
        if let role = labelledContact.businessInfo?.role {
            tempArray.append(role)
        }
        unlabelledScannedDetailsArray = tempArray
        var contact = labelledContact
        contact.businessInfo?.role = nil
        labelledContact = contact
    }

    fileprivate func untagWorkAddress() {
        var tempArray = unlabelledScannedDetailsArray
        if let location = labelledContact.businessInfo?.companyAddress {
            tempArray.append(location)
        }
        unlabelledScannedDetailsArray = tempArray
        var contact = labelledContact
        contact.businessInfo?.companyAddress = nil
        labelledContact = contact
    }

    fileprivate func untagWebsite() {
        var tempArray = unlabelledScannedDetailsArray
        if let website = labelledContact.businessInfo?.website {
            tempArray.append(website)
        }
        unlabelledScannedDetailsArray = tempArray
        var contact = labelledContact
        contact.businessInfo?.website = nil
        labelledContact = contact
    }

    func untagLabelledDetail(name: String, index: Int) {
        switch name.lowercased() {
        case "full name":
            untagFullName()

        case "phone number":
            untagPhoneNumber(index)

        case "email addresses":
            untagEmailAddress(index)

        case "company name":
            untagCompanyName()

        case "role":
            untagRole()

        case "work address":
            untagWorkAddress()

        case "website":
            untagWebsite()

        default:
            return
        }
    }

}
