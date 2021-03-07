//
//  User.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/10/20.
//

import Foundation
import RxSwift
import RxCocoa
import Security
import FirebaseFirestore

struct UserManager {

    private init () {}

    static let auth = UserManager()

    var user: BehaviorRelay<User> = BehaviorRelay(value: User())

    var phoneNumber: BehaviorRelay<String> = BehaviorRelay(value: "")

    let authService = AuthService()

    func phoneNumberAuth(with phoneNumber: String, onActionComplete: @escaping (Error?) -> Void) {
        authService.register(phoneNumber: phoneNumber) { (error) in
            if let error = error {
                onActionComplete(error)
                return
            }
            self.phoneNumber.accept(phoneNumber)
            onActionComplete(nil)
        }
    }

    func updateUser(with user: User, onActionComplete: @escaping (Error?) -> Void) {
        authService.updateUser(user: user) { (error) in
            onActionComplete(error)
        }
    }

    func updatePhoneNumber(verificationCode: String, onActionComplete: @escaping (Error?) -> Void) {
         authService.updatePhoneNumber(verificationCode: verificationCode) { (error) in
            onActionComplete(error)
        }
    }

    func resendtoken(onActionComplete: @escaping (Error?) -> Void) {
        self.phoneNumberAuth(with: self.phoneNumber.value) { (error) in
            onActionComplete(error)
        }
    }

    func submitCode(with code: String, onActionComplete: @escaping (Error?) -> Void) {
        authService.submitVerificationCode(code: code) { (_, error) in
            onActionComplete(error)
        }
    }

    func logout(onActionComplete: (Error?) -> Void) {
        do {
            try authService.logout()
            KeychainService().clearToken()
            onActionComplete(nil)
        } catch let error {
            onActionComplete(error)
        }
    }
}
