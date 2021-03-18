//
//  UILabelExtension.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/17/21.
//

import Foundation
import UIKit

extension UILabel {
    @IBInspectable
    var localizableText: String? {
        get {
            return text
        }
        set {
            text = NSLocalizedString(newValue!, comment: newValue!)
        }
    }
}
