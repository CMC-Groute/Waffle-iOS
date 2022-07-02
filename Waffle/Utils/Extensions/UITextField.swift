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
        switch bool {
        case true:
            self.layer.borderColor = .none
            self.layer.borderWidth = 0
            self.rightViewMode = .never
        case false:
            self.layer.borderColor = UIColor(named: Asset.Colors.red.name)?.cgColor
            self.layer.borderWidth = 2
            self.rightViewMode = .always
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
    
    
}

extension UIButton {
    func makeRounded(corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
    }
    
    func makeCircle(corner: CGFloat) {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
    }
}


