//
//  UITextField.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/09.
//

import UIKit

extension UITextField {

    func makeRounded(corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
    }
    
    func focusingBorder(color: String?) {
        if let color = color {
            self.layer.borderColor = UIColor(named: color)?.cgColor
            self.layer.borderWidth = 2
        }else {
            self.layer.borderColor = .none
            self.layer.borderWidth = 0
        }
    }
    
    func errorBorder(bool: Bool){
        DispatchQueue.main.async {
            if bool == true {
                self.layer.borderColor = .none
                self.layer.borderWidth = 0
                self.rightViewMode = .never
            }else {
                self.layer.borderColor = UIColor(named: Asset.Colors.red.name)?.cgColor
                self.layer.borderWidth = 2
                self.rightViewMode = .always
            }
        }
    }
    
    func changeIcon(value: CGFloat, icon: String) {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: self.frame.height))
        let imageView = UIImageView(image: UIImage(named: icon))
        imageView.frame = CGRect(x: 0, y: 10, width: 24, height: 24)
        iconView.addSubview(imageView)

        self.rightView = iconView
        self.rightViewMode = .always

    }
    
    func padding(value: CGFloat, icon: String) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.height))
        
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: self.frame.height))
        let imageView = UIImageView(image: UIImage(named: icon))
        imageView.frame = CGRect(x: 0, y: 10, width: 24, height: 24)
        iconView.addSubview(imageView)

        self.leftView = view
        self.rightView = iconView
        
        self.leftViewMode = .always
        self.rightViewMode = .never
    }
    
    func padding(value: CGFloat){

        let editingIconView = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.height))
        self.leftView = editingIconView
        self.leftViewMode = .always
    }
    
    func addIconLeft(value: CGFloat, icon: UIImage, width: CGFloat, height: CGFloat) {
        let editingIconView = UIView(frame: CGRect(x: 0, y: 0, width: value + width + 5, height: self.frame.height))
        let iconImageView = UIImageView(image: icon)
        iconImageView.frame = CGRect(x: value, y: 12, width: width, height: height)
        editingIconView.addSubview(iconImageView)
        self.leftView = editingIconView
        self.leftViewMode = .always
    }
    
    func maxInputTextField(maxLength: Int) {
        guard let text = self.text else { return }
        if text.count > maxLength {
            let index = text.index(text.startIndex, offsetBy: maxLength)
            self.text = String(text[..<index])
        }
    }
    
    func setClearButton(with image: UIImage, mode: UITextField.ViewMode) {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: self.frame.height))
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(image, for: .normal)
        clearButton.frame = CGRect(x: 0, y: 5, width: 40, height: 40)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingDidBegin)
        self.addTarget(self, action: #selector(UITextField.displayClearButtonIfNeeded), for: .editingChanged)
        iconView.addSubview(clearButton)
        self.rightView = iconView
        self.rightViewMode = mode
    }
    
    func changePlaceHolderColor(with color: UIColor = Asset.Colors.gray4.color) {
        if let placeHolderText = self.placeholder {
            self.attributedPlaceholder =
            NSAttributedString(
                string: placeHolderText,
                attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.gray4.color]
            )
        }
    }
        
    @objc
    private func displayClearButtonIfNeeded() {
        self.rightView?.isHidden = (self.text?.isEmpty) ?? true
    }
    
    @objc
    private func clear(sender: AnyObject) {
        self.text = ""
        sendActions(for: .editingChanged)
    }
    
    
}


