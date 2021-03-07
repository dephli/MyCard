//
//  UIViewAlert.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/5/21.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(
            title: NSLocalizedString("OK", comment: "Default action"),
            style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            })
        alert.addAction(action)

        self.present(alert, animated: true, completion: nil)
    }
}
