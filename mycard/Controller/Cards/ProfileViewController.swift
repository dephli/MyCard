//
//  ProfileViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/7/20.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cardCountLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerStackView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var profileCardCollectionView: UICollectionView!
    
    @IBOutlet weak var contentView: UIScrollView!
    
    var topViewOffset: CGFloat?
    var cardsArray = [
    "Space & Jonin", "Microsoft", "Apple", "Netflix", "Google"
    ]
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        nameLabel.style(with: K.TextStyles.heading1)
        cardCountLabel.style(with: K.TextStyles.captionBlack60)
        topViewOffset = headerStackView.frame.origin.y
//        profileCardCollectionView.isPagingEnabled = true
        
        profileCardCollectionView.delegate = self
        profileCardCollectionView.dataSource = self
    
        profileCardCollectionView.register(UINib(nibName: K.personalCardCell, bundle: nil), forCellWithReuseIdentifier: PersonalCardCollectionViewCell.reuseIdentifier)
        
    }
    
    var lastContentOffset: CGFloat?
}

extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastContentOffset != nil {
            if (self.lastContentOffset! > scrollView.contentOffset.x) {
                
            } else if (self.lastContentOffset! < scrollView.contentOffset.x) {
                
            } else {
                var headerFrame = headerStackView.frame
                headerFrame.origin.y = CGFloat(max(topViewOffset!, scrollView.contentOffset.y))
                headerStackView.frame = headerFrame
            }
        }
        self.lastContentOffset = scrollView.contentOffset.x;
        
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PersonalCardCollectionViewCell.reuseIdentifier, for: indexPath) as? PersonalCardCollectionViewCell else {
            fatalError("Cannot create new cell")
        }
        
//        cell.companyNameLabel.text = cardsArray[indexPath.row]
        return cell
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 10
    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let frameSize = collectionView.frame.size
        return CGSize(width: frameSize.width - 10, height: frameSize.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}


