//
//  CardDetailsViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/29/20.
//

import UIKit

class CardDetailsViewController: UIViewController{
    
    @IBOutlet weak var nameInitialsLabel: UILabel!
    @IBOutlet weak var nameInitialsView: UIView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var customNavigationBar: UINavigationBar!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var workInfoLabel: UILabel!
    @IBOutlet weak var workLocationLabel: UILabel!
    @IBOutlet weak var socialMediaLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var phoneButtonLabel: UILabel!
    @IBOutlet weak var mailButtonLabel: UILabel!
    @IBOutlet weak var locationButtonLabel: UILabel!
    
    @IBOutlet weak var cardViewFaceIndicator1: UIView!
    @IBOutlet weak var cardViewFaceIndicator2: UIView!
    
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardRoleLabel: UILabel!
    @IBOutlet weak var socialMediaStackView: SocialMediaListStackView!
    @IBOutlet weak var socialMediaStackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var phoneTextLabel: UILabel!
    @IBOutlet weak var emailTextLabel: UILabel!
    @IBOutlet weak var workInfoTextLabel: UILabel!
    @IBOutlet weak var workPositionTextLabel: UILabel!
    @IBOutlet weak var workLocationTextLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var contactSummaryView: UIView!
    let imageView = UIImageView(image: UIImage(named: "nasa"))
    
    var isOpen = false
    
    var notepoint: CGPoint?
    
    fileprivate func setupUI() {
        socialMediaStackViewHeightConstraint.isActive = false
        socialMediaStackView.configure(with: contact?.socialMediaProfiles ?? [])
        customNavigationBar.shadowImage = UIImage()
        let randomColor = UIColor.random
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1
        nameInitialsLabel.textColor = randomColor
        noteTextField.delegate = self
        
        phoneButtonLabel.style(with: K.TextStyles.captionBlack60)
        mailButtonLabel.style(with: K.TextStyles.captionBlack60)
        locationButtonLabel.style(with: K.TextStyles.captionBlack60)
        
        nameLabel.style(with: K.TextStyles.bodyBlackSemiBold)
        jobTitleLabel.style(with: K.TextStyles.subTitle)
        noteTextField.bottomBorder(color: UIColor(named: K.Colors.mcWhite)!, width: 1)
        noteTextField.attributedPlaceholder = NSAttributedString(string: noteTextField.placeholder!, attributes: [
                                                                    NSAttributedString.Key.foregroundColor: UIColor(cgColor: UIColor(named: K.Colors.mcBlue)!.cgColor)])

        phoneLabel.style(with: K.TextStyles.subTitle)
        nameLabel.style(with: K.TextStyles.subTitle)
        noteLabel.style(with: K.TextStyles.subTitle)
        workInfoLabel.style(with: K.TextStyles.subTitle)
        workLocationLabel.style(with: K.TextStyles.subTitle)
        emailAddressLabel.style(with: K.TextStyles.subTitle)
        socialMediaLabel.style(with: K.TextStyles.subTitle)

        
        nameTextLabel.style(with: K.TextStyles.bodyBlack)
        phoneTextLabel.style(with: K.TextStyles.bodyBlack)
        emailTextLabel.style(with: K.TextStyles.bodyBlack)
        workInfoTextLabel.style(with: K.TextStyles.bodyBlack)
        workPositionTextLabel.style(with: K.TextStyles.bodyBlack)
        workLocationTextLabel.style(with: K.TextStyles.bodyBlack)
    }
    
    var contact: Contact?

    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        nameTextLabel.text = contact?.name.fullName
        cardNameLabel.text = contact?.name.fullName
        cardRoleLabel.text = contact?.businessInfo.role ?? ""
        workInfoTextLabel.text = contact?.businessInfo.companyName ?? ""
        workPositionTextLabel.text = contact?.businessInfo.role ?? ""
        workLocationTextLabel.text = contact?.businessInfo.companyAddress ?? ""
        registerKeyboardNotifications()

        
        noteTextField.text = contact?.note
        self.dismissKey()
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleCardDrag))
        
        cardView.addGestureRecognizer(gesture)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillShowNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillHideNotification)
        NotificationCenter.default.removeObserver(UIResponder.keyboardWillChangeFrameNotification)
    }

    
    @IBAction func onBackButtonPressed(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = .reveal
        transition.subtype = .fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window?.layer.add(transition, forKey: kCATransition)

        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleCardDrag() {
        DispatchQueue.main.async { [self] in
            if isOpen {
                isOpen.toggle()
                cardView.addSubview(contactSummaryView)
                UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromBottom, animations: nil, completion: nil)
                cardViewFaceIndicator1.backgroundColor = UIColor(named: K.Colors.mcBlack)
                cardViewFaceIndicator2.backgroundColor = UIColor(named: K.Colors.mcBlack10)
                
            } else {
                
                isOpen.toggle()
                
                cardViewFaceIndicator2.backgroundColor = UIColor(named: K.Colors.mcBlack)
                cardViewFaceIndicator1.backgroundColor = UIColor(named: K.Colors.mcBlack10)

                
                imageView.layer.cornerRadius = 8
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                cardView.addSubview(imageView)
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 0).isActive = true
                imageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 0).isActive = true
                imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 0).isActive = true
                imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 0).isActive = true
                
                UIView.transition(with: cardView, duration: 0.3, options: .transitionFlipFromBottom, animations: nil, completion: nil)

            }
        }
    }
    
    @objc func keyboardWillChange(_ notification: Notification) {
        guard let keyboardRectangle = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            self.view.frame.origin.y = -keyboardRectangle.height
        } else {
            self.view.frame.origin.y = 0
        }
    }
    
    fileprivate func confirmDeletion() {
        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        let alertController = UIAlertController(title: "Delete Card", message: "Are you sure you want to delete this card?", preferredStyle: .alert)
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = .black
    }
}



//MARK: - ActionSheet Actions
extension CardDetailsViewController {
    
    @IBAction func moreButtonPressed(_ sender: Any) {
        var image = UIImage(named: "edit")
        image?.withTintColor(UIColor(named: K.Colors.mcBlack)!)
        let editAction = UIAlertAction(
            title: "Edit Card", style: .default) { (action) in
        }
        editAction.setValue(image, forKey: "image")
        editAction.setValue(0, forKey: "titleTextAlignment")

        
        image = UIImage(named: "add to collection")
        let addAction = UIAlertAction(
            title: "Add to collection", style: .default) { (action) in
        }
        addAction.setValue(image, forKey: "image")
        addAction.setValue(0, forKey: "titleTextAlignment")

        
        image = UIImage(named: "scan card qr")
        let viewAction = UIAlertAction(title: "View card QR", style: .default) { (action) in
            let storyBoard = UIStoryboard(name: "QRCode", bundle: nil)
            let qrCodeViewController = storyBoard.instantiateViewController(identifier: "QRCodeViewController") as! QRCodeViewController
            self.present(qrCodeViewController, animated: true, completion: nil)
            
            
        }
        viewAction.setValue(image, forKey: "image")
        viewAction.setValue(0, forKey: "titleTextAlignment")

        let exportAction = UIAlertAction(title: "Export to contacts", style: .default) { (action) in
            
        }
        image = UIImage(named: "contacts")
        exportAction.setValue(image, forKey: "image")
        exportAction.setValue(0, forKey: "titleTextAlignment")
        
        let deleteAction = UIAlertAction(title: "Delete card", style: .destructive) { (action) in
            self.confirmDeletion()
        }

        image = UIImage(named: "delete")
        deleteAction.setValue(image, forKey: "image")
        deleteAction.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            
        }
        
        
        let alert = UIAlertController(title: nil, message: nil,
              preferredStyle: .actionSheet)
        let actions = [editAction, addAction, viewAction, exportAction, deleteAction, cancelAction]
        
        for action in actions { alert.addAction(action)}

        
        self.present(alert, animated: true, completion: nil)
        alert.view.tintColor = .black
        
    }
}

extension CardDetailsViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        noteTextField.bottomBorder(color: UIColor(named: K.Colors.mcBlue)!, width: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        noteTextField.bottomBorder(color: UIColor(named: K.Colors.mcWhite)!, width: 1)
    }
    
}
