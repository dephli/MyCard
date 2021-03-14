//
//  WorkInfoViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/12/21.
//

import Foundation

class WorkInfoViewModel {
    var contact: Contact {
        CardManager.shared.currentEditableContact
    }
    var companyName = ""
    var role = ""
    var address = ""
    var bindError: ((Error) -> Void)!
    var bindSaveSuccessful: (() -> Void)!
    var bindContinue: (() -> Void)!
    var continueButtonTitle = "Continue"
    let contactType = CardManager.shared.currentContactType

    init() {
        role = contact.businessInfo?.role ?? ""
        companyName = contact.businessInfo?.companyName ?? ""
        address = contact.businessInfo?.companyAddress ?? ""
        if contactType == .editContactCard || contactType == .editPersonalCard {
            continueButtonTitle = "Save"
        }
    }

    func saveCurrentFlowData() {
        var contactCopy = contact

        if contact.businessInfo == nil {
            var businessInfo = BusinessInfo()
            businessInfo.companyAddress = address
            businessInfo.companyName = companyName
            businessInfo.role = role
            contactCopy.businessInfo = businessInfo
        } else {
            contactCopy.businessInfo?.companyAddress = address
            contactCopy.businessInfo?.companyName = companyName
            contactCopy.businessInfo?.role = role
        }
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
