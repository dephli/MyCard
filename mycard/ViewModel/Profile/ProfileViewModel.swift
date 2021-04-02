//
//  ProfileViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/12/21.
//

import Foundation
import UIKit
import ContactsUI

class ProfileViewModel: BaseViewModel {
    var bindFetchPersonalCardsSuccess: (([Contact]) -> Void)!
    var bindDeleteCardSuccess: (() -> Void)?
    override init() {
        super.init()
        fetchPersonalCards()
    }

    var cardCount = ""

    private func fetchPersonalCards() {
        FirestoreService.shared.getPersonalCards {[self] (error, cards) in
            if let error = error {
                bindError("Error Getting Personal Cards", error)
            } else {
                if cards!.isEmpty {
                    cardCount = ""
                } else {
                    let count = cards!.count
                    if count == 1 {
                        cardCount = "\(cards!.count) card"
                    } else {
                        cardCount = "\(cards!.count) cards"
                    }
                }
                bindFetchPersonalCardsSuccess(cards!)
            }
        }
    }

    func editPersonalCard(contact: Contact) {
        CardManager.shared.currentContactType = .editPersonalCard
        CardManager.shared.currentEditableContact = contact

        SocialMediaManger.manager.list.accept( contact.socialMediaProfiles ?? [])
        if let phoneNumbers = contact.phoneNumbers {
            PhoneNumberManager.manager.replace(with: phoneNumbers)
        }
        if let emails = contact.emailAddresses {
            EmailManager.manager.replace(with: emails)
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

        phoneContact.emailAddresses =  filteredEmails(contact) ?? []
        phoneContact.phoneNumbers = filteredPhoneNumbers(contact) ?? []

        return phoneContact
    }
    
    private func filteredEmails(_ contact: Contact) -> [CNLabeledValue<NSString>]? {
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

            return emailMap
        }
        return nil
    }

    private func filteredPhoneNumbers(_ contact: Contact) -> [CNLabeledValue<CNPhoneNumber>]? {
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
                return phoneNumberMap
            }
        }
        return nil
    }


    func createPersonalCard() {
        let manager = CardManager.shared
        manager.reset()
        manager.currentContactType = .createPersonalCard
    }

    func deletePersonalCard(contact: Contact) {
        FirestoreService.shared.deletePersonalCard(contact: contact) { (error) in
            if let error = error {
                self.bindError!("Could Not Perform Action", error)
            } else {
                self.bindDeleteCardSuccess!()
            }
        }
    }
}
