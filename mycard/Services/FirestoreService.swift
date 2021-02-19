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


    func createContact(with contact:Contact, onActionComplete: @escaping (Error?) -> Void) {
        let docRef = db.collection(K.Firestore.usersCollectionName).document(AuthService.uid!)
        

        let encoder = Firestore.Encoder()
        _ = try? docRef.collection(K.Firestore.addedCardsCollectionName).addDocument(from: contact, encoder: encoder) { (error) in
            return onActionComplete(error)
        }
        
        return onActionComplete(nil)
        
    }
    
    func createUser(with user: User, onActionComplete: @escaping (Error?) ->Void) {
        let docRef = db.collection(K.Firestore.usersCollectionName)
        do {
            try
                docRef.document(AuthService.uid!).setData(from: user, merge: true)
            onActionComplete(nil)
            
        } catch {
            return onActionComplete(error)
        }
    }
    
    func addContactToUser(uid: String, contactId: String, onActionComplete: @escaping(Error?) -> Void) {
        let userRef = db.collection(K.Firestore.usersCollectionName)
        let contactRef = db.collection(K.Firestore.cardsCollectionName).document(contactId)
        
        userRef.document(uid).updateData([
            "contactCards": FieldValue.arrayUnion([contactRef])
        ]) {
            if let error = $0 {
                return onActionComplete(error)
            }
            return onActionComplete(nil)
        }
    }
    
    func getAllContacts(uid: String, onActionComplete: @escaping(Error?, [Contact]?) -> Void) {
        let docRef = db.collection(K.Firestore.usersCollectionName).document(uid).collection(K.Firestore.addedCardsCollectionName)
        
        docRef.addSnapshotListener { (snapshot, error) in
            if let error = error {
                onActionComplete(error, nil)
                return
            }
            
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
