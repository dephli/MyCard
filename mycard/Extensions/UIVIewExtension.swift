//
//  UIVIewExtension.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/30/20.
//

import Foundation
import UIKit


extension UIView {
    func setGradientBackground(colorTop: UIColor, colorBottom: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop.cgColor, colorBottom.cgColor]
        
        gradientLayer.locations = [0.46, 1]

        gradientLayer.startPoint = CGPoint(x: 0.25, y: 0.5)

        gradientLayer.endPoint = CGPoint(x: 0.75, y: 0.5)

        gradientLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 0, b: 1.41, c: -1.41, d: 0, tx: 1.2, ty: 0))



        gradientLayer.position = self.center

        gradientLayer.frame = bounds

       layer.insertSublayer(gradientLayer, at: 0)
    }
}
