//
//  SocialMediaViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/14/20.
//

import UIKit

class SocialMediaViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
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

    @IBOutlet weak var linkedinButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!

    let socialMediaList = SocialMediaManger.manager.getAll

    override func viewDidLoad() {
        super.viewDidLoad()
        addTextStyles()
        populateTextFields()
        instagramAccountTextfield.tag = 0
        twitterAccountTextfield.tag = 1
        instagramAccountTextfield.delegate = self
        twitterAccountTextfield.delegate = self
        facebookTextfield.delegate = self
        self.dismissKey()

    }
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        if #available(iOS 13.0, *) {
            presentationController?.delegate?.presentationControllerDidDismiss?(presentationController!)
        }
    }

    @IBAction func doneButtonPressed(_ sender: Any) {

        var accounts: [SocialMedia] = []

        if facebookTextfield.text != "" {
            accounts.append(SocialMedia(usernameOrUrl: facebookTextfield.text!, type: .Facebook))
        }

        if twitterAccountTextfield.text != "" {
            accounts.append(SocialMedia(usernameOrUrl: twitterAccountTextfield.text!, type: .Twitter))
        }

        if instagramAccountTextfield.text != "" {
            accounts.append(SocialMedia(usernameOrUrl: instagramAccountTextfield.text!, type: .Instagram))
        }

        if linkedinAccountTextfield.text != "" {
            accounts.append(SocialMedia(usernameOrUrl: linkedinAccountTextfield.text!, type: .LinkedIn))
        }
        SocialMediaManger.manager.replace(with: accounts)

        dismiss(animated: true, completion: nil)
    }

    fileprivate func addTextStyles() {
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
}

// MARK: - Button Pressed Actions
extension SocialMediaViewController {
    @IBAction func addLinkedinButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            let image: UIImage
            if self.linkedinAccountTextfield.isHidden {
                self.linkedinAccountTextfield.show()
                image = K.Images.minus
            } else {
                self.linkedinAccountTextfield.hide()
                image = K.Images.plus
            }
            sender.setImage(image, for: .normal)
        })
    }

    @IBAction func addFacebookButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            let image: UIImage
            if self.facebookTextfield.isHidden {
                self.facebookTextfield.show()
                image = K.Images.minus
            } else {
                self.facebookTextfield.hide()
                image = K.Images.plus
            }
            sender.setImage(image, for: .normal)
        })
    }

    @IBAction func addTwitterButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            let image: UIImage
            if self.twitterAccountTextfield.isHidden {
                self.twitterAccountTextfield.show()
                image = K.Images.minus
            } else {
                self.twitterAccountTextfield.hide()
                image = K.Images.plus
            }
            sender.setImage(image, for: .normal)
        })
    }

    @IBAction func addInstagramButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            let image: UIImage
            if self.instagramAccountTextfield.isHidden {
                self.instagramAccountTextfield.show()
                image = K.Images.minus
            } else {
                self.instagramAccountTextfield.hide()
                image = K.Images.plus
            }

            sender.setImage(image, for: .normal)

        })
    }
}

extension SocialMediaViewController {
    fileprivate func populateTextFields() {
        if let linkedIn = socialMediaList.first(where: { (socialMedia) -> Bool in
            return socialMedia.type == .LinkedIn
        }) {
            linkedinAccountTextfield.text = linkedIn.usernameOrUrl
            linkedinButton.setImage(K.Images.minus, for: .normal)

        } else {
            linkedinAccountTextfield.hide()
        }

        if let twitter = socialMediaList.first(where: { (socialMedia) -> Bool in
            return socialMedia.type == .Twitter
        }) {
            twitterAccountTextfield.text = twitter.usernameOrUrl
            twitterButton.setImage(K.Images.minus, for: .normal)
        } else {
            twitterAccountTextfield.hide()
        }

        if let instagram = socialMediaList.first(where: { (socialMedia) -> Bool in
            return socialMedia.type == .Instagram
        }) {
            instagramAccountTextfield.text = instagram.usernameOrUrl
            instagramButton.setImage(K.Images.minus, for: .normal)
        } else {
            instagramAccountTextfield.hide()
        }

        if let facebook = socialMediaList.first(where: { (socialMedia) -> Bool in
            return socialMedia.type == .Facebook
        }) {
            facebookTextfield.text = facebook.usernameOrUrl
            facebookButton.setImage(K.Images.minus, for: .normal)
        } else {
            facebookTextfield.hide()
        }
    }

}

extension SocialMediaViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 0 || textField.tag == 1 {
        scrollView.setContentOffset(CGPoint(x: 0, y: 150), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint.zero, animated: true)
    }
}
