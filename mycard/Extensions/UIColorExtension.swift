//
//  UIColorExtension.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/21/20.
//

import Foundation
import UIKit

extension UIColor {
    static var random: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 1)
    }
    
    static var randomFaded: UIColor {
        return .init(hue: .random(in: 0...1), saturation: 1, brightness: 1, alpha: 0.2)
    }
}

