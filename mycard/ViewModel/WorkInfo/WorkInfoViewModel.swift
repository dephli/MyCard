//
//  WorkInfoViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/12/21.
//

import Foundation

class WorkInfoViewModel {
    var businessInfo: BusinessInfo = BusinessInfo()
    var contact: Contact {
        CardManager.shared.currentEditableContact
    }
    var companyName: String? {
        get {
            return businessInfo.companyName
        }

        set {
            businessInfo.companyName = newValue
        }
    }
    var role: String? {
        get {
            return businessInfo.role
        }

        set {
            businessInfo.role = newValue
        }
    }

    var address: String? {
        get {
            return businessInfo.companyAddress
        }

        set {
            businessInfo.companyAddress = newValue
        }
    }

    var bindError: ((Error) -> Void)!
    var bindSaveSuccessful: (() -> Void)!
    var bindContinue: (() -> Void)!
    var continueButtonTitle = "Continue"
    let contactType = CardManager.shared.currentContactType

    init() {
        if let businessInfo = contact.businessInfo {
            self.businessInfo = businessInfo
        }
        if contactType == .editContactCard || contactType == .editPersonalCard {
            continueButtonTitle = "Save"
        }
    }

    func saveCurrentFlowData() {
        var contactCopy = contact
        contactCopy.businessInfo = self.businessInfo
        CardManager.shared.currentEditableContact = contactCopy
    }

    func saveCardData() {
        saveCurrentFlowData()
        if contactType == .editContactCard || contactType == .editPersonalCard {
            saveCard()
        } else {
            bindContinue()
        }

    }

    func saveCard() {
        switch contactType {
        case .editContactCard:
            editContactCard()
        case .editPersonalCard:
            editPersonalCard()
        default:
            return
        }
    }

    func editContactCard() {
        CardManager.shared.trim()
        FirestoreService.shared.editContactCard(contact: contact) { [self](_, error) in
            if let error = error {
                bindError!(error)
            } else {
                CardManager.shared.currentContactDetails = contact
                CardManager.shared.reset()
                bindSaveSuccessful!()
            }
        }
    }

    internal func editPersonalCard() {
        CardManager.shared.trim()
        FirestoreService.shared.editPersonalCard(contact: contact) { (_, error) in
            if let error = error {
                self.bindError!(error)
            } else {
                CardManager.shared.reset()
                self.bindSaveSuccessful!()
            }
        }
    }
}
