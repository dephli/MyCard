//
//  ImagePickerService.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 1/6/21.
//

import Foundation
import UIKit

 class ImagePickerService: UIViewController {

    let imagePicker = UIImagePickerController()

    func selectImage(_ viewController: UIViewController) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            viewController.present(imagePicker, animated: true)
        }
    }
 }
