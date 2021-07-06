//
//  CardDetailsViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/9/21.
//

import Foundation
import RxCocoa
import ContactsUI

class CardDetailsViewModel {
    var contact: Contact {
        CardManager.shared.currentContactDetails
    }

    var role: String {
        contact.businessInfo?.role ?? ""
    }
    var fullName: String {
        contact.name.fullName!
    }
    var nameInitials = ""
    var noteTextColor = K.Colors.Black
    var bindError: ((Error) -> Void)?
    var bindTriggerEmailList: (([Email]) -> Void)?
    var bindTriggerPhoneNumberList: (([PhoneNumber]) -> Void)?
    var bindCardDeleted: (() -> Void)?
    var contactImage: UIImage?
    var avatarImageUrl: String? {
        contact.profilePicUrl
    }
    var note: String? {
        let note = contact.note
        if note == nil || note == "" {
            noteTextColor = K.Colors.Blue
            return "Add a note"
        } else {
            noteTextColor = K.Colors.Black
            return note
        }
    }

    init(contactImage: UIImage?) {
        self.contactImage = contactImage
        self.setNameInitials()
    }

    private func setNameInitials() {
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

    internal func createCNContact() -> CNMutableContact {
        let phoneContact = CNMutableContact()
        phoneContact.familyName = contact.name.lastName ?? ""
        phoneContact.givenName = contact.name.firstName ?? ""
        phoneContact.jobTitle = contact.businessInfo?.role ?? ""
        phoneContact.note = contact.note ?? ""
        phoneContact.organizationName = contact.businessInfo?.companyName ?? ""
        phoneContact.note = contact.note ?? ""

        if let image = contactImage {
            let imageData = image.jpegData(compressionQuality: 0.5)
            phoneContact.imageData = imageData

        }

        filteredEmails(phoneContact)

        filteredPhoneNumbers(phoneContact)

        return phoneContact
    }

    internal func editNote() {
        CardManager.shared.currentContactType = .editContactCard
        CardManager.shared.currentEditableContact = contact
    }

    internal func deleteCard() {
        FirestoreService.shared.deleteContactCard(contact: contact) { (error) in
            if let error = error {
                self.bindError!(error)
            } else {
                self.bindCardDeleted!()
            }
        }
    }

    private func filteredEmails(_ phoneContact: CNMutableContact) {
        //        filter emails
        if let emails = contact.emailAddresses {
            let emailMap = emails.map { (email) -> CNLabeledValue<NSString> in
                var contactEmail: Any?
                if email.type == .Work {
                    contactEmail = CNLabeledValue(label: CNLabelWork, value: email.address as NSString)
                } else if email.type == .Personal {
                    contactEmail = CNLabeledValue(label: CNLabelHome, value: email.address as NSString)
                } else if email.type == .Other {
                    contactEmail = CNLabeledValue(label: CNLabelOther, value: email.address as NSString)
                }
                return contactEmail as! CNLabeledValue<NSString>
            }

            phoneContact.emailAddresses = emailMap
        }
    }

    private func filteredPhoneNumbers(_ phoneContact: CNMutableContact) {
        //        filter contact
        if let phoneNumbers = contact.phoneNumbers {

            let phoneNumberMap = phoneNumbers.filter({ (phoneNumber) -> Bool in
                return phoneNumber.number != ""
            })
            .map { (phoneNumber) -> CNLabeledValue<CNPhoneNumber> in
                var contactPhoneNumber: Any?

                if phoneNumber.type == .Home {
                    contactPhoneNumber = CNLabeledValue(
                        label: CNLabelHome,
                        value: CNPhoneNumber(stringValue: phoneNumber.number ?? ""))
                } else if phoneNumber.type == .Mobile {
                    contactPhoneNumber = CNLabeledValue(
                        label: CNLabelPhoneNumberMobile,
                        value: CNPhoneNumber(stringValue: phoneNumber.number ?? ""))
                } else if phoneNumber.type == .Work {
                    contactPhoneNumber = CNLabeledValue(
                        label: CNLabelWork,
                        value: CNPhoneNumber(stringValue: phoneNumber.number ?? ""))
                } else if phoneNumber.type == .Other {
                    contactPhoneNumber = CNLabeledValue(
                        label: CNLabelOther,
                        value: CNPhoneNumber(stringValue: phoneNumber.number ?? ""))
                }

                return contactPhoneNumber as! CNLabeledValue<CNPhoneNumber>
            }
            if !phoneNumberMap.isEmpty {
                phoneContact.phoneNumbers = phoneNumberMap
            }
        }
    }

    func mailAction() {
        let error = CustomError(str: "Please add an email") as Error

        guard let emailAddresses = contact.emailAddresses else {
            self.bindError!(error)
            return
        }

        let noEmail = emailAddresses.allSatisfy({ (email) -> Bool in
            return email.address == ""
        })

        if noEmail {
            self.bindError!(error)
            return
        }

        if emailAddresses.count == 1 {
            openEmail(emailAddress: emailAddresses.first!.address)
        } else {
            bindTriggerEmailList!(emailAddresses)
        }
    }

    func phoneAction() {
        let error = CustomError(str: "Please add a phone number to make a call") as Error

        guard let phoneNumbers = contact.phoneNumbers else {
            self.bindError!(error)
            return
        }

        let noNumber = phoneNumbers.allSatisfy({ (phoneNumber) -> Bool in
            return phoneNumber.number == ""
        })

        if noNumber {
            self.bindError!(error)
            return
        }

        if phoneNumbers.count == 1 {
            callNumber(number: phoneNumbers.first!.number!)
        } else {
            bindTriggerPhoneNumberList!(phoneNumbers)
        }
    }

    func addressAction() {
        if let address = contact.businessInfo?.companyAddress {
            let baseUrl: String = "http://maps.apple.com/?q="
            let encodedName = address.addingPercentEncoding(withAllowedCharacters: .urlUserAllowed)
            let finalURL = baseUrl + encodedName!

            if let url = URL(string: finalURL) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        } else {
            let error = CustomError(str: "No address for this contact") as Error
            self.bindError!(error)
        }
    }

    func openEmail(emailAddress: String) {
        if let url = URL(string: "mailto:\(emailAddress)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let error = CustomError(str: "Could not open email") as Error
            self.bindError!(error)
        }
    }

    func callNumber(number: String) {
        let number = number.replacingOccurrences(of: " ", with: "")
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let error = CustomError(str: "Please add an phone number to make a call") as Error
            self.bindError!(error)
        }
    }

    func addContactToCardManager() {
        let manager = CardManager.shared
        manager.currentContactType = .editContactCard
        manager.currentEditableContact = contact
        SocialMediaManger.manager.list.accept( contact.socialMediaProfiles ?? [])
        if let phoneNumbers = contact.phoneNumbers {
            PhoneNumberManager.manager.replace(with: phoneNumbers)
        }
        if let emails = contact.emailAddresses {
            EmailManager.manager.replace(with: emails)
        }
    }

}
