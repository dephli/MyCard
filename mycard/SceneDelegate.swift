//
//  SceneDelegate.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/21/21.
//
//
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let keychainService = KeychainService()

        self.window = UIWindow(windowScene: windowScene)
        let userDefaults = UserDefaults.standard
        
        if let shortcutItem = connectionOptions.shortcutItem {
            // Save it off for later when we become active.
            if keychainService.token != nil && userDefaults.bool(forKey: "hasPreviousAuth"){
                let storyboard = UIStoryboard(name: "Cards", bundle: nil)
                guard let rootVC = storyboard.instantiateViewController(identifier: "TabBarController") as? TabBarController else {
                    print("ViewController not found")
                    return
                }
                let rootNC = UINavigationController(rootViewController: rootVC)
                self.window?.rootViewController = rootNC

                handleShortcutItem(shortcutItem)
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
        } else {
            if keychainService.token != nil && userDefaults.bool(forKey: "hasPreviousAuth"){
                
                let username = AuthService.username
                
                if username != nil
                    && username?.trimmingCharacters(in: .whitespaces) != "" {
                    let storyboard = UIStoryboard(name: "Cards", bundle: nil)
                    guard let rootVC = storyboard.instantiateViewController(identifier: "TabBarController") as? TabBarController else {
                        print("ViewController not found")
                        return
                    }
                    let rootNC = UINavigationController(rootViewController: rootVC)
                    self.window?.rootViewController = rootNC
                } else {
                    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
                    let profileSetupViewController = storyboard.instantiateViewController(
                        identifier: K.ViewIdentifiers.profileSetupViewController
                    ) as ProfileSetupViewController
                    
                    self.window?.rootViewController = profileSetupViewController

                }
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
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    fileprivate func handleShortcutItem(_ shortcutItem: UIApplicationShortcutItem) {
        let storyboard = UIStoryboard(name: "Cards", bundle: nil)
        guard let rootVC = storyboard.instantiateViewController(identifier: "TabBarController") as? TabBarController else {
            print("ViewController not found")
            return
        }
        let rootNC = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = rootNC
        let manager = CardManager.shared

        switch shortcutItem.type {
        case "com.spaceandjonin.myCrd.createpersonalcard":
            
            let storyboard = UIStoryboard(name: "PersonalInfo", bundle: nil)
            guard let personalInfoVc = storyboard.instantiateViewController(identifier: K.ViewIdentifiers.personalInfoViewController) as? PersonalInfoViewController else {
                fatalError("ViewController not found")
            }
            manager.reset()
            manager.currentContactType = .createPersonalCard
            rootNC.present(personalInfoVc, animated: true)
            
        case "com.spaceandjonin.myCrd.createcard":
            
            let storyboard = UIStoryboard(name: "PersonalInfo", bundle: nil)
            guard let personalInfoVc = storyboard.instantiateViewController(identifier: K.ViewIdentifiers.personalInfoViewController) as? PersonalInfoViewController else {
                fatalError("ViewController not found")
            }
            manager.reset()
            manager.currentContactType = .createContactCard
            rootNC.present(personalInfoVc, animated: true)
            
        case "com.spaceandjonin.myCrd.search":
            let storyboard = UIStoryboard(name: "Cards", bundle: nil)
            guard let searchVc = storyboard.instantiateViewController(identifier: K.ViewIdentifiers.searchViewController) as? SearchViewController else {
                fatalError("ViewController not found")
            }
//            let rootVc = self.window?.rootViewController as! UINavigationController
            rootNC.pushViewController(searchVc, animated: true)
        default:
            break
            
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {

        handleShortcutItem(shortcutItem)
//        completionHandler(true)
    }


}

