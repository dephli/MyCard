//
//  AuthService.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/10/20.
//

import Foundation
import Firebase
import KeychainAccess

struct AuthService {
    
    

    
    func register(phoneNumber: String, onActionComplete: @escaping (Error?) -> Void) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            if let error = error {
                onActionComplete(error)
            } else {
                UserDefaults.standard.set(verificationId, forKey: "authVerificationID")
                onActionComplete(nil)
            }
        }
    }
    
    func submitVerificationCode(code: String, onActionComplete: @escaping (User?, Error?) -> Void) {
        if let verificationId = UserDefaults.standard.string(forKey: "authVerificationID") {
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    onActionComplete(nil, error)
                    return
                }
                
                result?.user.getIDToken(completion: { (token, error) in
                    if let error = error {
                        onActionComplete(nil, error)
                    }
                    
                    var keychainService = KeychainService()
                    keychainService.token = token
                    UserDefaults.standard.setValue(true, forKey: "hasPreviousAuth")
                    onActionComplete(nil, nil)
                })
            }
    
        }
    }
    
    func updateName(with name: String, onActionComplete: @escaping (User?, Error?) -> Void) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = name
        
        changeRequest?.commitChanges(completion: { (error) in
            if let error = error {
                onActionComplete(nil, error)
                return
            }
            let currentUser = Auth.auth().currentUser
            let name = currentUser?.displayName
            let uid = currentUser?.uid
            
            let user = User(name: name, phoneNumber: nil, uid: uid)
            onActionComplete(user, nil)
            
        })
    }
}
