//
//  SceneDelegate.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/21/21.
//

import UIKit


@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UISceneDelegate {
    
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let keychainService = KeychainService()
        
        self.window = UIWindow(windowScene: windowScene)
        let userDefaults = UserDefaults.standard
        
        if keychainService.token != nil && userDefaults.bool(forKey: "hasPreviousAuth"){
            let storyboard = UIStoryboard(name: "Cards", bundle: nil)
            guard let rootVC = storyboard.instantiateViewController(identifier: "TabBarController") as? TabBarController else {
                print("ViewController not found")
                return
            }
            let rootNC = UINavigationController(rootViewController: rootVC)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
        } else {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let rootVC = storyboard.instantiateViewController(identifier: "StartScreenViewController") as? StartScreenViewController else {
                print("ViewController not found")
                return
            }
            let rootNC = UINavigationController(rootViewController: rootVC)
            self.window?.rootViewController = rootNC
            self.window?.makeKeyAndVisible()
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene,
                     performActionFor shortcutItem: UIApplicationShortcutItem,
                     completionHandler: @escaping (Bool) -> Void) {
        
        self.window = UIWindow(windowScene: windowScene)
        
        switch shortcutItem.type {
        case "SearchAction":
            if let homeVC = self.window?.rootViewController as? UINavigationController {
                let cardsStoryboard = UIStoryboard(name: "Cards", bundle: Bundle.main)
                let searchVC = cardsStoryboard.instantiateViewController(identifier: K.ViewControllers.searchViewController) as SearchViewController
                homeVC.pushViewController(searchVC, animated: true)
            }
            break

        default:
            break
        }
    }
}
