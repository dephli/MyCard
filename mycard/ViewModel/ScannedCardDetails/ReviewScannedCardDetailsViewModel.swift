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

    private let contactType = CardManager.shared.currentContactType

    var noteIsHidden = false

    var currentUnlabelledDetailIndex: Int?

    var bindSaveFirstPersonalContactSuccessful: (() -> Void)?

    var bindSaveContactSuccessful: (() -> Void)?

    var bindError: ((Error) -> Void)?

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
            CardManager.shared.currentEditableContact
        }
        set {
            CardManager.shared.currentEditableContact = newValue
        }
    }

    init(scannedDetailsArray: [String], scannedDetails: String) {
        splitDetails(scannedDetailsArray, scannedDetails)
        if contactType == .createPersonalCard || contactType == .createFirstCard {
            noteIsHidden = true
        }
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
        labelledContact = contact
        unlabelledScannedDetails.accept(unlabelledArray)
    }

    func duplicateDetail(at index: Int) {
        let unlabelledDetails = unlabelledScannedDetailsArray
        let detail = unlabelledDetails[index]
        let pasteboard = UIPasteboard.general
        pasteboard.string = detail
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
        case "linkedin":
            untagSocialMedia(type: args.type)
            setSocialMedia(type: SocialMediaType.init(rawValue: args.type)!)
        case "facebook":
            untagSocialMedia(type: args.type)
            setSocialMedia(type: SocialMediaType.init(rawValue: args.type)!)
        case "instagram":
            untagSocialMedia(type: args.type)
            setSocialMedia(type: SocialMediaType.init(rawValue: args.type)!)
        case "twitter":
            untagSocialMedia(type: args.type)
            setSocialMedia(type: SocialMediaType.init(rawValue: args.type)!)

        default:
            return
        }
    }

    func editLabelledDetail(_ detail: String, args: (type: String, index: Int)) {
        var tempArray = unlabelledScannedDetailsArray
        tempArray.append(detail)
        currentUnlabelledDetailIndex = tempArray.count - 1
        unlabelledScannedDetailsArray = tempArray

        switch args.type.lowercased() {
        case "full name":
            setFullName()
        case "phone number":
            editPhoneNumber(detail, index: args.index)
        case "email address":
            editEmail(detail, index: args.index)
        case "company name":
            setBusinessInfo(type: "Company name")
        case "role":
            setBusinessInfo(type: "Role")
        case "work address":
            setBusinessInfo(type: "Work address")
        case "website":
            setBusinessInfo(type: "Website")
        case "linkedin":
            setSocialMedia(type: SocialMediaType.init(rawValue: args.type)!)
        case "facebook":
            setSocialMedia(type: SocialMediaType.init(rawValue: args.type)!)
        case "instagram":
            setSocialMedia(type: SocialMediaType.init(rawValue: args.type)!)
        case "twitter":
            setSocialMedia(type: SocialMediaType.init(rawValue: args.type)!)
        default:
            return
        }
    }

    func editUnlabelledDetail(_ detail: String, index: Int) {
        var unlabelledDetails = unlabelledScannedDetailsArray
        unlabelledDetails[index] = detail
        unlabelledScannedDetailsArray = unlabelledDetails
    }

    fileprivate func editPhoneNumber(_ newDetail: String, index: Int) {
        var contact = labelledContact
        contact.phoneNumbers?[index].number = newDetail
        labelledContact = contact
    }

    fileprivate func editEmail(_ newDetail: String, index: Int) {
        var contact = labelledContact
        contact.emailAddresses?[index].address = newDetail
        labelledContact = contact
    }

    func setFullName() {
        var contact = self.labelledContact
        let unlabelledDetails = unlabelledScannedDetailsArray
        contact.name.fullName = unlabelledDetails[currentUnlabelledDetailIndex!]
        self.labelledContact = contact
        removeUnlabelledDetail()
    }

    func setPhoneNumber(type: String) {
        var contact = labelledContact
        let unlabelledDetails = unlabelledScannedDetailsArray

        let phoneNumber = PhoneNumber(
            type: PhoneNumberType.init(rawValue: type)!,
            number: unlabelledDetails[currentUnlabelledDetailIndex!])
        contact.phoneNumbers?.append(phoneNumber)
        labelledContact = contact
        removeUnlabelledDetail()

    }

    func setEmail(type: String) {
        var contact = labelledContact
        let unlabelledDetails = unlabelledScannedDetailsArray

        let email = Email(
            type: EmailType.init(rawValue: type)!,
            address: unlabelledDetails[currentUnlabelledDetailIndex!]
        )
        contact.emailAddresses?.append(email)
        labelledContact = contact
        removeUnlabelledDetail()
    }

    func setBusinessInfo(type: String) {
        let infoType = BusinessInfoType.init(rawValue: type)
        var contact = labelledContact
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

        labelledContact = contact
        removeUnlabelledDetail()
    }

    func setSocialMedia(type: SocialMediaType) {
        var contact = labelledContact
        let unlabelledDetails = unlabelledScannedDetailsArray
        let unlabelledDetail = unlabelledDetails[currentUnlabelledDetailIndex!]
        if contact.socialMediaProfiles?.contains(where: {$0.type == type}) ?? false {
            let index = contact.socialMediaProfiles?.firstIndex {$0.type == type}
            contact.socialMediaProfiles![index!].usernameOrUrl = unlabelledDetail
        } else {
            let socialMedia = SocialMedia(usernameOrUrl: unlabelledDetail, type: type)
            var profiles = contact.socialMediaProfiles ?? []
            profiles.append(socialMedia)
            contact.socialMediaProfiles = profiles
        }
        labelledContact = contact
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

    func changeToSocialMedia(name: String, index: Int, type: String) {
        self.untagLabelledDetail(name: name, index: index)
        self.currentUnlabelledDetailIndex = unlabelledScannedDetailsArray.count - 1
        self.setSocialMedia(type: SocialMediaType.init(rawValue: type)!)
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
        case "email address":
            untagEmailAddress(index)
        case "company name":
            untagCompanyName()
        case "role":
            untagRole()
        case "work address":
            untagWorkAddress()
        case "website":
            untagWebsite()
        case "linkedin":
            untagSocialMedia(type: name)
        case "facebook":
            untagSocialMedia(type: name)
        case "instagram":
            untagSocialMedia(type: name)
        case "twitter":
            untagSocialMedia(type: name)
        default:
            return
        }
    }

    func untagSocialMedia(type: String) {
        var tempArray = unlabelledScannedDetailsArray
        var contact = labelledContact
        let index = contact.socialMediaProfiles?.firstIndex {$0.type.rawValue == type}
        if let index = index {
            tempArray.append(contact.socialMediaProfiles![index].usernameOrUrl)
            contact.socialMediaProfiles?.remove(at: index)
        }
        labelledContact = contact
        unlabelledScannedDetailsArray = tempArray
    }

    func findDetail(name: String, index: Int) -> String {
        var ans = ""
        switch name.lowercased() {
        case "full name":
            ans = self.labelledContact.name.fullName ?? ""
        case "phone number":
            ans = self.labelledContact.phoneNumbers?[index].number ?? ""
        case "email address":
            ans = self.labelledContact.emailAddresses?[index].address ?? ""
        case "company name":
            ans = self.labelledContact.businessInfo?.companyName ?? ""
        case "role":
            ans = self.labelledContact.businessInfo?.role ?? ""
        case "work address":
            ans = self.labelledContact.businessInfo?.companyAddress ?? ""
        case "website":
            ans = self.labelledContact.businessInfo?.website ?? ""
        case "linkedin":
            ans = self.labelledContact.socialMediaProfiles!.filter({ $0.type.rawValue == name}).first!.usernameOrUrl
        case "instagram":
            ans = self.labelledContact.socialMediaProfiles!.filter({ $0.type.rawValue == name}).first!.usernameOrUrl
        case "facebook":
            ans = self.labelledContact.socialMediaProfiles!.filter({ $0.type.rawValue == name}).first!.usernameOrUrl
        case "twitter":
            ans = self.labelledContact.socialMediaProfiles!.filter({ $0.type.rawValue == name}).first!.usernameOrUrl
        default:
            ans = ""
        }
        return ans
    }

    func findDetail(index: Int) -> String {
        return unlabelledScannedDetailsArray[index]
    }

    func createContactCard() {
        let personalInfoViewModel = PersonalInfoViewModel()
        if let fullname = labelledContact.name.fullName {
            personalInfoViewModel.fullName = fullname
            personalInfoViewModel.splitFullname()
            var contact = labelledContact
            contact.name.prefix = personalInfoViewModel.prefix
            contact.name.suffix = personalInfoViewModel.suffix
            contact.name.firstName = personalInfoViewModel.firstName
            contact.name.lastName = personalInfoViewModel.lastName
            contact.name.middleName = personalInfoViewModel.middleName
            labelledContact = contact
        }

        if contactType == .createPersonalCard || contactType == .createFirstCard {
            createPersonalCard(contact: labelledContact)
        } else {
            createCard(contact: labelledContact)
        }

    }

    private func createCard(contact: Contact) {
        FirestoreService.shared.createContact(
            with: labelledContact
        ) { [self](error, _) in
            if let error = error {
                bindError!(error)
            } else {
                bindSaveContactSuccessful!()
            }
        }
    }

    private func createPersonalCard(contact: Contact) {
        FirestoreService.shared.createPersonalCard(with: labelledContact) {[self] (error, _) in
            if let error = error {
                self.bindError!(error)
            } else {
                    if contactType == .createFirstCard {
                        bindSaveFirstPersonalContactSuccessful!()
                } else {
                    bindSaveContactSuccessful!()
                }
            }
        }
    }

}
