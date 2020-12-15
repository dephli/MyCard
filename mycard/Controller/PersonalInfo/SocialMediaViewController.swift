//
//  SocialMediaViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/14/20.
//

import UIKit

class SocialMediaViewController: UIViewController {

    @IBOutlet weak var socialsLabel: UILabel!
    @IBOutlet weak var linkedinLabel: UILabel!
    @IBOutlet weak var linkedinAccountTextfield: UITextField!
    @IBOutlet weak var facebookLabel: UILabel!
    @IBOutlet weak var facebookTextfield: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var instagramAccountTextfield: UITextField!
    
    @IBOutlet weak var twitterLabel: UILabel!
    @IBOutlet weak var twitterAccountTextfield: UITextField!
    @IBOutlet weak var instagramLabel: UILabel!
    
    
    @IBOutlet weak var linkedinStackView: UIStackView!
    @IBOutlet weak var facebookStackView: UIStackView!
    @IBOutlet weak var twitterStackView: UIStackView!
    @IBOutlet weak var instagramStackView: UIStackView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        linkedinAccountTextfield.isHidden = true
        linkedinAccountTextfield.alpha = 0
        
        twitterAccountTextfield.isHidden = true
        twitterAccountTextfield.alpha = 0
        
        facebookTextfield.isHidden = true
        facebookTextfield.alpha = 0
        
        instagramAccountTextfield.isHidden = true
        instagramAccountTextfield.alpha = 0
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        socialsLabel.style(with: K.TextStyles.heading1)
        linkedinLabel.style(with: K.TextStyles.bodyBlack60)
        facebookLabel.style(with: K.TextStyles.bodyBlack60)
        instagramLabel.style(with: K.TextStyles.bodyBlack60)
        twitterLabel.style(with: K.TextStyles.bodyBlack60)
        

        linkedinAccountTextfield.setTextStyle(with: K.TextStyles.bodyBlack60)
        facebookTextfield.setTextStyle(with: K.TextStyles.bodyBlack60)
        twitterAccountTextfield.setTextStyle(with: K.TextStyles.bodyBlack60)
        instagramAccountTextfield.setTextStyle(with: K.TextStyles.bodyBlack60)
        doneButton.setTitle(with: K.TextStyles.buttonWhite, for: .normal)

    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    

}


//MARK: - Button Pressed Actions
extension SocialMediaViewController {
    @IBAction func addLinkedinButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.linkedinAccountTextfield.alpha = 1
            self.linkedinAccountTextfield.isHidden.toggle()
        })
    }
    
    @IBAction func addFacebookButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.facebookTextfield.alpha = 1
            self.facebookTextfield.isHidden.toggle()
        })
    }
    
    @IBAction func addTwitterButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.twitterAccountTextfield.alpha = 1
            self.twitterAccountTextfield.isHidden.toggle()
        })
    }
    
    @IBAction func addInstagramButtonPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.3, animations: {
            self.instagramAccountTextfield.alpha = 1
            self.instagramAccountTextfield.isHidden.toggle()
        })
    }
}
