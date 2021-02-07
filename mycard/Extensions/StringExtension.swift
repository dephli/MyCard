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
      let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: _font.pointSize)]
      let range = (self as NSString).range(of: text)
      fullString.addAttributes(boldFontAttribute, range: range)
      return fullString
    }
}
