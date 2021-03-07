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
    var backgroundImage: UIImage?

// MARK: - ViewController methods
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = backgroundImage
    }

// MARK: - Actions
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func arrowButtonPressed(_ sender: Any) {
        decodeImage()
        performSegue(withIdentifier: K.Segues.cameraToAuth, sender: self)
    }

// MARK: - Custom methods
    private func decodeImage() {
        let visionImage = VisionImage(image: backgroundImage!)
        visionImage.orientation = backgroundImage!.imageOrientation

        let textRecognizer = TextRecognizer.textRecognizer()

        textRecognizer.process(visionImage) { (text, error) in
            guard error == nil, let result = text else {
                print("could not decode text")
                return
            }
        }
    }

    private func decodeLinguistics(text: String) {
        let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
        tagger.string = text
        let range = NSRange(location: 0, length: text.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName, .number]
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, _ in
            if let tag = tag, tags.contains(tag) {
                let name = (text as NSString).substring(with: tokenRange)
                print("\(name): \(tag)")
            }
        }
    }
}
