//
//  StringExtension.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 1/12/21.
//

import Foundation
import UIKit

extension String {

    enum ValidityType {
        case age
        case email
        case phoneNumber
    }

    enum Regex: String {
        case age = "[0-9]{2,2}"
        case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        case phoneNumber = "^[0-9+]{0,1}+[0-9]{5,16}$"
    }

    func isValid(_ validityType: ValidityType) -> Bool {
        let format = "SELF MATCHES %@"
        var regex = ""

        switch validityType {
        case .age:
            regex = Regex.age.rawValue
        case .email:
            regex = Regex.email.rawValue
        case .phoneNumber:
            regex = Regex.phoneNumber.rawValue
        }

        return NSPredicate(format: format, regex).evaluate(with: self)
    }

    func withBoldText(text: String, font: UIFont? = nil) -> NSAttributedString {
        let _font = font ?? UIFont.systemFont(ofSize: 14, weight: .regular)
        let fullString = NSMutableAttributedString(string: self, attributes: [NSAttributedString.Key.font: _font])
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        let boldFontAttribute: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)
        ]
        let range = (self as NSString).range(of: text)
        fullString.addAttributes(boldFontAttribute, range: range)
        fullString.addAttribute(
            NSAttributedString.Key.paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: fullString.length))
        return fullString
    }

    func getEmails() -> [String]? {
      if let regex = try? NSRegularExpression(
            pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}",
            options: .caseInsensitive) {
          let string = self as NSString

          return regex.matches(
            in: self,
            options: [],
            range: NSRange(location: 0, length: string.length)
          ).map {
              string.substring(with: $0.range).lowercased()
          }
      }
      return nil
    }

    func getWebsite() -> [String]? {
      if let regex = try? NSRegularExpression(
            pattern:
                "((?:http|https)://)?(?:www\\.)?[\\w\\d\\-_]+\\.\\w{2,3}(\\.\\w{2})?(/(?<=/)(?:[\\w\\d\\-./_]+)?)?",
            options: .caseInsensitive) {
          let string = self as NSString

          return regex.matches(in: self, options: [], range: NSRange(location: 0, length: string.length)).map {
              string.substring(with: $0.range).lowercased()
          }
      }
      return nil
    }

    func getPhoneNumbers() -> [String?]? {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return matches.filter {
                return $0.resultType == .phoneNumber
            }.map {
                return $0.phoneNumber
            }

        } catch {
            return nil
        }
    }

    func linguisticTagger() {
        let tagger = NSLinguisticTagger(tagSchemes: [.nameType], options: 0)
        tagger.string = self
        let range = NSRange(location: 0, length: self.utf16.count)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        let tags: [NSLinguisticTag] = [.personalName, .placeName, .organizationName]
        tagger.enumerateTags(in: range, unit: .word, scheme: .nameType, options: options) { tag, tokenRange, _ in
            if let tag = tag, tags.contains(tag) {
                let name = (self as NSString).substring(with: tokenRange)
                print("linguistics \(name): \(tag)")
            }
        }
    }

}
