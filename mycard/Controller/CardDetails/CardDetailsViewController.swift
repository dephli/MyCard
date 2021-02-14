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
    @IBOutlet weak var detailsStackView: ContactDetailsStackView!
    @IBOutlet weak var detailsStackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var phoneButtonLabel: UILabel!
    @IBOutlet weak var mailButtonLabel: UILabel!
    @IBOutlet weak var locationButtonLabel: UILabel!
    
    @IBOutlet weak var cardViewFaceIndicator1: UIView!
    @IBOutlet weak var cardViewFaceIndicator2: UIView!
    
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var cardRoleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var contactSummaryView: UIView!
    let imageView = UIImageView()
    
    var isOpen = false
    
    var notepoint: CGPoint?
    
    fileprivate func setupUI() {
        customNavigationBar.shadowImage = UIImage()
        let randomColor = UIColor.random
        nameInitialsView.backgroundColor = randomColor
        nameInitialsView.alpha = 0.1
        nameInitialsLabel.textColor = randomColor
        noteTextField.delegate = self
        
        phoneButtonLabel.style(with: K.TextStyles.captionBlack60)
        mailButtonLabel.style(with: K.TextStyles.captionBlack60)
        locationButtonLabel.style(with: K.TextStyles.captionBlack60)
        
        noteLabel.style(with: K.TextStyles.captionBlack60)
        
        noteTextField.bottomBorder(color: K.Colors.White!, width: 1)
        noteTextField.attributedPlaceholder = NSAttributedString(string: noteTextField.placeholder!, attributes: [
                                                                    NSAttributedString.Key.foregroundColor: UIColor(cgColor: K.Colors.Blue!.cgColor)])

        imageView.loadThumbnail(urlSting: contact?.businessInfo.companyLogo ?? "")
    }
    
    var contact: Contact?

    fileprivate func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    fileprivate func populateViewsWithData() {
        cardNameLabel.text = contact?.name.fullName
        cardRoleLabel.text = contact?.businessInfo.role ?? ""

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        populateViewsWithData()
        registerKeyboardNotifications()
        self.dismissKey()
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleCardDrag))
        
        cardView.addGestureRecognizer(gesture)
        detailsStackViewHeightConstraint.isActive = false
        detailsStackView.configure(contact: contact)
        
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
                cardViewFaceIndicator1.backgroundColor = K.Colors.Black
                cardViewFaceIndicator2.backgroundColor = K.Colors.Black10
                
            } else {
                
                isOpen.toggle()
                
                cardViewFaceIndicator2.backgroundColor = K.Colors.Black
                cardViewFaceIndicator1.backgroundColor = K.Colors.Black10

                
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
        image?.withTintColor(K.Colors.Black!)
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
        noteTextField.bottomBorder(color: K.Colors.Blue!, width: 1)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        noteTextField.bottomBorder(color: K.Colors.White!, width: 1)
    }
}
