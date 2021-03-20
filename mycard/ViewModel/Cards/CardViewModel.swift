//
//  CardViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/13/21.
//

import Foundation
import ContactsUI

class CardViewModel {
    var contacts: [Contact] {
        CardManager.shared.createdContactCards
    }
    var contactsIsEmpty: Bool {
        CardManager.shared.createdContactCards.isEmpty
    }
    var bindError: ((Error) -> Void)!
    var bindContactsRetrievalSuccess: (() -> Void)!
    init() {
        getAllContacts()
    }

    private func getAllContacts() {
        guard let uid = AuthService.uid else {
            let error = CustomError(str: "Inactive user. Login again") as Error
            bindError(error)
            return
        }
        FirestoreService.shared.getAllContacts(uid: uid) {[self] (error) in
            if let error = error {
                bindError(error)
            }
            bindContactsRetrievalSuccess()
        }
    }

    internal func deleteCard(contact: Contact) {
        FirestoreService.shared.deleteContactCard(contact: contact) {[self] (error) in
            if let error = error {
                bindError!(error)
            } else {
                bindContactsRetrievalSuccess()
            }
        }
    }

    internal func createCNContact(contact: Contact, contactImage: UIImage?) -> CNMutableContact {
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

        filteredEmails(phoneContact, contact: contact)

        filteredPhoneNumbers(phoneContact, contact: contact)

        return phoneContact
    }

    private func filteredEmails(_ phoneContact: CNMutableContact, contact: Contact) {
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

    private func filteredPhoneNumbers(_ phoneContact: CNMutableContact, contact: Contact) {
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

    func editContact(contact: Contact) {
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
