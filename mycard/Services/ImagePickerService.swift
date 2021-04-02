//
//  ImagePickerService.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 1/6/21.
//

import Foundation
import UIKit

 class ImagePickerService: UIViewController {
/**
     Abstraction of ImagePickerService in order as to not repeat the code multiple
     */
    let imagePicker = UIImagePickerController()

    func selectImage(
        _ viewController: UIViewController,
        sourceType: UIImagePickerController.SourceType = .photoLibrary) {
        /**
         @param viewController viewController which is calling this function
         @param sourceType Optionally; the source type of media you want to invoke
         */
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.delegate = viewController as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = sourceType
            imagePicker.allowsEditing = true
            viewController.present(imagePicker, animated: true)
        }
    }
 }
