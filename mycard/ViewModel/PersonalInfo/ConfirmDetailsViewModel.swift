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
        CardManager.shared.currentEditableContact
    }
    let role: String
    let fullName: String
    var nameInitials = ""
    var note: String {
        if contact.note == nil || contact.note == "" {
            noteTextColor = K.Colors.Blue
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
    var noteIsHidden = false
    private let contactType = CardManager.shared.currentContactType

    init(contact: Contact) {
        fullName = contact.name.fullName ?? ""
        role = contact.businessInfo?.role ?? ""

        self.setNameInitials()

        if contactType == .editContactCard || contactType == .editPersonalCard {
            saveButtonTitle = "Edit card"
        }

        if contactType == .createPersonalCard || contactType == .createFirstCard {
            noteIsHidden = true
        }
    }

    private func setNameInitials() {
        /**
         Takes the first letter of the firstName and lastName and creates an initials out of it.
         If no firstName exists, it uses the first two letters of the lastName and vice versa. There will be
         no instance where there's no firstName or lastName as such names as input is invalid
         */
        let firstName = contact.name.firstName?.trimmingCharacters(in: .whitespaces)
        let lastName = contact.name.lastName?.trimmingCharacters(in: .whitespaces)
        if firstName != "" && lastName == "" {
            nameInitials = "\(firstName!.prefix(1))"

        } else if lastName != "" && firstName == "" {
            nameInitials = "\(lastName!.prefix(1))"

        } else if lastName != "" && firstName != "" {
            nameInitials = "\(firstName!.prefix(1))\(lastName!.prefix(1))"
        } else if firstName == "" && lastName == "" {
            nameInitials = "\(contact.name.fullName!.prefix(1))"
        }
    }

    func saveCard() {
        /**
         Confirm Details screen is only used for two actions. Creating a personal card or creating
         a network card. As both flows are the same, this function is to differentiate between the
         action of saving a personal card and a network card based on the contact flow type selected
         at the beginning of the action.
         */
        switch contactType {
        case .createContactCard:
            createContactCard()
        case .createPersonalCard:
            createPersonalCard()
        default:
            return
        }
    }

    func createContactCard() {
//        trim out empty emails and phone numbers before creating a network card
        CardManager.shared.trim()
        FirestoreService.shared.createContact(with: contact) { (error, documentId) in
            if let error = error {
                self.bindError!(error)
            } else {
                if let image = CardManager.shared.contactImage {
                    DataStorageService.uploadImage(
                        image: image,
                        documentId: documentId!,
                        imageType: .networkCard
                    ) { (error) in
                        if let error = error {
                            self.bindError!(error)
                        }
                    }
                }
                self.bindSaveSuccessful!()
            }
        }
    }

    private func createPersonalCard() {
        //        trim out empty emails and phone numbers before creating a personal card

        CardManager.shared.trim()
        FirestoreService.shared.createPersonalCard(with: contact) { (error, documentId) in
            if let error = error {
                self.bindError!(error)
            } else {
                if let image = CardManager.shared.contactImage {
                    DataStorageService.uploadImage(
                        image: image,
                        documentId: documentId!,
                        imageType: .personalCard
                    ) { (error) in
                        if let error = error {
                            self.bindError!(error)
                        }
                    }
                }
                self.bindSaveSuccessful!()
            }
        }
    }
}
