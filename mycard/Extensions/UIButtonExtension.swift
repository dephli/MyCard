//
//  UIButtonExtension.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/10/20.
//

import Foundation
import UIKit

extension UIButton {
    
    @IBInspectable
    var leftPadding: CGFloat {
        get {
            return self.contentEdgeInsets.left
        }
        set {
            self.contentEdgeInsets.left = newValue
        }
    }
    
    @IBInspectable
    var rightPadding: CGFloat {
        get {
            return self.contentEdgeInsets.right
        }
        set {
            self.contentEdgeInsets.right = newValue
        }
    }
    
    @IBInspectable
    var rightTitleSpacing: CGFloat {
        get {
            return self.titleEdgeInsets.right
        }
        set {
            self.titleEdgeInsets.right = newValue
        }
    }
    
    @IBInspectable
    var leftTitleSpacing: CGFloat {
        get {
            return self.titleEdgeInsets.left
        }
        set {
            self.titleEdgeInsets.left = newValue
        }
    }
}
