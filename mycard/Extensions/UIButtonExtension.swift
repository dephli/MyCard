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

    @IBInspectable
    var localizableText: String? {
        get {
            return currentTitle
        }
        set {
            UIView.performWithoutAnimation {
                setTitle(NSLocalizedString(newValue!, comment: newValue!), for: .normal)
            }
        }
    }

    func alignTextBelow(spacing: CGFloat = 6.0) {
      if let image = self.imageView?.image {
          let imageSize: CGSize = image.size
          self.titleEdgeInsets = UIEdgeInsets(
            top: spacing,
            left: -imageSize.width,
            bottom: -(imageSize.height),
            right: 0.0)
          let labelString = NSString(string: self.titleLabel!.text!)
        let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font as Any])
          self.imageEdgeInsets = UIEdgeInsets(
            top: -(titleSize.height + spacing),
            left: 0.0, bottom: 0.0,
            right: -titleSize.width)
      }
    }

}
