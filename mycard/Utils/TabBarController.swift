//
//  TabBarController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/8/20.
//

import Foundation
import UIKit

/**
 * A custom subclass of `UITabBarController` to use whenever you want
 * to hide the upper border of the `UITabBar`.
 */
class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = UIColor.white

        // Removing the upper border of the UITabBar.
        //
        // Note: Don't use `tabBar.clipsToBounds = true` if you want
        // to add a custom shadow to the `tabBar`!
        //
        if #available(iOS 13, *) {
            // iOS 13:
            let appearance = tabBar.standardAppearance
            appearance.configureWithOpaqueBackground()
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            tabBar.standardAppearance = appearance
        } else {
            // iOS 12 and below:
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
        }
    }
}
