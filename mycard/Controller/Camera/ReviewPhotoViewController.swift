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
    var scannedTextArray: [String]?
    var scannedText: String?

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.image = backgroundImage
        backgroundImageView.layer.addSublayer(frameSubLayer)
    }

    override func viewDidAppear(_ animated: Bool) {
        decodeImage()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
           let destination = navController.topViewController as? ReviewScannedCardDetailsViewController {
            destination.viewModel = ReviewScannedCardDetailsViewModel(
                scannedDetailsArray: scannedTextArray!,
                scannedDetails: scannedText!
            )
        }
    }

// MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func arrowButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: K.Segues.cameraToScannedCardDetails, sender: self)
    }

// MARK: - Custom methods
    private func decodeImage() {
        self.showActivityIndicator()
        ScaledElementProcessor().process(in: backgroundImageView!) { (scannedTexts, text, elements) in
            self.removeActivityIndicator()
            elements.forEach { feature in
                DispatchQueue.main.async {
                    self.frameSubLayer.addSublayer(feature.shapeLayer)
                }
            }
            self.scannedTextArray = scannedTexts
            self.scannedText = text
        }
    }

}
