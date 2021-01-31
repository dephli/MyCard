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


    func createContact(with contact:Contact, onActionComplete: @escaping (Error?, Contact?) -> Void) {
        do {
            let result = try db.collection(K.Firestore.cardsCollectionName).addDocument(from: contact)
            result.getDocument { (documentSnapshot, error) in
                let contact = try? documentSnapshot?.data(as: Contact.self)
                return onActionComplete(nil, contact)
            }

        } catch {
           return onActionComplete(error, nil)
            
        }
    }
    
    func createUser(with user: User, onActionComplete: @escaping (Error?) ->Void) {
        let docRef = db.collection(K.Firestore.usersCollectionName)
        do {
            try
                docRef.document(user.uid!).setData(from: user, merge: true)
            onActionComplete(nil)
            
        } catch {
            return onActionComplete(error)
        }
    }

}
