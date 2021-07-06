//
//  QRCodeViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/30/20.
//

import UIKit
import ContactsUI

class QRCodeViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var customNavBar: UINavigationBar!
    @IBOutlet weak var qrcodeImageView: UIImageView!
    @IBOutlet weak var nameInitialsView: UIView!
    @IBOutlet weak var nameInitialsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobTitleLabel: UILabel!

// MARK: - Variables
    private var filter: CIFilter!
    var contact: Contact?
    var cnContact: CNContact?

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.setGradientBackground( colorTop: K.Colors.Blue, colorBottom: K.Colors.Wine)
        setNames()
        qrCodeSetup()
        customNavBar.shadowImage = UIImage()

        let randomColor = UIColor.random
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1
        nameInitialsLabel.textColor = randomColor

    }

// MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

// MARK: - Methods
    private func setNames() {
        guard let contact = contact else {return}
        nameLabel.text = contact.name.fullName
        jobTitleLabel.text = contact.businessInfo?.role ?? ""
        let firstName = contact.name.firstName
        let lastName = contact.name.lastName
        if firstName?.isEmpty == false && lastName?.isEmpty == false {
            nameInitialsLabel.text = "\(contact.name.firstName!.prefix(1))\(contact.name.lastName!.prefix(1))"
        } else if firstName?.isEmpty == false && lastName?.isEmpty == true {
            nameInitialsLabel.text = "\(contact.name.firstName!.prefix(2))"
        } else if firstName?.isEmpty == true && lastName?.isEmpty == false {
            nameInitialsLabel.text = "\(contact.name.lastName!.prefix(2))"
        }

    }

    private func qrCodeSetup() {
        do {
            let data = try CNContactVCardSerialization.data(with: [cnContact!])
            filter = CIFilter(name: "CIQRCodeGenerator")
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 30, y: 30)

            let image = UIImage(ciImage: filter.outputImage!.transformed(by: transform))

            qrcodeImageView.image = image
        } catch {
            self.alert(title: "Error", message: error.localizedDescription)
        }
    }
}
