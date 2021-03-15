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
//    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardCountLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var profileCardCollectionView: UICollectionView!
    @IBOutlet weak var emptyCardsVIew: UIView!
    @IBOutlet weak var contactDetailsStackView: ContactDetailsStackView!

// MARK: - Variables
    private var topViewOffset: CGFloat?
    private var lastContentOffset: CGFloat?
    private var currentVisibleCard = 0
    private var personalCards: [Contact]?
    private var behavior = MSCollectionViewPeekingBehavior()
    var viewModel: ProfileViewModel!

// MARK: - Viewcontroller methods
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true

        let avatarImageView = UIImageView(image: K.Images.profilePlaceholder)
        avatarImageView.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        if let avatarImageUrl = AuthService.avatarUrl {
            avatarImageView.loadThumbnail(urlSting: avatarImageUrl)
        }

        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40)
        ])

        let settingsButton = UIBarButtonItem(
            image: K.Images.gearShape,
            style: .plain, target: self,
            action: #selector(settingsButtonPressed))

        let addButton = UIBarButtonItem(
            image: K.Images.plus,
            style: .plain,
            target: self,
            action: #selector(addButtonPressed))
        let font = UIFont(name: "inter", size: 24)
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: font!

        ]
        navigationController?.navigationBar.prefersLargeTitles = true
        
//        navigationItem.largeTitleDisplayMode = .always
        navigationItem.title = AuthService.username
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: avatarImageView)
        navigationItem.rightBarButtonItems = [settingsButton, addButton]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.hidesBarsOnSwipe = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProfileViewModel()
        viewModel.bindError = handleError
        viewModel.bindFetchPersonalCardsSuccess = fetchCardsSuccessful
        viewModel.bindDeleteCardSuccess = deleteCardSuccessful
        detailsHeightConstraint.isActive = false
        self.showActivityIndicator()
        emptyCardsVIew.isHidden = true
        headerView.isHidden = true
        scrollView.delegate = self
        cardCountLabel.style(with: K.TextStyles.captionBlack60)
        cardCountLabel.isHidden = true
        topViewOffset = headerView.frame.origin.y
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationItem.title = nil
        navigationController?.hidesBarsOnSwipe = false
    }

// MARK: - Actions
    @objc func addButtonPressed() {
        viewModel.createPersonalCard()
        performSegue(withIdentifier: K.Segues.profileToCreateCard, sender: self)
    }

    @objc func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: K.Segues.profileToSettings, sender: self)
    }
    @IBAction func editPressed(_ sender: Any) {
        let contact = self.personalCards![self.currentVisibleCard]
        viewModel.editPersonalCard(contact: contact)
        self.performSegue(withIdentifier: K.Segues.profileToCreateCard, sender: self)
    }

    @IBAction func deletePressed(_ sender: Any) {
        scrollView.setContentOffset(.zero, animated: true)
        confirmDeletion()
    }

    @IBAction func createCardPressed(_ sender: Any) {
        viewModel.createPersonalCard()
        self.performSegue(withIdentifier: K.Segues.profileToCreateCard, sender: self)
    }

// MARK: - Methods
    private func handleError(error: Error) {
        self.removeActivityIndicator()
        alert(title: "Oops", message: error.localizedDescription)
    }

    private func deleteCardSuccessful() {
        profileCardCollectionView.reloadData()
        self.removeActivityIndicator()
    }

    private func fetchCardsSuccessful(cards: [Contact]) {
        self.removeActivityIndicator()

        self.personalCards = cards
        if cards.isEmpty == false {
            self.emptyCardsVIew.isHidden = true
            self.headerView.isHidden = false
            self.cardCountLabel.isHidden = false
            self.scrollView.isScrollEnabled = true
        } else {
            self.scrollView.isScrollEnabled = false
            self.headerView.isHidden = true
            self.emptyCardsVIew.isHidden = false
        }
        self.cardCountLabel.text = viewModel.cardCount
        self.profileCardCollectionView.reloadData()

        if cards.isEmpty == false {
            self.contactDetailsStackView.configure(contact: cards[0])
        }

    }

    private func confirmDeletion() {
        let contact = self.personalCards![self.currentVisibleCard]

        let confirmAction = UIAlertAction(title: "Delete", style: .destructive) { [self] (_) in
            self.showActivityIndicator()
            viewModel.deletePersonalCard(contact: contact)
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
            if lastContentOffset == scrollView.contentOffset.x {
                var headerFrame = headerView.frame
                headerFrame.origin.y = CGFloat(max(topViewOffset!, scrollView.contentOffset.y + 48))
                headerView.frame = headerFrame
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
