//
//  SignupViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/8/21.
//

import Foundation

class SignupViewModel: NSObject {
    var bindSignupViewModelToController: (() -> Void)?
    var bindErrorObject: ((Error) -> Void)?

    func authenticateUser(with phoneNumberText: String) {
        UserManager.auth.phoneNumberAuth(with: phoneNumberText ) { [self] (error) in
            if let error = error {
                bindErrorObject!(error)
            } else {
                bindSignupViewModelToController!()
            }
        }
    }
}
