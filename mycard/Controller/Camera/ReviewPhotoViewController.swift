//
//  ReviewPhotoViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/21/20.
//

import UIKit
 import MLKitVision
 import MLKitTextRecognition

class ReviewPhotoViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var backgroundImageView: UIImageView!

// MARK: - Variables
    var frameSubLayer = CALayer()
    var backgroundImage: UIImage?

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = backgroundImage
        backgroundImageView.layer.addSublayer(frameSubLayer)
    }

// MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func arrowButtonPressed(_ sender: Any) {
        decodeImage()
//        performSegue(withIdentifier: K.Segues.cameraToAuth, sender: self)
    }

// MARK: - Custom methods
    private func decodeImage() {
        self.showActivityIndicator()
        ScaledElementProcessor().process(in: backgroundImageView!) { (text, elements) in
            print(text)
            self.removeActivityIndicator()
            elements.forEach { feature in
                DispatchQueue.main.async {
                    self.frameSubLayer.addSublayer(feature.shapeLayer)
                }
            }
        }
    }

}
