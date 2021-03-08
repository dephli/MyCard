//
//  VerifyNumberViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/8/21.
//

import Foundation

class VerifyNumberViewModel: NSObject {
    
    var bindErrorObject: ((Error) -> Void)?
    var bindVerifyRegularAuth: (() -> Void)?
    var bindVerifyPreNumberChange: (() -> Void)?
    var bindVerifyPhoneNumberChange: (() -> Void)?
    
    func submitCode(with code: String, type: AuthFlowType) {
        switch type {
        case .authentication:
            verifyRegularAuth(code)
        case .confirmPhoneNumber:
            verifyPreNumberChange(code)
        case .changePhoneNumber:
            verifyNumberChange(code)
        }
    }
    
    private func verifyNumberChange(_ code: String) {
        UserManager.auth.updatePhoneNumber(verificationCode: code) { [self](error) in
            if let error = error {
                bindErrorObject!(error)
            } else {
                bindVerifyPhoneNumberChange!()
            }
        }
    }

    private func verifyRegularAuth(_ code: String) {
        UserManager.auth.submitCode(with: code) {
            [self] (error) in
            if let error = error {
                bindErrorObject!(error)
            } else {
                bindVerifyRegularAuth!()
            }
        }
    }
    
    private func verifyPreNumberChange(_ code: String) {
        UserManager.auth.submitCode(with: code) {[self] (error) in
            if let error = error {
                bindErrorObject!(error)
            } else {
                bindVerifyPreNumberChange!()
            }
        }
    }
}
