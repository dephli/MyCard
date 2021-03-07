//
//  UINavigationControllerExtension.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/7/20.
//

import Foundation
import UIKit

extension UINavigationController {

    @IBInspectable
    var shadowImage: UIImage? {
        get {
            return self.navigationBar.shadowImage
        }
        set {
            if let image = newValue {
                self.navigationBar.shadowImage = image
            }
        }
    }
}
