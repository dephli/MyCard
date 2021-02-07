//
//  OneTimeTextField.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/7/20.
//

import Foundation
import UIKit

class OneTimeTextField: UITextField {
    
    var didEnterLastDigit: ((String) -> Void)?
    
    private var isConfigured = false
    private var digitalLabel = [UILabel]()
    
    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(becomeFirstResponder))
        return recognizer
    }()
    
    
    func configure(with slotCount: Int = 6) {
        guard isConfigured == false else {
            return
        }
        isConfigured.toggle()
        configureTextField()
        addGestureRecognizer(tapRecognizer)
        
        let labelStackView = createLabelStackView(with: slotCount)
        addSubview(labelStackView)
        
        NSLayoutConstraint.activate([
            labelStackView.topAnchor.constraint(equalTo: topAnchor),
            labelStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            labelStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func configureTextField() {
        tintColor = .clear
        textColor = .clear
        keyboardType = .numberPad
        textContentType = .oneTimeCode
        delegate = self
        
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    private func createLabelStackView(with count: Int) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        
        for _ in 1 ... count {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.style(with: K.TextStyles.bodyBlack60)
            label.backgroundColor = K.Colors.Black5
            label.layer.cornerRadius = 8
            label.layer.masksToBounds = true
            label.isUserInteractionEnabled = true
            label.textAlignment = .center
            
            stackView.addArrangedSubview(label)
            digitalLabel.append(label)
        }
        
        return stackView
    }
    
    @objc
    private func textDidChange() {
        
        guard let text = self.text, text.count <= digitalLabel.count else { return }
        
        for i in 0 ..< digitalLabel.count {
            let currentLabel = digitalLabel[i]
            
            if i < text.count {
                let index = text.index(text.startIndex, offsetBy: i)
                currentLabel.text =  String(text[index])
            } else {
                currentLabel.text? .removeAll() 
            }
        }
        
        if text.count == digitalLabel.count {
            didEnterLastDigit?(text)
        }
        
    }
}

extension OneTimeTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let characterCount = textField.text?.count else { return false }
        
        return characterCount < digitalLabel.count || string == ""
    }
}
