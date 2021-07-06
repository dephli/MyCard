//
//  AppDelegate.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/5/20.
//

import UIKit
import Firebase

//@available(iOS 13.0, *)
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        Firestore.firestore()
        return true
    }

    var bgSessionCompletionHandler: (() -> Void)?
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        bgSessionCompletionHandler = completionHandler
    }
    
}
