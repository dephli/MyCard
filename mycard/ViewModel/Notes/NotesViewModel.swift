//
//  NotesViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/9/21.
//

import Foundation

class NotesViewModel: NSObject {

    var bindNoteSaved: (() -> Void)?
    var bindError: ((Error?) -> Void)?
    private var contact = CardManager.shared.currentEditableContact
    private var contactType = CardManager.shared.currentContactType
    var note: String {
        contact.note ?? ""
    }

    private func editContact() {
        if contactType == .editContactCard {
            FirestoreService.shared.editContactCard(contact: contact) { (contact, error) in
                if let error = error {
                    self.bindError!(error)
                } else {
                    CardManager.shared.currentContactDetails = contact!
                    self.bindNoteSaved!()
                }
            }
        }
    }

    func saveNote(note: String) {
        if note.isEmpty {
            contact.note = nil
        } else {
            contact.note = note
        }

        if contact.id != nil {
            editContact()
        } else {
            CardManager.shared.currentEditableContact = contact
            CardManager.shared.currentContactDetails = contact
            self.bindNoteSaved!()
        }
    }
}
