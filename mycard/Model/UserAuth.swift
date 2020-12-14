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


struct UserAuth {
    
    static let auth = UserAuth()

    
    var user: BehaviorRelay<User> = BehaviorRelay(value: User(name: nil, phoneNumber: nil, uid: nil))

    
    let authService = AuthService()
    
    
    func phoneNumberAuth(with user: User, onActionComplete: @escaping (Error?) -> Void) {
        if let phoneNumber = user.phoneNumber {
            authService.register(phoneNumber: phoneNumber) { (error) in
                if let error = error {
                    onActionComplete(error)
                    return
                }
                self.user.accept(user)
                onActionComplete(nil)
            }
        }

    }
    
    func submitCode(with code: String, onActionComplete: @escaping (Error?) -> Void) {
        authService.submitVerificationCode(code: code) { (user, error) in
            if let error = error {
                onActionComplete(error)
                return
            }
            
            let name = UserAuth.auth.user.value.name
            
            self.setUserName(with: name!) { (error) in
                if let error = error {
                    onActionComplete(error)
                }
            }
            
            onActionComplete(nil)
        }
    }
    
    func setUserName(with name: String, onActionComplete: @escaping (Error?) -> Void) {
        authService.updateName(with: name) { (user, error) in
            if let error = error {
                onActionComplete(error)
            }
        }
    }
}
