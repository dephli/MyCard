//
//  NavigationController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/8/20.
//

import Foundation
import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        
        if #available(iOS 13, *) {
            // iOS 13:
            let appearance = navigationBar.standardAppearance
            appearance.configureWithOpaqueBackground()
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            navigationBar.backIndicatorImage = UIImage(named: "arrow.backward")
            navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "arrow.backward")
            navigationBar.standardAppearance = appearance

        } else {
            // iOS 12 and below:
            navigationController?.navigationBar.shadowImage = UIImage()
        }
    }
}
