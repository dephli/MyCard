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

    static let `default` = CardManager()

    private let contact: BehaviorRelay<Contact> =
        BehaviorRelay(value: Contact(name: Name()))

    private let contactType: BehaviorRelay<CardType> = BehaviorRelay(value: CardType.createContactCard)

    private let personalCards: BehaviorRelay<[Contact]> = BehaviorRelay(value: [])

    private let contactCards: BehaviorRelay<[Contact]> = BehaviorRelay(value: [])

    func setContactType(type: CardType) {
        contactType.accept(type)
    }

    func setContact(with c: Contact) {
        contact.accept(c)
    }

    func setPersonalCards(with contacts: [Contact]) {
        personalCards.accept(contacts)
    }

    func setContactCards(with contacts: [Contact]) {
        contactCards.accept(contacts)
    }

    func cleanContact() {
        contact.accept(Contact(name: Name()))
    }

    var createdContactCards: [Contact] {
        return contactCards.value
    }

    var createdPersonalCards: [Contact] {
        return contactCards.value
    }

    var currentContactType: CardType {
        return contactType.value
    }

    var currentContact: Contact {
        return contact.value
    }

    func reset() {
        contact.accept(Contact(name: Name()))
        EmailManager.manager.list.accept([Email(type: .Personal, address: "")])
        PhoneNumberManager.manager.list.accept([PhoneNumber(type: .Mobile, number: "")])
        SocialMediaManger.manager.list.accept([])
    }

    enum CardType {
        case createPersonalCard
        case createContactCard
        case editPersonalCard
        case editContactCard
    }

}
