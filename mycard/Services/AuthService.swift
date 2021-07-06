//
//  AuthService.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/10/20.
//

import Foundation
import Firebase

protocol AuthServiceDelegate: AnyObject {
    func register(phoneNumber: String, onActionComplete: @escaping (Error?) -> Void)
    func submitVerificationCode(code: String, onActionComplete: @escaping (User?, Error?) -> Void)
}

class AuthService: AuthServiceDelegate {

    func register(phoneNumber: String, onActionComplete: @escaping (Error?) -> Void) {
        PhoneAuthProvider
            .provider()
            .verifyPhoneNumber(
                phoneNumber,
                uiDelegate: nil
            ) { (verificationId, error) in

            if let error = error {
                onActionComplete(error)
            } else {
                UserDefaults.standard.set(verificationId, forKey: K.authVerificationId)
                onActionComplete(nil)
            }
        }
    }

    func submitVerificationCode(code: String, onActionComplete: @escaping (User?, Error?) -> Void) {
        if let verificationId = UserDefaults.standard.string(
            forKey: K.authVerificationId
        ) {
            let credential = PhoneAuthProvider
                .provider()
                .credential(
                    withVerificationID: verificationId,
                    verificationCode: code
                )

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
                    UserDefaults.standard.setValue(true, forKey: K.hasPreviousAuth)
                    let user = User(
                        name: result?.user.displayName,
                        phoneNumber: result?.user.phoneNumber,
                        uid: result?.user.uid)
                    onActionComplete(user, nil)
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

    func updatePhoneNumber(verificationCode: String, onActionComplete: @escaping (Error?) -> Void) {
        if let verificationId = UserDefaults.standard.string(forKey: K.authVerificationId) {
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationId,
                verificationCode: verificationCode)
            Auth.auth().currentUser?.updatePhoneNumber(credential, completion: { (error) in
                if let error = error {
                    return onActionComplete(error)
                }

                onActionComplete(nil)
            })

        }
    }

    func removeAvatarUrl(completionHandler: @escaping (Error?) -> Void) {

        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        request?.photoURL = nil

        request?.commitChanges(completion: { (error) in
            completionHandler(error)
        })

    }

    func updateUser(user: User, onActionComplete: @escaping (Error?) -> Void) {

        let request = Auth.auth().currentUser?.createProfileChangeRequest()

        if user.avatarImageUrl != nil {

            let imageUrl = URL(string: user.avatarImageUrl!)
            request?.photoURL = imageUrl
        }

        if user.name != nil {
            request?.displayName = user.name!
        }

        request?.commitChanges(completion: { (error) in
            onActionComplete(error)
        })

    }

    func logout() throws {
        try? Auth.auth().signOut()
    }
    static var uid: String? {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser!.uid
        }
        return nil
    }

    static var phoneNumber: String? {
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser!.phoneNumber
        }
        return nil
    }

    static var username: String? {
        guard let user = Auth.auth().currentUser else {return nil}

        if user.displayName?.trimmingCharacters(in: .whitespaces) != "" {
            return Auth.auth().currentUser!.displayName
        }
        return nil
    }

    static var avatarUrl: String? {
        guard let user = Auth.auth().currentUser else {return nil}

        if user.photoURL != nil {
            return user.photoURL?.absoluteString
        }
        return nil
    }

    static var token: String = ""

    static var idToken: String? {
        Auth.auth().currentUser?.getIDToken { (tokenString, _) in
            self.token = tokenString!
            print("hello")
        }
        return self.token
    }
}
