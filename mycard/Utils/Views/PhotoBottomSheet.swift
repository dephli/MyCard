//
//  BottomSheet.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 3/22/21.
//

import UIKit

protocol PhotoBottomSheetDelegate: UIViewController {
    func takePhotoPressed()
    func uploadPhotoPressed()
}

class PhotoButtomSheet {
    weak var delegate: PhotoBottomSheetDelegate?

    var bottomSheetView: UIView?
    var superView: UIView?
    var bottomSheetBottomConstraint: NSLayoutConstraint?

    func initialize() {

        superView = delegate?.view
        bottomSheetView = UIView()
        bottomSheetView?.backgroundColor = K.Colors.White
        bottomSheetView?.translatesAutoresizingMaskIntoConstraints = false
        bottomSheetView?.layer.borderColor = K.Colors.Black?.cgColor
        bottomSheetView?.layer.borderWidth = 1
        bottomSheetView?.layer.cornerRadius = 16
        bottomSheetView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomSheetView?.clipsToBounds = true
        superView?.addSubview(bottomSheetView!)
        let gestureRecognizeer = UITapGestureRecognizer(target: delegate, action: #selector(superviewTapped))
        bottomSheetBottomConstraint = bottomSheetView!
            .topAnchor
            .constraint(
                equalTo: superView!.bottomAnchor,
                constant: 0
            )
        bottomSheetBottomConstraint?.isActive = true
        NSLayoutConstraint.activate([
            bottomSheetView!.heightAnchor.constraint(equalToConstant: 176),
            bottomSheetView!.leadingAnchor.constraint(equalTo: superView!.leadingAnchor, constant: 0),
            bottomSheetView!.trailingAnchor.constraint(equalTo: superView!.trailingAnchor, constant: 0)
        ])

    }

    @objc func superviewTapped() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {[self] in
                bottomSheetBottomConstraint?.constant = 0
                superView!.layoutIfNeeded()
            }
        }
    }

    func activate() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {[self] in
                bottomSheetBottomConstraint?.constant = -176
                superView!.layoutIfNeeded()
            }
        }
    }
}
