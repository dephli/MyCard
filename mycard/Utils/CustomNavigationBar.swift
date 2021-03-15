//
//  CustomNavigationBar.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/8/20.
//

import Foundation
import UIKit

class CustomNavigationBar: UINavigationBar {
    func setup(backIndicatorImage indicatorImage: String) {

        self.backIndicatorTransitionMaskImage = UIImage(named: indicatorImage)
        self.backIndicatorImage = UIImage(named: "xmark")

        if #available(iOS 13, *) {
            // iOS 13:
            let appearance = self.standardAppearance
            appearance.configureWithOpaqueBackground()
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            self.standardAppearance = appearance
        } else {
            // iOS 12 and below:
            self.shadowImage = UIImage()
        }
    }
}
