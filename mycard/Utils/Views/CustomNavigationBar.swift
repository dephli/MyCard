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
        self.shadowImage = UIImage()
    }
}
