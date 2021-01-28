//
//  MultipleInputStackView.swift
//  mycard
//
//  Created by Joseph Maclean Arhin on 12/13/20.
//

import Foundation
import UIKit
import RxSwift

class PhoneListStackView: UIStackView {
    let numberTypes: [PhoneNumberType] = [.Home, .Mobile, .Work, .Other]
    var activePickerIndex: Int?
    var activeTextField: UITextField?
    func configure(with numbers: [PhoneNumber]) {
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        DispatchQueue.main.async {
            self.removeAllArrangedSubviews()
            for i in 0 ..< numbers.count {
                self.spacing = 16
                
                let stackView = UIStackView()
                stackView.translatesAutoresizingMaskIntoConstraints = false
                stackView.axis = .horizontal
                stackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
                stackView.spacing = 16
                
                let isHidden = numbers.count > 1 ? false : true
                
                let textField = self.setupTextField(with: numbers[i].number, at: i)
                let numberTypeTextfield = self.setupButton(at: i, text: numbers[i].type.rawValue)
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
extension PhoneListStackView {
    @objc func textfieldDidChange(_ textfield: UITextField) {
        var list = PhoneNumberManager.manager.list.value
        list[textfield.tag].number = textfield.text
        PhoneNumberManager.manager.list.accept(list)
    }
    
    
    @objc func removeView(_ button: UIButton) {
        var list = PhoneNumberManager.manager.list.value
        let index = button.tag
        list.remove(at: index)
        PhoneNumberManager.manager.list.accept(list)
    }
    
    @objc func textfieldDidBeginEditing(_ textfield: UITextField) {
        self.activePickerIndex = textfield.tag
        self.activeTextField = textfield
    }
    
}


//MARK: - UI setup
extension PhoneListStackView {
    func setupTextField(with text: String?, at index: Int) -> UITextField{
        let textfield = UITextField()
        textfield.heightAnchor.constraint(equalToConstant: 48).isActive = true
        textfield.backgroundColor = UIColor(named: "MC Black 5")
        textfield.leftPadding = 16
        textfield.rightPadding = 16
        textfield.layer.cornerRadius = 8
        textfield.textContentType = .name
        textfield.keyboardType = .numberPad
        textfield.placeholder = "Phone Number"
        textfield.setTextStyle(with: K.TextStyles.bodyBlack40)
        textfield.tag = index
        textfield.addTarget(self, action: #selector(textfieldDidChange(_:)), for: .editingDidEnd)
        
        if let text = text {
            textfield.text = text
        }
        
        return textfield
    }
    
    func setupButton(at index: Int, text: String?) -> UITextField {

        let numberTypePicker = UITextField()
        numberTypePicker.borderWidth = 1
        numberTypePicker.borderColor = .black
        numberTypePicker.translatesAutoresizingMaskIntoConstraints = false
        numberTypePicker.widthAnchor.constraint(equalToConstant: 108).isActive = true
        numberTypePicker.heightAnchor.constraint(equalToConstant: 48).isActive = true
        numberTypePicker.layer.cornerRadius = 8
        numberTypePicker.tintColor = .black
        numberTypePicker.borderColor = UIColor(named: K.Colors.mcBlack10)
        numberTypePicker.leftPadding = 16
        numberTypePicker.rightPadding = 16
        numberTypePicker.tintColor = .clear
        numberTypePicker.text = text ?? ""

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
extension PhoneListStackView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberTypes[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var list = PhoneNumberManager.manager.list.value
        list[activePickerIndex!].type = numberTypes[row]
        PhoneNumberManager.manager.list.accept(list)
        activeTextField?.resignFirstResponder()
    }
    
}
