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
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let keychainService = KeychainService()
        let userDefaults = UserDefaults.standard


        if keychainService.token != nil && userDefaults.bool(forKey: K.hasPreviousAuth) {
            let storyboard = UIStoryboard(name: "Cards", bundle: nil)
            if #available(iOS 13.0, *) {
                
                let vc = storyboard.instantiateViewController(identifier: K.ViewIdentifiers.cardsTabBarController) as? TabBarController
                let rootNC = UINavigationController(rootViewController: vc!)
                self.window?.rootViewController = rootNC
            } else {
                let vc = storyboard.instantiateViewController(withIdentifier: K.ViewIdentifiers.cardsTabBarController) as? TabBarController
                let rootNC = UINavigationController(rootViewController: vc!)
                self.window?.rootViewController = rootNC
            }

        } else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if #available(iOS 13.0, *) {
                let vc = storyboard.instantiateViewController(identifier: K.ViewIdentifiers.startScreenViewController) as? StartScreenViewController
                let rootNC = UINavigationController(rootViewController: vc!)
                self.window?.rootViewController = rootNC
            } else {
                // Fallback on earlier versions
                let vc = storyboard.instantiateViewController(withIdentifier: K.ViewIdentifiers.startScreenViewController) as? StartScreenViewController
                let rootNC = UINavigationController(rootViewController: vc!)
                self.window?.rootViewController = rootNC
            }
        }
        self.window?.makeKeyAndVisible()

        return true
    }
    

    var bgSessionCompletionHandler: (() -> Void)?
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        bgSessionCompletionHandler = completionHandler
    }
}
