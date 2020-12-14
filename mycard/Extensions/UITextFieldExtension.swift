//
//  UITextFieldExtension.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/7/20.
//

import Foundation
import UIKit

extension UITextField {
    
    @IBInspectable
    var leftPadding: CGFloat{
        get {
            if let value = self.leftView?.frame.width {
                return value
            } else {
                return 0
            }
        }
        set {
                self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.leftViewMode = .always
        }
    }
    
    @IBInspectable
    var rightPadding: CGFloat{
        get {
            if let value = self.rightView?.frame.width {
                return value
            } else {
                return 0
            }
        }
        set {
                self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: self.frame.size.height))
            self.rightViewMode = .always
        }
    }
}
