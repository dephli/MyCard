//
//  ViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/5/20.
//

import UIKit

class StartScreenViewController: UIViewController {


    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoLabel.style(with: K.TextStyles.heading1)
        
        NotificationCenter.default.post(name: Notification.Name("UserLoggedIn"), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedIn), name: Notification.Name("UserLoggedIn"), object: nil)
    }
    
//    @objc
//    func userLoggedIn() {
//        print("adsfdsaf")
//    }
}
