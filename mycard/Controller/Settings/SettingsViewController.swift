//
//  SettingsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/18/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var navBarTitle: UIBarButtonItem!
    @IBOutlet weak var numberTextLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!

    override func viewWillAppear(_ animated: Bool) {
        nameTextLabel.text = AuthService.username
        numberTextLabel.text = AuthService.phoneNumber
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.style(with: K.TextStyles.captionBlack60)
        numberLabel.style(with: K.TextStyles.captionBlack60)
        nameTextLabel.style(with: K.TextStyles.bodyBlack)
        numberTextLabel.style(with: K.TextStyles.bodyBlack)

        navigationBar.shadowImage = UIImage()
        let font = UIFont(name: "inter", size: 18)
        navBarTitle.setTitleTextAttributes([NSAttributedString.Key.font: font!], for: .normal)

        if let avatarImageUrl = AuthService.avatarUrl {
            self.avatarImage.loadThumbnail(urlSting: avatarImageUrl)
        }

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutButtonPressed(_ sender: Any) {
        UserManager.auth.logout { (error) in
            if let error = error {
                self.alert(title: "Error", message: error.localizedDescription)
            } else {
                self.setRootViewController()
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }

    fileprivate func setRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let navController = storyboard
                .instantiateViewController(
                    identifier: K.ViewIdentifiers.startScreenViewController
                ) as? StartScreenViewController else {
            return
        }
        UIApplication.shared.windows.first?.rootViewController = navController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
