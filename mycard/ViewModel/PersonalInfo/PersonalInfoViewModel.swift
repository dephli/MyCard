//
//  PersonalInfoViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/15/21.
//

import Foundation
import UIKit

class PersonalInfoViewModel {
    let prefixTypes = [
        "mr", "ms", "mrs", "dr", "adm", "capt",
        "chief", "cmdr", "col", "gov", "hon",
        "maj", "msgt", "prof", "rev"]

    let suffixes = [
        "phd", "ccna", "obe", "sr", "jr",
        "i", "ii", "iii", "iv", "v", "vi",
        "vii", "viii", "ix", "x", "snr",
        "madame", "jnr" ]

    var userDefinedPrefixType: [String] = []
    var previousPrefix = ""
    var previousFirstName = ""

    var contact = CardManager.shared.currentEditableContact

    var bindHandleError: ((Error, String) -> Void)!

    var socialMedia: [SocialMedia] {
        SocialMediaManger.manager.getAll
    }

    var hideSocialMediaButton: Bool {
        return socialMedia.count == 4 ? true : false
    }

    var socialMediaHeightConstraint: CGFloat {
        return socialMedia.count == 4 ? 0 : 48
    }

    var socialMediaIsEmpty: Bool {
        SocialMediaManger.manager.getAll.isEmpty
    }

    var nextButtonEnabled = false

    var fullName: String {
        get {
            return contact.name.fullName ?? ""
        }

        set {
            contact.name.fullName = newValue
        }
    }

    var avatarUrl: String? {
        get {
            if contact.profilePicUrl == "" ||
                contact.profilePicUrl == nil {
                return nil
            } else {
                return contact.profilePicUrl
            }
        }
        set {
            contact.profilePicUrl = newValue
        }
    }

    var avatarImage: UIImage? {
        get {
            return CardManager.shared.contactImage
        }

        set {
            CardManager.shared.contactImage = newValue
        }
    }

    var prefix: String? {
        get {
            return contact.name.prefix
        }

        set {
            contact.name.prefix = newValue
        }
    }

    var firstName: String? {
        get {
            return contact.name.firstName
        }

        set {
            contact.name.firstName = newValue
        }
    }

    var middleName: String? {
        get {
            return contact.name.middleName
        }

        set {
            contact.name.middleName = newValue
        }
    }

    var lastName: String? {
        get {
            return contact.name.lastName
        }

        set {
            contact.name.lastName = newValue
        }
    }

    var suffix: String? {
        get {
            return contact.name.suffix
        }

        set {
            contact.name.suffix = newValue
        }
    }

    var prefixAndFuncMap: [Int: () -> Void ] {
        return [
            1: prefixAndOneWord,
            2: prefixAndTwoWords,
            3: prefixAndThreeWords,
            4: prefixAndFourWords
        ]
    }
    var noPrefixAndFuncMap: [Int: () -> Void ] {
        return [
            1: noPrefixAndOneWord,
            2: noPrefixAndTwoWords,
            3: noPrefixAndThreeWords
        ]
    }

    var nameArray: [String] {
        let names = self.fullName
            .trimmingCharacters(in: .whitespaces)
            .components(separatedBy: " ")
        let filteredNames = names.filter { (name) -> Bool in
            return name.trimmingCharacters(in: .whitespaces) != ""
        }
        return filteredNames
    }

    func splitFullname() {

        let fullName = self.fullName.trimmingCharacters(in: .whitespaces)
        if fullName.count > 1 {

            resetTextFieldContents()

            let first = nameArray[0].trimmingCharacters(in: .punctuationCharacters)

            if prefixTypes.contains(first.trimmingCharacters(in: .punctuationCharacters).lowercased()) {
                self.prefix = first

                if nameArray.count > 4 {
                    prefixAndFiveOrMoreWords()
                } else {
                    guard let mapFunc = prefixAndFuncMap[nameArray.count] else { return  }
                    mapFunc()
                }

            } else {
                if nameArray.count > 3 {
                    noPrefixAndFourOrMoreWords()
                } else {
                    guard let mapFunc = noPrefixAndFuncMap[nameArray.count] else { return }
                    mapFunc()
                }
            }
        } else {
            resetTextFieldContents()
        }
    }

    private func prefixAndOneWord() {
        self.prefix = nameArray[0]
    }

    private func prefixAndTwoWords() {
        self.lastName = nameArray[1]
    }

    private func prefixAndThreeWords() {
        let containedText = nameArray[nameArray.count-1].trimmingCharacters(in: .punctuationCharacters).lowercased()

        if suffixes.contains(containedText) {
            self.suffix = nameArray[nameArray.count - 1]
            self.lastName = nameArray[nameArray.count-2]
        } else {
            self.firstName = nameArray[nameArray.count-2]
            self.lastName = nameArray[nameArray.count-1]
        }
    }

    private func prefixAndFourWords() {
        let containedText = nameArray[nameArray.count-1].trimmingCharacters(in: .punctuationCharacters).lowercased()
        if suffixes.contains(containedText) {
            self.suffix = nameArray[nameArray.count - 1]
            self.lastName = nameArray[nameArray.count-2]
            self.firstName = nameArray[nameArray.count-3]
        } else {
            self.lastName = nameArray[nameArray.count-1]
            self.middleName = nameArray[nameArray.count-2]
            self.firstName = nameArray[nameArray.count - 3]
        }
    }

    private func prefixAndFiveOrMoreWords() {
        let containedText = nameArray[nameArray.count-1].trimmingCharacters(in: .punctuationCharacters).lowercased()

        if suffixes.contains(containedText) {
            self.suffix = nameArray[nameArray.count - 1]
            self.lastName = nameArray[nameArray.count-2]
            self.middleName = nameArray[nameArray.count-3]
            self.firstName = nameArray[1..<nameArray.count-3].joined(separator: " ")
        } else {
            self.lastName = nameArray[nameArray.count-1]
            self.middleName = nameArray[nameArray.count-2]
            self.firstName = nameArray[1..<nameArray.count-2].joined(separator: " ")
        }
    }

    private func noPrefixAndOneWord() {
        self.firstName = nameArray[0]
    }

    private func noPrefixAndTwoWords() {
        self.firstName = nameArray[0]
        self.lastName = nameArray[1]
    }

    private func noPrefixAndThreeWords() {
        let last = nameArray[nameArray.count - 1]

        if suffixes.contains(last.lowercased().trimmingCharacters(in: .punctuationCharacters)) {
            self.suffix = last
            self.lastName = nameArray[nameArray.count-2]
            self.firstName = nameArray[nameArray.count-3]
        } else {
            self.lastName = last
            self.middleName = nameArray[nameArray.count-2]
            self.firstName = nameArray[0..<nameArray.count-2].joined(separator: " ")
        }
    }

    private func noPrefixAndFourOrMoreWords() {
        let last = nameArray[nameArray.count - 1]
        if suffixes.contains(last.lowercased().trimmingCharacters(in: .punctuationCharacters)) {
            self.suffix = last
            self.lastName = nameArray[nameArray.count-2]
            self.middleName = nameArray[nameArray.count-3]
            self.firstName = nameArray[0..<nameArray.count-3].joined(separator: " ")
        } else {
            self.lastName = last
            self.middleName = nameArray[nameArray.count-2]
            self.firstName = nameArray[0..<nameArray.count-2].joined(separator: " ")
        }
    }

    private func resetTextFieldContents() {
        prefix = ""
        firstName = ""
        middleName = ""
        lastName = ""
        suffix = ""
    }

    func setAllNames() {
        let prefixText = self.prefix!
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: .punctuationCharacters)
        let firstNameText = self.firstName!
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: .punctuationCharacters)
        let middleNameText = self.middleName!
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: .punctuationCharacters)
        let lastNameText = self.lastName!
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: .punctuationCharacters)
        let suffixText = self.suffix!
            .trimmingCharacters(in: .whitespaces)
            .trimmingCharacters(in: .punctuationCharacters)

        let prefix = prefixText != "" ? "\(prefixText) " : ""
        let firstName = firstNameText != "" ? "\(firstNameText) " : ""
        let middleName = middleNameText != "" ? "\(middleNameText) " : ""
        let lastName =  lastNameText != "" ? "\(lastNameText) " : ""
        let suffix = suffixText != "" ? "\(suffixText) " : ""

        fullName = "\(prefix)\(firstName)\(middleName)\(lastName)\(suffix)"

    }

    func saveProfileInfo() {
        contact.name.fullName = self.fullName
        contact.name.firstName = self.firstName
        contact.name.lastName = self.lastName
        contact.name.middleName = self.middleName
        contact.name.prefix = self.prefix
        contact.name.suffix = self.suffix
        contact.phoneNumbers = PhoneNumberManager.manager.numbers
        contact.emailAddresses = EmailManager.manager.emails
        contact.socialMediaProfiles = SocialMediaManger.manager.getAll

        CardManager.shared.currentEditableContact = contact
    }

    func addNewPhoneNumber() {
        let phoneNumbers = PhoneNumberManager.manager.list.value

//        you cannot add a phone number if any is empty
        if !phoneNumbers.contains(where: { (phoneNumber) -> Bool in
            return phoneNumber.number!.isEmpty
        }) {
            PhoneNumberManager.manager.append(with: PhoneNumber(type: .Home, number: ""))
        }
    }

    func addNewEmail() {
        let emails = EmailManager.manager.emails

//        you cannot add another email if any is empty
        if !emails.contains(where: { (email) -> Bool in
            return email.address.isEmpty
        }) {
            EmailManager.manager.append(with: Email(type: .Personal, address: ""))
        }
    }

    func verifyTextFields() {
        let firstName = self.firstName!
                   .trimmingCharacters(in: .whitespaces)
                   .trimmingCharacters(in: .decimalDigits)
        let lastName = self.lastName!
           .trimmingCharacters(in: .whitespaces)
           .trimmingCharacters(in: .decimalDigits)
        let middleName = self.middleName!
           .trimmingCharacters(in: .whitespaces)
           .trimmingCharacters(in: .decimalDigits)

        if firstName.isEmpty && middleName.isEmpty && lastName.isEmpty {
           nextButtonEnabled = false
        } else {
            nextButtonEnabled = true
        }
    }

    func uploadPhoto(image: UIImage, completion: (@escaping() -> Void)) {
        DataStorageService.uploadImage(image: image, type: .network) {[self] (url, error) in
            if error != nil {
                let uploadError = CustomError(
                    str: "Failed to upload image. Please check if you have an internet connection") as Error
                self.bindHandleError(
                    uploadError,
                    NSLocalizedString(
                        "Something Happened",
                        comment: "Image upload failed"
                    )
                )
            } else {
                contact.profilePicUrl = url
                completion()
            }
        }
    }
}
