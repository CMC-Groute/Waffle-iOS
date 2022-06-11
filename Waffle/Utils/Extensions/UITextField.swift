//
//  UITextField.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/09.
//

import Foundation
import UIKit

extension UITextField {
    enum DirectionType {
        case left, right
    }
//
//    let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.height)) // 왼쪽 아이콘 넣어주는 코드
//            let image = icon
//            let imageView = UIImageView(image: image)
//            imageView.frame = CGRect(x: 12, y: 12, width: 20, height: 20)
//            iconView.addSubview(imageView)
//            self.leftView = iconView
//            self.leftViewMode = .always
//
//            self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: self.frame.height)) //오른쪽 공백 넣어주는 코드
//            self.rightViewMode = .always
    
    func round(corner: CGFloat) {
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
    
    func changeIcon(value: CGFloat, direction: DirectionType, icon: String) {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: self.frame.height))
        let imageView = UIImageView(image: UIImage(named: icon))
        imageView.frame = CGRect(x: 0, y: 10, width: 24, height: 24)
        iconView.addSubview(imageView)
        switch direction {
        case .left:
            self.rightView = iconView
        case .right:
            self.leftView = iconView
        }
    }
    
    func padding(value: CGFloat, direction: DirectionType, icon: String) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.height))
        
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: 34, height: self.frame.height))
        let imageView = UIImageView(image: UIImage(named: icon))
        imageView.frame = CGRect(x: 0, y: 10, width: 24, height: 24)
        iconView.addSubview(imageView)
        
        switch direction {
        case .left:
            self.leftView = view
            self.rightView = iconView
            
            self.leftViewMode = .always
            self.rightViewMode = .never
        case .right:
            self.rightView = view
            self.rightViewMode = .always
        }
        
    }
    
    
}

extension UIButton {
    func round(corner: CGFloat) {
        self.layer.cornerRadius = corner
        self.layer.masksToBounds = true
    }
    
    func circle(corner: CGFloat) {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.layer.masksToBounds = true
    }
}


