//
//  ProfileViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/7/20.
//

import UIKit

class ProfileViewController: UIViewController {
    enum Section {
        case main
    }
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>?
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.navigationController?.navigationBar.isHidden = true
//        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        mainCollectionView.collectionViewLayout = configureLayout()
        configureDataSource()
    }
    
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
        
    }
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(
            collectionView: self.mainCollectionView, cellProvider: { (collectionView, indexPath, number) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContactCardCollectionViewCell.reuseIdentifier, for: indexPath) as? ContactCardCollectionViewCell else {
                    fatalError("Cannot create new cell")
                }
                cell.label.text = number.description
                return cell
            })
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(Array(1...100), toSection: .main)
        
        dataSource?.apply(initialSnapshot, animatingDifferences: false)
    }

}
