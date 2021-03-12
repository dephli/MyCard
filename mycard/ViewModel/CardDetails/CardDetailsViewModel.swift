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
        CardManager.shared.currentContact
    }
    let role: String
    let fullName: String
    var nameInitials = ""
    var noteTextColor = K.Colors.Black
    var bindError: ((Error) -> Void)?
    var bindTriggerEmailList: (([Email]) -> Void)?
    var bindTriggerPhoneNumberList: (([PhoneNumber]) -> Void)?
    var bindCardDeleted: (() -> Void)?
    var contactImage: UIImage?
    var note: String? {
        let note = CardManager.shared.currentContact.note
        if note == nil || note == "" {
            noteTextColor = K.Colors.Blue
            return "Add a note"
        } else {
            noteTextColor = K.Colors.Black
            return note
        }
    }

    init(contact: Contact) {

        fullName = contact.name.fullName ?? ""
        role = contact.businessInfo?.role ?? ""

        nameInitials = self.setNameInitials(contact)
    }

    private func setNameInitials(_ contact: Contact) -> String {
        var initials = ""
        let firstName = contact.name.firstName?.trimmingCharacters(in: .whitespaces)
        let lastName = contact.name.lastName?.trimmingCharacters(in: .whitespaces)
        if firstName?.isEmpty == false && lastName?.isEmpty == false {
            initials = "\(contact.name.firstName!.prefix(1))\(contact.name.lastName!.prefix(1))"
        } else if firstName?.isEmpty == false && lastName?.isEmpty == true {
            initials = "\(contact.name.firstName!.prefix(2))"
        } else if firstName?.isEmpty == true && lastName?.isEmpty == false {
            initials = "\(contact.name.lastName!.prefix(2))"
        }

        return initials
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

    internal func createContact() {
        FirestoreService.shared.createContact(with: contact) { (error) in
            if let error = error {
                self.bindError!(error)
            } else {
                CardManager.shared.reset()
            }
        }
    }

    internal func editPersonalCard() {
        FirestoreService.shared.editPersonalCard(contact: contact) { (_, error) in
            if let error = error {
                self.bindError!(error)
            } else {
                CardManager.shared.reset()
            }
        }
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

        bindTriggerEmailList!(emailAddresses)
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

        bindTriggerPhoneNumberList!(phoneNumbers)
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
        if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let error = CustomError(str: "Please add an email") as Error
            self.bindError!(error)
        }
    }

    func addContactToCardManager() {
        let manager = CardManager.shared

        manager.setContactType(type: .editContactCard)
        manager.setContact(with: contact )
        SocialMediaManger.manager.list.accept( contact.socialMediaProfiles ?? [])
        if let phoneNumbers = contact.phoneNumbers {
            PhoneNumberManager.manager.list.accept(phoneNumbers)
        }
        if let emails = contact.emailAddresses {
            EmailManager.manager.list.accept(emails)
        }
    }

}
