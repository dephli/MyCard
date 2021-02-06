//
//  ContactCardCollectionViewCell.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/6/21.
//

import UIKit

class ContactCardCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier  = String(describing: ContactCardCollectionViewCell.self)
    
    @IBOutlet weak var label: UILabel!
}
