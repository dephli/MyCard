//
//  AvatarImageBottomSheet.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 4/1/21.
//
import UIKit

protocol AvatarImageBottomSheetDelegate: AnyObject {
    func takePhotoPressed()
    func uploadPhotoPressed()
    func removePhotoPressed()
}

class AvatarImageBottomSheet: BottomSheetViewController {

    weak var delegate: AvatarImageBottomSheetDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func takePhotoPressed(_ sender: Any) {
        delegate.takePhotoPressed()
    }

    @IBAction func uploadPhotoPressed(_ sender: Any) {
        delegate.uploadPhotoPressed()
    }

    @IBAction func removePhotoPressed(_ sender: Any) {
        delegate.removePhotoPressed()
    }
}
