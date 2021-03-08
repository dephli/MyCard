//
//  ProfileViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/7/20.
//

import UIKit
import MSPeekCollectionViewDelegateImplementation

class ProfileViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardCountLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerStackView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var profileCardCollectionView: UICollectionView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var emptyCardsVIew: UIView!
    @IBOutlet weak var contactDetailsStackViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var contactDetailsStackView: ContactDetailsStackView!

    @IBOutlet weak var contentView: UIScrollView!

// MARK: - Variables
    private var topViewOffset: CGFloat?
    private var lastContentOffset: CGFloat?
    private var currentVisibleCard = 0
    private var personalCards: [Contact]?
    private var behavior = MSCollectionViewPeekingBehavior()

// MARK: - Viewcontroller methods
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isHidden = true

        FirestoreService.manager.getPersonalCards {(error, cards) in
            self.removeActivityIndicator()
            if let error = error {
                self.alert(title: "Error Fetching Personal Cards", message: error.localizedDescription)
            } else {
                self.personalCards = cards
                if cards?.isEmpty == false {
                    self.emptyCardsVIew.isHidden = true
                    self.headerStackView.isHidden = false
                    self.cardCountLabel.isHidden = false
                    self.scrollView.isScrollEnabled = true
                } else {
                    self.scrollView.isScrollEnabled = false
                    self.headerStackView.isHidden = true
                    self.emptyCardsVIew.isHidden = false
                }
                self.cardCountLabel.text = "\(cards!.count) cards"
                self.profileCardCollectionView.reloadData()

                if cards?.isEmpty == false {
                    self.contactDetailsStackView.configure(contact: cards?[0])
                }
            }
        }
        nameLabel.text = AuthService.username
        if let avatarImageUrl = AuthService.avatarUrl {
            self.avatarImageView.loadThumbnail(urlSting: avatarImageUrl)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.showActivityIndicator()
        emptyCardsVIew.isHidden = true
        headerStackView.isHidden = true
        contactDetailsStackViewHeightConstraint.isActive = false
        scrollView.delegate = self
        nameLabel.style(with: K.TextStyles.heading1)
        cardCountLabel.style(with: K.TextStyles.captionBlack60)
        cardCountLabel.isHidden = true
        topViewOffset = headerStackView.frame.origin.y
        profileCardCollectionView.configureForPeekingBehavior(behavior: behavior)
        profileCardCollectionView.delegate = self
        profileCardCollectionView.dataSource = self

        profileCardCollectionView.register(
            UINib(
                nibName: K.personalCardCell,
                bundle: nil),
            forCellWithReuseIdentifier: "Cell"
        )

    }


// MARK: - Actions
    @IBAction func editPressed(_ sender: Any) {
        let contact = self.personalCards![self.currentVisibleCard]
        CardManager.shared.setContactType(type: .editPersonalCard)

        CardManager.shared.setContact(with: contact)
        SocialMediaManger.manager.list.accept( contact.socialMediaProfiles ?? [])
        if let phoneNumbers = contact.phoneNumbers {
            PhoneNumberManager.manager.list.accept(phoneNumbers)
        }
        if let emails = contact.emailAddresses {
            EmailManager.manager.list.accept(emails)
        }
        self.performSegue(withIdentifier: K.Segues.profileToCreateCard, sender: self)
    }

    @IBAction func deletePressed(_ sender: Any) {
        confirmDeletion()
    }

    @IBAction func createCardPressed(_ sender: Any) {
        let manager = CardManager.shared
        manager.reset()
        manager.cleanContact()
        manager.setContactType(type: .createPersonalCard)
        self.performSegue(withIdentifier: K.Segues.profileToCreateCard, sender: self)
    }

// MARK: - Methods
    private func confirmDeletion() {
        let contact = self.personalCards![self.currentVisibleCard]

        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [self] (_) in
            self.showActivityIndicator()
            FirestoreService.manager.deletePersonalCard(contact: contact) { (error) in
                self.removeActivityIndicator()
                if let error = error {
                    self.alert(title: "Error", message: error.localizedDescription)
                } else {
                    self.profileCardCollectionView.reloadData()
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        let alertController = UIAlertController(
            title: "Delete Card",
            message: "Are you sure you want to delete this card?",
            preferredStyle: .alert
        )
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
        alertController.view.tintColor = .black
    }
}

// MARK: - ScrollView
extension ProfileViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset != nil {
            if self.lastContentOffset! > scrollView.contentOffset.x {

            } else if self.lastContentOffset! < scrollView.contentOffset.x {

            } else {
                var headerFrame = headerStackView.frame
                headerFrame.origin.y = CGFloat(max(topViewOffset!, scrollView.contentOffset.y))
                headerStackView.frame = headerFrame
            }
        }
        self.lastContentOffset = scrollView.contentOffset.x

    }
}

// MARK: - CollectionView
extension ProfileViewController: UICollectionViewDelegate,
                                 UICollectionViewDataSource,
                                 UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return personalCards?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "Cell",
                for: indexPath) as? PersonalCardCollectionViewCell else {
            fatalError("Cannot create new cell")
        }

        cell.layer.shadowColor = K.Colors.Black10?.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2)
        cell.layer.shadowRadius = 16
        cell.layer.shadowOpacity = 1
        cell.layer.masksToBounds = false

        cell.contact = personalCards?[indexPath.row]
        return cell
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        behavior.scrollViewWillEndDragging(scrollView,
                                           withVelocity: velocity,
                                           targetContentOffset: targetContentOffset)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(
            origin: profileCardCollectionView.contentOffset,
            size: profileCardCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let visibleIndexPath = profileCardCollectionView.indexPathForItem(at: visiblePoint)

        if visibleIndexPath?.row != currentVisibleCard {

            if let index = visibleIndexPath?.row {
                UIView.animate(withDuration: 0.2) {
                    self.contactDetailsStackView.alpha = 0
                } completion: { _ in
                    self.contactDetailsStackView.configure(contact: self.personalCards?[index])

                    UIView.animate(withDuration: 0.2) {
                        self.contactDetailsStackView.alpha = 1
                    }
                }
                self.currentVisibleCard = index
            }
        }
    }
}
