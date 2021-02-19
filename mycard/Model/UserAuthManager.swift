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


struct UserAuthManager {
    
    private init () {}
    
    static let auth = UserAuthManager()

    
    var phoneNumber: BehaviorRelay<String> = BehaviorRelay(value:"")

    
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
    
    func updateUser(with user: User, onActionComplete: @escaping (Error?) -> Void) -> Void {
        authService.updateName(with: user.name ?? "") { (firebase_user, error) in
            if let error = error {
                return onActionComplete(error)
            }
            var new_user = user
            new_user.phoneNumber = firebase_user?.phoneNumber

            FirestoreService().createUser(with: new_user) { (error) in
                if let error = error {
                    onActionComplete(error)
                }
            }
            return onActionComplete(nil)
        }
    }
    
    func resendtoken(onActionComplete: @escaping (Error?) -> Void) -> Void{
        self.phoneNumberAuth(with: self.phoneNumber.value) { (error) in
            if let error = error {
                return onActionComplete(error)
            } else {
                return onActionComplete(nil)
            }
        }
    }
    
    func submitCode(with code: String, onActionComplete: @escaping (Error?) -> Void) {
        authService.submitVerificationCode(code: code) { (authUser, error) in
            if let error = error {
                onActionComplete(error)
                return
            }
            
            onActionComplete(nil)
        }
    }
    

}



