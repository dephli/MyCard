//
//  MultipleInputStackView.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/13/20.
//

import Foundation
import UIKit
import RxSwift

class EmailListStackView: UIStackView {
    let emailTypes = ["Personal", "Work", "Other"]
    var activePickerIndex: Int?
    var activeTextField: UITextField?
    func configure(with emails: [Email]) {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self

                DispatchQueue.main.async {
                    self.removeAllArrangedSubviews()
                    for i in 0 ..< emails.count {
                        self.spacing = 16
                        
                        let stackView = UIStackView()
                        stackView.translatesAutoresizingMaskIntoConstraints = false
                        stackView.axis = .horizontal
                        stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                        stackView.spacing = 16
                        
                        let isHidden = emails.count > 1 ? false : true
                        
                        let textField = self.setupTextField(with: emails[i].address, at: i)
                        let numberTypeTextfield = self.pickerTextfield(at: i, text: emails[i].type)
                        numberTypeTextfield.inputView = pickerView
                        let minusButton = self.setupMinusButton(at: i, isHidden: isHidden)
                        stackView.addArrangedSubview(textField)
                        stackView.addArrangedSubview(numberTypeTextfield)
                        stackView.addArrangedSubview(minusButton)
                        self.addArrangedSubview(stackView)
                    }
                }
        
    }

}


//MARK: - actions
extension EmailListStackView {
    @objc func textfieldDidChange(_ textfield: UITextField) {
        var list = EmailManager.manager.list.value
        list[textfield.tag].address = textfield.text!
        
        EmailManager.manager.list.accept(list)
    }
    
    
    @objc func removeView(_ button: UIButton) {
        var list = EmailManager.manager.list.value
        let index = button.tag
        list.remove(at: index)
        EmailManager.manager.list.accept(list)
    }
    
    @objc func textfieldDidBeginEditing(_ textfield: UITextField) {
        self.activePickerIndex = textfield.tag
        self.activeTextField = textfield
    }
    
}


//MARK: - UI setup
extension EmailListStackView {
    func setupTextField(with text: String?, at index: Int) -> UITextField{
        
//        Setup text field
        let textfield = UITextField()
        textfield.heightAnchor.constraint(equalToConstant: 48).isActive = true
        textfield.backgroundColor = UIColor(named: "MC Black 5")
        textfield.leftPadding = 16
        textfield.rightPadding = 16
        textfield.layer.cornerRadius = 8
        textfield.textContentType = .emailAddress
        textfield.keyboardType = .emailAddress
        textfield.placeholder = "Email Address"
        textfield.setTextStyle(with: K.TextStyles.bodyBlack40)
        textfield.tag = index
        textfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingDidEnd)
        
        if let text = text {
            textfield.text = text
        }
        
        return textfield
    }
    
    func pickerTextfield(at index: Int, text: String?) -> UITextField {
        
//        setup textfield for uipicker

        let numberTypePicker = UITextField()
        numberTypePicker.borderWidth = 1
        numberTypePicker.borderColor = .black
        numberTypePicker.translatesAutoresizingMaskIntoConstraints = false
        numberTypePicker.widthAnchor.constraint(equalToConstant: 108).isActive = true
        numberTypePicker.heightAnchor.constraint(equalToConstant: 48).isActive = true
        numberTypePicker.layer.cornerRadius = 8
        numberTypePicker.tintColor = .clear
        numberTypePicker.borderColor = UIColor(named: K.Colors.mcBlack10)
        numberTypePicker.leftPadding = 16
        numberTypePicker.rightPadding = 16
        numberTypePicker.text = text ?? ""
        numberTypePicker.setTextStyle(with: K.TextStyles.bodyBlack40)

        numberTypePicker.tag = index
    
        
        let imageView = UIImageView(frame: CGRect(x: -16, y: 0, width: 8, height: 4))
        let image = UIImage(named: "chevron down")
        imageView.image = image
        
        numberTypePicker.rightView = UIView(frame: CGRect(x: -10, y: 0, width: 8, height: 4))
        numberTypePicker.rightView?.addSubview(imageView)
        numberTypePicker.rightViewMode = .always
        
        numberTypePicker.addTarget(self, action: #selector(textfieldDidBeginEditing(_:)), for: .editingDidBegin)
        
        
        
        return numberTypePicker
    }
    
    func setupMinusButton(at index: Int, isHidden: Bool) -> UIButton {
        let minusButton = UIButton()
        minusButton.setImage(UIImage(named: "remove"), for: .normal)
        minusButton.tintColor = .black
        minusButton.widthAnchor.constraint(equalToConstant: 16).isActive = true
        minusButton.tag = index
        minusButton.addTarget(self, action: #selector(removeView(_:)), for: .touchUpInside)
        if isHidden == true {
            minusButton.alpha = 0
            minusButton.isEnabled = false
        }

        return minusButton
    }
}

//MARK: - PickerView Delegate
extension EmailListStackView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return emailTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return emailTypes[row ]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var list = EmailManager.manager.list.value
        list[activePickerIndex!].type = emailTypes[row]
        EmailManager.manager.list.accept(list)
        activeTextField?.resignFirstResponder()
    }
    
}
