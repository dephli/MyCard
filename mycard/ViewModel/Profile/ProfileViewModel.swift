//
//  ProfileViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/12/21.
//

import Foundation

class ProfileViewModel {
    var bindError: ((Error) -> Void)!
    var bindFetchPersonalCardsSuccess: (([Contact]) -> Void)!
    var bindDeleteCardSuccess: (() -> Void)?
    init() {
        fetchPersonalCards()
    }

    var cardCount = ""

    private func fetchPersonalCards() {
        FirestoreService.shared.getPersonalCards {[self] (error, cards) in
            if let error = error {
                bindError(error)
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
            PhoneNumberManager.manager.list.accept(phoneNumbers)
        }
        if let emails = contact.emailAddresses {
            EmailManager.manager.list.accept(emails)
        }
    }

    func createPersonalCard() {
        let manager = CardManager.shared
        manager.reset()
        manager.currentContactType = .createPersonalCard
    }

    func deletePersonalCard(contact: Contact) {
        FirestoreService.shared.deletePersonalCard(contact: contact) { (error) in
            if let error = error {
                self.bindError!(error)
            } else {
                self.bindDeleteCardSuccess!()
            }
        }
    }
}
