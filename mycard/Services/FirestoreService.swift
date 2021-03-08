//
//  FirestoreService.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 1/28/21.
//

import Foundation
import FirebaseFirestore

class FirestoreService {

    let db = Firestore.firestore()
    static var manager = FirestoreService()

    private init() {}

// MARK: - Create Contact
    func createContact(with contact: Contact, onActionComplete: @escaping (Error?) -> Void) {
        var contact = contact
        let docRef = db.collection(K.Firestore.usersCollectionName).document(AuthService.uid!)

        contact.createdAt = Timestamp(date: Date())

        do {
            try docRef.collection(K.Firestore.addedCardsCollectionName)
                .document()
                .setData(from: contact)
        } catch {
            return onActionComplete(error.localizedDescription)
        }

        return onActionComplete(nil)

    }

// MARK: - Create Personal Card
    func createPersonalCard(with contact: Contact, onActionComplete: @escaping (Error?) -> Void) {
        var contact = contact
        let docRef = db.collection(K.Firestore.personalCardCollectionName)

        contact.createdAt = Timestamp(date: Date())
        guard let uid = AuthService.uid else {return}
        contact.owner = uid

        do {
            try docRef.document().setData(from: contact)
        } catch {
            return onActionComplete(error)
        }
        return onActionComplete(nil)
    }

// MARK: - Get All Contact Cards
    func getAllContacts(uid: String, onActionComplete: @escaping(Error?) -> Void) {
        let docRef = db.collection(K.Firestore.usersCollectionName)
            .document(uid)
            .collection(K.Firestore.addedCardsCollectionName)
            .order(by: "createdAt", descending: true)

        docRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                onActionComplete(error)
                return
            }

            guard let data = snapshot?.documents else {
                return
            }

            let contacts = data.compactMap { (document) -> Contact in
                return try! document.data(as: Contact.self)!
            }

            CardManager.shared.setContactCards(with: contacts)
            onActionComplete(nil)
        }
    }

// MARK: - get All Personal Cards
    func getPersonalCards(onActionComplete: @escaping(Error?, [Contact]?) -> Void) {
        let docRef = db.collection(K.Firestore.personalCardCollectionName)

        guard let uid = AuthService.uid else {return}
        docRef.whereField("owner", isEqualTo: uid).order(by: "createdAt", descending: true)
            .addSnapshotListener { (snapshot, error) in
            if let error = error {
                onActionComplete(error, nil)
            } else {
                guard let data = snapshot?.documents else {
                    return
                }
                let contacts = data.compactMap { (document) -> Contact in
                    return try! document.data(as: Contact.self)!
                }
                onActionComplete(nil, contacts)

            }
        }
    }

// MARK: - edit Personal Card
    func editPersonalCard(contact: Contact, onActionComplete: @escaping(Contact?, Error?) -> Void) {

        let docRef = db.collection(K.Firestore.personalCardCollectionName)

        guard let id = contact.id else {return}
        do {
            try docRef.document(id).setData(from: contact, merge: true)
            onActionComplete(contact, nil)
        } catch {
            onActionComplete(nil, error)
        }
    }

// MARK: - edit Contact Card
    func editContactCard(contact: Contact, onActionComplete: @escaping(Contact?, Error?) -> Void) {
        let docRef = db.collection(K.Firestore.usersCollectionName)
            .document(AuthService.uid!)
            .collection(K.Firestore.addedCardsCollectionName)

        guard let id = contact.id else {return}
        do {
            var contact = contact
            contact.id = nil
            try docRef.document(id).setData(from: contact, merge: true)
            onActionComplete(contact, nil)
        } catch {
            onActionComplete(nil, error)
        }

    }

// MARK: - delete Contact Card
    func deleteContactCard(
        contact: Contact,
        onActionComplete: @escaping (Error?) -> Void) {
        let docRef = db.collection(K.Firestore.usersCollectionName)
            .document(AuthService.uid!)
            .collection(K.Firestore.addedCardsCollectionName)

        guard let id = contact.id else {return}

        if let profilePicUrl = contact.profilePicUrl {
            if profilePicUrl.trimmingCharacters(in: .whitespaces) != "" {
                DataStorageService.deleteImage(url: profilePicUrl) { error in
                    if let error = error {
                        onActionComplete(error)
                    }
                }
            }
        }

        docRef.document(id).delete { (error) in
            onActionComplete(error)
        }
    }

// MARK: - delete Personal Card
    func deletePersonalCard(
        contact: Contact,
        onActionComplete: @escaping (Error?) -> Void) {
        let docRef = db.collection(K.Firestore.personalCardCollectionName)

        guard let id = contact.id else {return}

        if let profilePicUrl = contact.profilePicUrl {
            if profilePicUrl.trimmingCharacters(in: .whitespaces) != "" {
                DataStorageService.deleteImage(url: profilePicUrl) { error in
                    if let error = error {
                        onActionComplete(error)
                    }
                }
            }
        }

        docRef.document(id).delete { (error) in
            onActionComplete(error)
        }
    }
}
