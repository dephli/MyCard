//
//  VerifyNumberViewModel.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/8/21.
//

import Foundation

class VerifyNumberViewModel: BaseViewModel {

    var bindVerifyRegularAuth: (() -> Void)?
    var bindVerifyPreNumberChange: (() -> Void)?
    var bindVerifyPhoneNumberChange: (() -> Void)?
    var bindSuccess: (() -> Void)!

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

    func resendCode() {
        UserManager.auth.resendtoken { (error) in
            if let error = error {
                self.bindError("Error Resending Token", error)
            } else {
                self.bindSuccess()
            }
        }
    }

    private func verifyNumberChange(_ code: String) {
        UserManager.auth.updatePhoneNumber(verificationCode: code) { [self](error) in
            if let error = error {
                bindError!("Error Verifying Number", error)
            } else {
                bindVerifyPhoneNumberChange!()
            }
        }
    }

    private func verifyRegularAuth(_ code: String) {
        UserManager.auth.submitCode(with: code) { [self] (error) in
            if let error = error {
                bindError!("Error Verifying Number", error)
            } else {
                bindVerifyRegularAuth!()
            }
        }
    }

    private func verifyPreNumberChange(_ code: String) {
        UserManager.auth.submitCode(with: code) {[self] (error) in
            if let error = error {
                bindError!("Error Verifying Number", error)
            } else {
                bindVerifyPreNumberChange!()
            }
        }
    }

}
