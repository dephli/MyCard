//
//  ReviewPhotoViewController.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/21/20.
//

import UIKit
import MLKitVision
import MLKitTextRecognition
import CropViewController
import EasyTipView

class ReviewPhotoViewController: UIViewController {

// MARK: - Outlets
    @IBOutlet weak var cropButton: UIButton!
    @IBOutlet weak var backgroundImageView: UIImageView!
// MARK: - Variables
    var frameSubLayer = CALayer()
    var capturedImage: UIImage?
    var scannedTextArray: [String]?
    var scannedText: String?

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = capturedImage
    }

    override func viewDidAppear(_ animated: Bool) {
        decodeImage()
        let imageCropedFirstTime = UserDefaults.standard.bool(forKey: K.imageCropedFirstTime)
        if !imageCropedFirstTime {
            Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(showToolTip),
                userInfo: nil, repeats: false
            )
        }
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

    @IBAction func cropImagePressed(_ sender: Any) {
        let cropViewController = CropViewController(image: capturedImage!)
        cropViewController.delegate = self
        present(cropViewController, animated: true, completion: nil)
    }

    // MARK: - Custom methods
    @objc private func showToolTip() {
        var preferences = EasyTipView.Preferences()
        preferences.drawing.font = UIFont(name: "Inter", size: 12)!
        preferences.drawing.foregroundColor = K.Colors.White
        preferences.drawing.backgroundColor = K.Colors.Blue
        preferences.drawing.arrowPosition = EasyTipView.ArrowPosition.bottom

        EasyTipView.show(forView: cropButton,
                         withinSuperview: self.view,
        text: "Tap to crop or rotate",
        preferences: preferences, delegate: self)
    }
    private func decodeImage() {
        self.showActivityIndicator()
        ScaledElementProcessor().process(in: backgroundImageView!) { (scannedTexts, text, elements) in
            self.removeActivityIndicator()
            elements.forEach { feature in
                DispatchQueue.main.async {[self] in
                    backgroundImageView.layer.addSublayer(frameSubLayer)
                    frameSubLayer.addSublayer(feature.shapeLayer)
                }
            }
            self.scannedTextArray = scannedTexts
            self.scannedText = text
        }
    }

}

extension ReviewPhotoViewController: CropViewControllerDelegate {
    func cropViewController(
        _ cropViewController: CropViewController,
        didCropToImage image: UIImage,
        withRect cropRect: CGRect,
        angle: Int) {
//        remove sublayer from background view so there are no duplicate scan outlines
        self.frameSubLayer.removeFromSuperlayer()
        self.frameSubLayer = CALayer()
        self.backgroundImageView.image = image
        cropViewController.dismiss(animated: true, completion: nil)
    }
}

extension ReviewPhotoViewController: EasyTipViewDelegate {
    func easyTipViewDidTap(_ tipView: EasyTipView) {
        return
    }

    func easyTipViewDidDismiss(_ tipView: EasyTipView) {
        UserDefaults.standard.set(true, forKey: K.imageCropedFirstTime)
    }
}
