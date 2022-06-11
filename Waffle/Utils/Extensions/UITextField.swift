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
        case false:
            self.layer.borderColor = UIColor(named: Asset.Colors.red.name)?.cgColor
            self.layer.borderWidth = 2
        }
    }
    
    func padding(value: CGFloat, direction: DirectionType) {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: value, height: self.frame.height))
        
        switch direction {
        case .left:
            self.leftView = view
            self.leftViewMode = .always
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


