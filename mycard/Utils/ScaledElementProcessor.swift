//
//  ScaledElementProcessor.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 4/17/21.
//

import Foundation
import MLKitVision
import MLKitTextRecognition

class ScaledElementProcessor {

    struct ScaledElement {
        let frame: CGRect
        let shapeLayer: CALayer
    }

    var textRecognizer: TextRecognizer
    init() {
        textRecognizer = TextRecognizer.textRecognizer()
    }

    func process(in imageView: UIImageView, completionHandler: @escaping(_ scannedTexts: [String], _ text: String, _ scaledElements: [ScaledElement]) -> Void) {
        guard let image = imageView.image else { return }
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        textRecognizer.process(visionImage) { (result, error) in
            guard error == nil, let result = result, !result.text.isEmpty else {
                completionHandler([""], "", [])
                return
            }

            var scaledElements: [ScaledElement] = []
            var resultText: [String] = []
            var text = result.text

            for block in result.blocks {
                let texts = block.text.split(separator: "\n").map(String.init)
                texts.forEach { text in
                    resultText.append(text)
                }
                for line in block.lines {
                    for element in line.elements {
                        let frame = self.createScaledFrame(
                          featureFrame: element.frame,
                          imageSize: image.size,
                          viewFrame: imageView.frame)
                        let shapeLayer = self.createShapeLayer(frame: frame)
                        let scaledElement = ScaledElement(frame: frame, shapeLayer: shapeLayer)
                        scaledElements.append(scaledElement)

                    }
                }
            }

            completionHandler(resultText, text, scaledElements)
        }
    }

    private func createShapeLayer(frame: CGRect) -> CAShapeLayer {
        let bpath = UIBezierPath(rect: frame)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bpath.cgPath

        shapeLayer.strokeColor = Constants.lineColor
        shapeLayer.fillColor = Constants.fillColor
        shapeLayer.lineWidth = Constants.lineWidth
        return shapeLayer
    }

    private func createScaledFrame(
      featureFrame: CGRect,
      imageSize: CGSize, viewFrame: CGRect)
      -> CGRect {
      let viewSize = viewFrame.size

      // 2
      let resolutionView = viewSize.width / viewSize.height
      let resolutionImage = imageSize.width / imageSize.height

      // 3
      var scale: CGFloat
      if resolutionView > resolutionImage {
        scale = viewSize.height / imageSize.height
      } else {
        scale = viewSize.width / imageSize.width
      }

      // 4
      let featureWidthScaled = featureFrame.size.width * scale
      let featureHeightScaled = featureFrame.size.height * scale

      // 5
      let imageWidthScaled = imageSize.width * scale
      let imageHeightScaled = imageSize.height * scale
      let imagePointXScaled = (viewSize.width - imageWidthScaled) / 2
      let imagePointYScaled = (viewSize.height - imageHeightScaled) / 2

      // 6
      let featurePointXScaled = imagePointXScaled + featureFrame.origin.x * scale
      let featurePointYScaled = imagePointYScaled + featureFrame.origin.y * scale

      // 7
      return CGRect(x: featurePointXScaled,
                    y: featurePointYScaled,
                    width: featureWidthScaled,
                    height: featureHeightScaled)
      }

    private enum Constants {
        static let lineWidth: CGFloat = 1.0
        static let lineColor = K.Colors.White.cgColor
        static let fillColor = K.Colors.Blue10.cgColor
    }
}
