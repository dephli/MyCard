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
                guard let snapshot = documentSnapshot else {
                    return onActionComplete(error, nil)
                }
                
                let contact = try? snapshot.data(as: Contact.self)
                
                self.addContactToUser(uid: AuthService.uid, contactId: contact!.id!) {
                    if let error = $0 {
                        onActionComplete(error, nil)
                    }
                }
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
        let contactRef = db.collection(K.Firestore.cardsCollectionName)
        contactRef.addSnapshotListener { (snapshot, error) in
            
            let contacts = snapshot?.documents.compactMap({ (document) -> Contact? in
                return try? document.data(as: Contact.self)
            })
            onActionComplete(nil, contacts)
        }

    }

}
