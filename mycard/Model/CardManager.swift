//
//  ContactManager.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 1/12/21.
//

import Foundation
import RxCocoa

class CardManager {
    /**
     This is a singleton that holds the single source of truth for creating, editing (or displaying the details
     of a network ) card. Uses RxCocoa to save the state
     */
    private init () {}

//    instance to be called in order to use any property here
    static let shared = CardManager()

    let contact: BehaviorRelay<Contact> =
        BehaviorRelay(value: Contact(name: Name()))

    private let contactDetails: BehaviorRelay<Contact> = BehaviorRelay(value: Contact(name: Name()))

    private let contactType: BehaviorRelay<CardType> = BehaviorRelay(value: CardType.createContactCard)

    private let personalCards: BehaviorRelay<[Contact]> = BehaviorRelay(value: [])

    private let contactCards: BehaviorRelay<[Contact]> = BehaviorRelay(value: [])

//    image uploaded by user to be used as the contact image of the current contact
    var contactImage: UIImage?

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
        /**
         This removes any email, social media, phone number or contact in state
         */
        currentEditableContact = Contact(name: Name())
        EmailManager.manager.replace(with: [])
        PhoneNumberManager.manager.replace(with: [])
        SocialMediaManger.manager.list.accept([])
        contactImage = nil
    }

    enum CardType {
        /**
         All create, and edit actions of Personal cards or Contact cards go through one flow.
         This enum is to differentiate between the flow be it a create or edit of Personal card
         or a create or edit of a Contact(Network) card.
         */
        case createPersonalCard
        case createContactCard
        case editPersonalCard
        case editContactCard
        case createFirstCard
    }

}
