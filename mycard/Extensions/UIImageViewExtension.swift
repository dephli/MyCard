//
//  UIImageViewExtension.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 2/4/21.
//

import Foundation

import UIKit
import Network

let imageCache = NSCache<AnyObject, AnyObject>()

// MARK: - UIImageView extension
extension UIImageView {

    /// This loadThumbnail function is used to download thumbnail image using urlString
    /// This method also using cache of loaded thumbnail using urlString as a key of cached thumbnail.
    func loadThumbnail(urlSting: String) {
        guard let url = URL(string: urlSting) else { return }
        image = nil

        if let imageFromCache = imageCache.object(forKey: urlSting as AnyObject) {
            image = imageFromCache as? UIImage
            return
        }

        Networking.downloadImage(url: url) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    guard let imageToCache = UIImage(data: data) else { return }
                    imageCache.setObject(imageToCache, forKey: urlSting as AnyObject)
                    self.image = UIImage(data: data)
                case .failure:
                    if self.tag != 1 {
                        self.image = K.Images.brokenImage
                    }
                }
            }
        }
    }
}
