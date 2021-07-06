//
//  TextStyle.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/5/20.
//

import Foundation
import UIKit

struct TextStyle {
    enum Style: CGFloat {
        case extraLarge = 24
        case large = 18
        case small = 14
        case extraSmall = 12
        case normal = 16
    }

    enum Emphasis {
        case regular
        case medium
        case semibold
        case bold

    }

    enum Color {
        case white
        case primary
        case black
        case black5
        case black40
        case black60
        case red
    }

    enum Alignment {
        case left
        case right
        case center
    }

    private let style: Style
    private let emphasis: Emphasis
    private let opacity: CGFloat = 0.9
    let lineSpacing: CGFloat
    let color: Color
    let alignment: Alignment

    init(style: Style, color: Color, emphasis: Emphasis, alignment: Alignment, lineSpacing: CGFloat) {
        self.style = style
        self.color = color
        self.emphasis = emphasis
        self.alignment = alignment
        self.lineSpacing = lineSpacing
    }
}

// MARK: - TextStyle extension to enable styling
extension TextStyle {

    /// Get the colour that should be used, taking into account both the colour and the opacity
    ///
    /// - Returns: the colour of the font
    var colorWithAlpha: UIColor {
        // Get the base colour
        let baseColor: UIColor

        switch color {
        case .white:
            baseColor = K.Colors.White
        case .primary:
            baseColor = K.Colors.Blue
        case .black:
            baseColor = K.Colors.Black
        case .black5:
            baseColor = K.Colors.Black5
        case .black60:
            baseColor = K.Colors.Black60
        case .black40:
            baseColor = K.Colors.Black40
        case .red:
            baseColor = K.Colors.Red
        }

        return baseColor.withAlphaComponent(opacity)
    }

    /// Get the font object that should be used for this text style
    ///
    /// - Returns: a UIFont, based on the style and the emphasis
    var font: UIFont {
        let family: String

        switch emphasis {
        case .regular:
        family = "Inter-Regular"

        case .medium:
        family = "Inter-Medium"

        case .bold:
        family = "Inter-Bold"

        case .semibold:
        family = "Inter-SemiBold"
        }

        return UIFont(name: family, size: style.rawValue)!

    }

    /// Gets attributes for the styled font
    ///
    /// - Returns: the font and colour attributes
    var attributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: colorWithAlpha]
    }

    /// Get an attributed string based on the styled font
    ///
    /// - Parameter string: the string
    /// - Returns: an attributed string
    func getAttributedString(string: String) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: attributes)
    }
}

extension UITextField {
    func setTextStyle(with textStyle: TextStyle) {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = textStyle.lineSpacing

        let attrString = NSMutableAttributedString(string: self.text ?? "")

        attrString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0,
                           length: attrString.length
            ))

        self.font = textStyle.font
        self.attributedText = attrString
    }
}

// MARK: - UIButton extension to add styling
extension UIButton {

    func setTitle(with textStyle: TextStyle, for controlState: UIControl.State) {
        setAttributedTitle(textStyle.getAttributedString(string: (self.titleLabel?.text)!), for: controlState)
    }
}

// MARK: - UILabel extension to add styling
extension UILabel {
    func style(with textStyle: TextStyle) {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = textStyle.lineSpacing

        let attrString = NSMutableAttributedString(string: self.text ?? "")

        attrString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(
                location: 0,
                length: attrString.length))

        self.attributedText = attrString

        font = textStyle.font
        textColor = textStyle.colorWithAlpha

        let textAlignment: NSTextAlignment
        switch textStyle.alignment {
        case .center:
            textAlignment = .center
        case .left:
            textAlignment = .left
        case.right:
            textAlignment = .right
        }
        self.textAlignment = textAlignment

    }
}

// MARK: - UIBarButtonItem extension to add styling
extension UIBarButtonItem {
    func style(with textStyle: TextStyle, for controlState: UIControl.State) {
        self.setTitleTextAttributes(textStyle.attributes, for: controlState)
    }
}
