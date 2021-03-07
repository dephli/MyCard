//
//  UiViewControllerExtension.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/7/20.
//

import Foundation
import UIKit

extension UIViewController {

    func dismissKey() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
    }
}
