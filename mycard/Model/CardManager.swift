//
//  ContactManager.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 1/12/21.
//

import Foundation
import RxCocoa

class CardManager {
    private init () {}

    static let shared = CardManager()

    private let contact: BehaviorRelay<Contact> =
        BehaviorRelay(value: Contact(name: Name()))

    private let contactDetails: BehaviorRelay<Contact> = BehaviorRelay(value: Contact(name: Name()))

    private let contactType: BehaviorRelay<CardType> = BehaviorRelay(value: CardType.createContactCard)

    private let personalCards: BehaviorRelay<[Contact]> = BehaviorRelay(value: [])

    private let contactCards: BehaviorRelay<[Contact]> = BehaviorRelay(value: [])

    var createdContactCards: [Contact] {
        get {
            return contactCards.value
        }
        set {
            contactCards.accept(newValue)
        }
    }

    var createdPersonalCards: [Contact] {
        get {return contactCards.value}
        set {personalCards.accept(newValue)}

    }

    var currentContactType: CardType {
        get {
            return contactType.value
        }
        set {
            contactType.accept(newValue)
        }
    }

    var currentEditableContact: Contact {
        get {
            return contact.value
        }
        set {
            contact.accept(newValue)
        }
    }

    var currentContactDetails: Contact {
        get {
            return contactDetails.value
        }
        set {
            contactDetails.accept(newValue)
        }
    }

    func trim() {
        /**
         Emails and Phonenumbers have one created by default with empty strings in
         their input fields. This creates an email or password with an empty address or
         number field when the user decides against inputting a email or password.
         This function is used to clear out those fields
         */
        let contact = currentEditableContact
        currentEditableContact.phoneNumbers = contact.phoneNumbers?.filter({$0.number != ""})
        currentEditableContact.emailAddresses = contact.emailAddresses?.filter({$0.address != ""})

    }

    func reset() {
        contact.accept(Contact(name: Name()))
        EmailManager.manager.replace(with: [])
        PhoneNumberManager.manager.replace(with: [])
        SocialMediaManger.manager.list.accept([])
    }

    enum CardType {
        case createPersonalCard
        case createContactCard
        case editPersonalCard
        case editContactCard
    }

}
