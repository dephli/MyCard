//
//  ConfirmDetailsViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/10/21.
//

import Foundation
import UIKit
import RxCocoa

class ConfirmDetailsViewModel {

    var contact: Contact {
        CardManager.shared.currentContact
    }
    let role: String
    let fullName: String
    var nameInitials = ""
    var note: String {
        if contact.note == nil || contact.note == "" {
            noteTextColor = K.Colors.Blue!
            return "Add a note"
        } else {
            noteTextColor = K.Colors.Black
            return contact.note!
        }
    }
    var noteTextColor = K.Colors.Black
    var bindError: ((Error) -> Void)?
    var bindSaveSuccessful: (() -> Void)?
    var saveButtonTitle = "Create card"
    private let contactType = CardManager.shared.currentContactType

    init(contact: Contact) {
        fullName = contact.name.fullName ?? ""
        role = contact.businessInfo?.role ?? ""

        nameInitials = self.setNameInitials(contact)

        if contactType == .editContactCard || contactType == .editPersonalCard {
            saveButtonTitle = "Edit card"
        }
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

    func saveCard() {
        switch contactType {
        case .createContactCard:
            createContactCard()
        case .createPersonalCard:
            createPersonalCard()
        case .editContactCard:
            editContactCard()
        case .editPersonalCard:
            editPersonalCard()
        }
    }

    internal func createContactCard() {
        FirestoreService.shared.createContact(with: contact) { (error) in
            if let error = error {
                self.bindError!(error)
            } else {
                self.bindSaveSuccessful!()
            }
        }
    }

    func editContactCard() {
        FirestoreService.shared.editContactCard(contact: contact) { (_, error) in
            if let error = error {
                self.bindError!(error)
            } else {
                self.bindSaveSuccessful!()
            }
        }
    }

    private func createPersonalCard() {
        FirestoreService.shared.createPersonalCard(with: contact) { (error) in

            if let error = error {
                self.bindError!(error)
            } else {
                self.bindSaveSuccessful!()
            }
        }
    }

    internal func editPersonalCard() {
        FirestoreService.shared.editPersonalCard(contact: contact) { (_, error) in
            if let error = error {
                self.bindError!(error)
            } else {
                self.bindSaveSuccessful!()
            }
        }
    }
}
